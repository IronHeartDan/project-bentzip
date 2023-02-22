// Bentzip

// Imports
const express = require("express");
const { default: mongoose } = require("mongoose");
const DB = require("./mongoose/database");
const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const cors = require("cors");
const nodemailer = require("nodemailer");
const { checkBody, verifyAuth, checkSchool } = require("./util");


// Configs
const app = express();
app.use(cors());
app.use(express.json());
const server = require("http").createServer(app);
const PORT = process.env.PORT || 3001;

// Models Import
const School = require("./models/school");
const Admin = require("./models/admin");
const Teacher = require("./models/teacher");
const Student = require("./models/student");
const Class = require("./models/class");
const Counter = require("./models/counter");
const Leave = require("./models/leave");
const Notice = require("./models/notice");
const { StudentAttendance, TeacherAttendance } = require("./models/attendance");
const Record = require("./models/record");


DB.connectDB()
  .then(() => {
    console.log("Database Connected");
    startServer();
  })
  .catch((error) => console.error(error));

// Start Server

async function startServer() {
  // Config Env
  dotenv.config();

  // Base Server Request
  app.get("/", (req, res) => {
    res.status(200).send("Bentzip Server Running");
  });

  // Auth
  app.post("/login", async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      let collection = mongoose.connection.db.collection("users");
      let user = await collection.findOne({ _id: body.id });
      if (!user) return res.status(400).send({ "id": -1 });
      if (user.password != body.password) return res.status(400).send({ "password": -1 });

      let token = jwt.sign({
        id: user._id,
        school: user.school
      }, process.env.JSON_SECRET);

      res.status(200).send({
        token: token,
        name: user.name ?? null,
        school: user.school,
        class: user.class ?? null,
        id: user._id,
        role: user.role,
      });

    } else {
      res.status(400).send("Request Body not found");
    }
  });

  app.post("/resetPassword", async (req, res) => {
    try {

    } catch (error) {
      res.status(400).send(error);
    }
  });

  // Class

  // Add Class
  app.post("/addClass", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      try {
        await Class.ensureIndexes();
        // School Check
        if (await checkSchool(body.school)) return res.status(400).send("School not found");
        // Save Class
        let model = new Class(body);
        await model.save();
        res.status(200).send();
      } catch (error) {
        res.status(400).send(error);
        console.error(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });
  // Add Class

  // Get School Classes
  app.get("/getClasses", verifyAuth, async (req, res) => {
    try {
      // School Check
      if (await checkSchool(req.query.school)) return res.status(400).send("School not found");
      // let classes = await Class.find({ school: req.params.school });
      let classes = await Class.aggregate([
        {
          '$match': {
            'school': parseInt(req.query.school)
          }
        }, {
          '$group': {
            '_id': {
              'standard': '$standard'
            },
            'classes': {
              '$push': {
                'id': '$_id',
                'section': '$section'
              }
            }
          }
        }, {
          '$replaceWith': {
            'standard': '$_id.standard',
            'classes': '$classes'
          }
        }, {
          '$sort': {
            'standard': 1
          }
        }
      ]);
      res.status(200).send(classes);
    } catch (error) {
      res.status(400).send(error);
    }
  });


  // Get Class
  app.get("/getClass", verifyAuth, async (req, res) => {
    try {
      let schoolClass = await Class.aggregate([
        {
          '$match': {
            '_id': mongoose.Types.ObjectId(req.query.id),
          }
        }, {
          '$lookup': {
            'from': 'users',
            'localField': '_id',
            'foreignField': 'class',
            'as': 'students',
            'pipeline': [
              {
                '$match': {
                  'role': 2
                }
              }, {
                '$project': {
                  '_id': 1,
                  'name': 1
                }
              }
            ]
          }
        }, {
          '$lookup': {
            'from': 'users',
            'localField': '_id',
            'foreignField': 'class',
            'as': 'teachers',
            'pipeline': [
              {
                '$match': {
                  'role': 1
                }
              }, {
                '$project': {
                  '_id': 1,
                  'name': 1
                }
              }
            ]
          }
        }
      ]);
      res.status(200).send(schoolClass[0]);
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // End Class

  // Teacher 

  // Add Teacher
  app.post("/addTeacher", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      // School Check
      if (await checkSchool(body.school)) return res.status(400).send("School not found");
      let session = await mongoose.startSession();
      try {
        let collection = mongoose.connection.db.collection("users");
        let match = await collection.findOne({ email: body.email });
        if (match) return res.status(400).send({ email: -1 });
        await session.withTransaction(async () => {
          // Increment School Teacher Count
          let count = await Counter.findByIdAndUpdate(
            body.school,
            {
              $inc: {
                teacherCount: 1,
              },
            },
            {
              new: true,
              session: session,
            }
          );

          let id = `${new Date().getFullYear()}${count.schoolEntry}${count.teacherCount}`;

          // Save Teacher
          body._id = id;
          let user = new Teacher(body);
          await user.save({ session: session });

          // Commit Transaction
          await session.commitTransaction();

          // Return
          res.status(200).send(id);
        });
      } catch (error) {
        res.status(400).send(error);
      } finally {
        await session.endSession();
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // End Of Add Teacher

  // Get Teachers
  app.get("/getTeachers", verifyAuth, async (req, res) => {
    try {
      // School Check
      if (await checkSchool(req.query.school)) return res.status(400).send("School not found");
      // let classes = await Class.find({ school: req.params.school });
      let teachers = await Teacher.aggregate([
        {
          '$match': {
            'school': `${req.query.school}`,
            'role': 1
          }
        }, {
          '$sort': {
            'name': 1
          }
        }
      ]);
      res.status(200).send(teachers);
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // Get Teachers


  // Find Teacher
  app.get("/getTeacher", verifyAuth, async (req, res) => {
    try {
      let teacher = await Teacher.findOne({ _id: req.query.id, school: req.query.school, role: 1 });
      res.status(200).send(teacher);
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // Assign Class
  app.put("/assignClass", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      try {
        await Teacher.updateMany({ _id: { '$in': body.teachers } }, { class: body.class });
        res.status(200).send("OK");
      } catch (error) {
        res.status(400).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // End Of Find Teacher

  // End Teacher


  // Add Student
  app.post("/addStudent", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      // School Check
      if (await checkSchool(body.school)) return res.status(400).send("School not found");
      let collection = mongoose.connection.db.collection("users");
      let match = await collection.findOne({ email: body.email });
      if (match) return res.status(400).send({ email: -1 });
      let session = await mongoose.startSession();
      try {
        await session.withTransaction(async () => {
          // Increment School Teacher Count
          let count = await Counter.findByIdAndUpdate(
            body.school,
            {
              $inc: {
                studentCount: 1,
              },
            },
            {
              new: true,
              session: session,
            }
          );

          let id = `${new Date().getFullYear()}${count.schoolEntry}${count.studentCount}`;

          // Save Student
          body._id = id;
          let user = new Student(body);
          await user.save({ session: session });

          // Commit Transaction
          await session.commitTransaction();

          // Return
          res.status(200).send(id);
        });
      } catch (error) {
        console.log(error);
        res.status(400).send(error);
      } finally {
        await session.endSession();
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // End Of Add Student

  // Find Student
  app.get("/getStudent", verifyAuth, async (req, res) => {
    try {
      let student = await Student.aggregate([
        {
          '$match': {
            '_id': parseInt(req.query.id),
            'school': `${req.query.school}`,
            'role': 2
          }
        }, {
          '$lookup': {
            'from': 'classes',
            'localField': 'class',
            'foreignField': '_id',
            'as': 'class'
          }
        }, {
          '$unwind': {
            'path': '$class'
          }
        }
      ]);
      res.status(200).send(student[0]);
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // End Of Find Student


  // Leaves

  // Request For Leave / Add Leave
  app.post("/requestLeave", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      try {
        let leave = new Leave(body);
        await leave.save();
        res.status(200).send("OK");
      } catch (error) {
        res.status(400).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // Get Leaves
  app.get("/getLeaveRequests", verifyAuth, async (req, res) => {
    try {
      let leaves = await Leave.aggregate([
        {
          '$match': {
            'school': parseInt(req.query.school),
          }
        }, {
          '$lookup': {
            'from': 'users',
            'localField': 'user',
            'foreignField': '_id',
            'as': 'user',
            'pipeline': [{
              '$project': {
                '_id': 0,
                'userId': '$_id',
                'name': 1,
                'role': 1
              }
            }
            ]
          }
        }, {
          '$unwind': {
            'path': '$user'
          }
        }, {
          '$replaceWith': {
            '$mergeObjects': [
              '$$ROOT', '$user'
            ]
          }
        }, {
          '$unset': 'user'
        },
        {
          '$sort': {
            '_id': -1
          }
        }
      ]);
      res.status(200).send(leaves);
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // Leave Action
  app.post("/updateLeave", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      try {
        let result = await Leave.findByIdAndUpdate(body.id, {
          $set: {
            status: body.status,
          }
        }, { new: true });
        res.status(200).send(result);
      } catch (error) {
        res.status(400).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });
  // End Of Leaves

  // Notices

  // Add Notice

  app.post("/addNotice", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      try {
        let notice = new Notice(body);
        await notice.save();
        res.status(200).send("OK");
      } catch (error) {
        res.status(400).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });


  // Get Notices

  app.get("/getNotices", verifyAuth, async (req, res) => {
    try {
      let notices = await Notice.find({ school: req.query.school }).sort({ "_id": -1 });
      res.status(200).send(notices);
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // End Notice

  // Attendance

  // Set Attendance
  app.post("/setAttendance", verifyAuth, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      try {
        let users = body.users;
        if (body.role == 1) {
          await TeacherAttendance.insertMany(users)
        } else {
          await StudentAttendance.insertMany(users)
        }
        res.status(200).send("OK");
      } catch (error) {
        res.status(400).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // End Attendance


  // Promote Students
  app.post("/promote", verifyAuth, async (req, res) => {
    let body = req.body;

    if (checkBody(body)) {

      let currentClass = await Class.findById(body.class);
      let nextClasses = await getNextClasses(currentClass);

      if (nextClasses.length == 0) {

        // Get Students from the Higher class and Save Record
        let students = await Student.find({ class: body.class });
        students = students.map(student => {
          student.class = null;
          return new Record({ user: student })
        });

        let session = await mongoose.startSession();
        try {
          await session.withTransaction(async () => {
            await Record.bulkSave(students, { session: session });

            // Deleting From User Collection
            await Student.deleteMany({ class: body.class }, { session: session });
            res.status(200).send("OK");
          });
        } catch (error) {
          res.status(400).send(error);
        } finally {
          session.endSession();
        }

      } else {

        // Check for next class with Section
        let nextClass = nextClasses.find(schoolClass => schoolClass.section == currentClass.section);
        if (nextClass) {
          // Check Student Count Of Higher Class
          if (await getStudentCount(nextClass.id) == 0) {
            // Updating Current Class Students to Higher Class
            try {
              await Student.updateMany({ class: currentClass.id }, { class: nextClass.id });
              res.status(200).send("OK");
            } catch (error) {
              res.status(400).send(error);
            }
          } else {
            res.status(400).send("Please Promote The Higher Class First.");
          }
        } else {
          res.status(400).send("Higher Class Section Doesn't Exists");
        }
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });
  // End Promote Studentsx

  // Get Next Classes 
  async function getNextClasses(currentClass) {
    return await Class.find({ school: currentClass.school, standard: { "$gt": currentClass.standard } });
  }
  // End Get Next Classes 

  // Get Student Count
  async function getStudentCount(id) {
    return (await Student.find({ class: id })).length;
  }
  // End Get Student Count

  // Server Listening
  server.listen(PORT, () => {
    console.log(`Bentzip Server Running On Port ${PORT}`);
  });
}