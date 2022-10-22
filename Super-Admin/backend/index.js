// Bentzip

// Imports
const express = require("express");
const { default: mongoose } = require("mongoose");
const dotenv = require("dotenv");
const DB = require("./mongoose/database");
const verify = require("./authVerify");
const jwt = require("jsonwebtoken");


// Configs
const app = express();
app.use(express.json());
const server = require("http").createServer(app);
const PORT = process.env.PORT || 3000;

// Models Import
const SchoolModel = require("./models/school");
const Counter = require("./models/counter");
const mainCounter = require("./models/mainCounter");
const SuperAdmin = require("./models/superAdmin");

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


  // Super Admin Auth

  // Create Super Admin
  app.post("/createSuperAdmin", async (req, res) => {
    var isEmpty = Object.keys(req.body).length == 0;
    let body = req.body;
    if (body && !isEmpty) {
      try {
        let superAdmin = new SuperAdmin(body);
        await superAdmin.save();
        res.status(200).send("OK");
      } catch (error) {
        console.log(error);
        res.status(200).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });


  // Log Auper Admin
  app.post("/logSuperAdmin", async (req, res) => {
    var isEmpty = Object.keys(req.body).length == 0;
    let body = req.body;
    if (body && !isEmpty) {
      console.log(body);
      try {
        let superAdmin = await SuperAdmin.findOne({
          email: body.email,
        });

        if (!superAdmin) return res.status(400).send({ "email": -1 });

        if (superAdmin.password != body.password) return res.status(400).send({ "password": -1 });

        let token = jwt.sign(body, process.env.JSON_SECRET);
        res.header("auth-token", token).send(token);
      } catch (error) {
        res.status(500).send(error);
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  //Main Counter
  app.post("/setMainCounter", verify, async (req, res) => {
    try {
      let counter = new mainCounter({
        _id: 0,
      });

      await counter.save();
      res.status(200).send("OK");
    } catch (error) {
      console.log(error);
      res.status(200).send(error);
    }
  });

  // Add School
  app.post("/addSchool", verify, async (req, res) => {
    var isEmpty = Object.keys(req.body).length == 0;
    let body = req.body;
    if (body && !isEmpty) {
      let session = await mongoose.startSession();
      try {
        let results = await session.withTransaction(async () => {
          // Save School
          let school = new SchoolModel(body);
          await school.save({ session: session });

          // Increment School Count
          let count = await mainCounter.findByIdAndUpdate(
            0,
            {
              $inc: {
                schoolCount: 1,
              },
            },
            {
              new: true,
              session: session,
            }
          );

          // Save Unique School Counter
          let counter = new Counter({
            _id: school._id,
            schoolEntry: count.schoolCount,
          });
          await counter.save({ session: session });

          // Commit Transaction
          await session.commitTransaction();

          // Return
          res.status(200).send("OK");
        });
      } catch (error) {
        res.status(500).send(error);
      } finally {
        await session.endSession();
      }
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // End Of Add School

  // Activate / Deactivate School

  app.post("/setSchoolStatus", (req, res) => {
    var isEmpty = Object.keys(req.body).length == 0;
    let body = req.body;
    if (body && !isEmpty) {
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // Server Listening
  server.listen(PORT, () => {
    console.log(`Bentzip Server Running On Port ${PORT}`);
  });
}
