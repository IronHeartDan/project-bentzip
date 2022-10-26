// Bentzip

// Imports
const express = require("express");
const { default: mongoose } = require("mongoose");
const DB = require("./mongoose/database");
const dotenv = require("dotenv");
const verify = require("./authVerify");
const jwt = require("jsonwebtoken");


// Configs
const app = express();
app.use(express.json());
const server = require("http").createServer(app);
const PORT = process.env.PORT || 3001;

// Models Import
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
        role: user.role,
      });

    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // Add Class
  app.post("/addClass", async (req, res) => {
    if (checkBody(req.body)) {
      try {
        // Save Class
        let model = new Class(req.body);
        await model.save();
        res.status(200).send();
      } catch (error) {
        res.status(500).send(error);
        console.error(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });
  // Add Class

  // Add Teacher
  app.post("/addTeacher", verify, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
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
          res.status(200).send("OK");
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


  // Add Student
  app.post("/addStudent", verify, async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
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
          res.status(200).send("OK");
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

  // Server Listening
  server.listen(PORT, () => {
    console.log(`Bentzip Server Running On Port ${PORT}`);
  });
}

function checkBody(body) {
  let isEmpty = Object.keys(body).length == 0;
  if (body && !isEmpty) {
    return true;
  } else {
    return false;
  }
}
