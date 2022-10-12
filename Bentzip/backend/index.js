// Bentzip

// Imports
const express = require("express");
const { default: mongoose } = require("mongoose");
const DB = require("./mongoose/database");

// Configs
const app = express();
app.use(express.json());
const server = require("http").createServer(app);
const PORT = process.env.PORT || 3001;

// Models Import
const Class = require("./models/class");
const Counter = require("./models/counter");
const User = require("./models/user");

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
  app.post("/addTeacher", async (req, res) => {
    let body = req.body;
    if (checkBody(body)) {
      let session = await mongoose.startSession();
      try {
        let results = await session.withTransaction(async () => {
          // Save School
          let user = new User(body);
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

  // End Of Add Teacher

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
