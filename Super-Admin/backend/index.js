// Bentzip

// Imports
const express = require("express");
const { default: mongoose } = require("mongoose");
const DB = require("./mongoose/database");

// Configs
const app = express();
app.use(express.json());
const server = require("http").createServer(app);
const PORT = process.env.PORT || 3000;

// Models Import
const SchoolModel = require("./models/school");
const Counter = require("./models/counter");
const mainCounter = require("./models/mainCounter");

DB.connectDB()
  .then(() => {
    console.log("Database Connected");
    startServer();
  })
  .catch((error) => console.error(error));

// Start Server

async function startServer() {
  // Base Server Request
  app.get("/", (req, res) => {
    res.status(200).send("Bentzip Server Running");
  });

  app.post("/setMainCounter", async (req, res) => {
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
  app.post("/addSchool", async (req, res) => {
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
