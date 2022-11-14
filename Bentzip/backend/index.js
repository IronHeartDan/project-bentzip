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

  // Config Node Mailer
  let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.MAIL_ID,
      pass: process.env.MAIL_PASSWORD,
    },
  });

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
        role: user.role,
      });

    } else {
      res.status(400).send("Request Body not found");
    }
  });

  app.post("/resetPassword", async (req, res) => {
    try {
      let mail = await transporter.sendMail({
        from: process.env.MAIL_ID,
        to: "danishkhan.dk2.dk16@gmail.com",
        subject: "Test Mail",
        text: "Yaay",
      });
      console.log(mail.accepted);
      res.status(200).send(mail);
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
            'school': `${req.query.school}`
          }
        }, {
          '$group': {
            '_id': {
              'standard': '$standard'
            },
            'classes': {
              '$push': {
                '_id': '$_id',
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
      let schoolClass = await Class.findById(req.query.id);
      res.status(200).send(schoolClass);
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

  // Server Listening
  server.listen(PORT, () => {
    console.log(`Bentzip Server Running On Port ${PORT}`);
  });
}