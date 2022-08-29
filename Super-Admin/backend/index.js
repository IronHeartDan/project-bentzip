// Bentzip

// Imports
const express = require("express");
const mongoose = require("mongoose");
const DB = require("./mongoose/database");

// Configs
const app = express();
app.use(express.json());
const server = require("http").createServer(app);
const PORT = process.env.PORT || 3000;

// Models Import
const SchoolModel = require("./models/school");
const Counter = require("./models/counter");

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

  // Add School
  app.post("/addSchool", async (req, res) => {
    var isEmpty = Object.keys(req.body).length == 0;
    let body = req.body;
    if (body && !isEmpty) {
      let model = new SchoolModel(body);
      let counter = new Counter({ school: model.code });

      let session = await mongoose.startSession();
      session.withTransaction(async () => {
        try {
          await model.save();
          await counter.save();
          res.status(200).send("OK");
        } catch (error) {
          console.log(error);
          res.status(500).send(error);
        }
      });
    } else {
      res.status(400).send("Request Body not found");
    }
  });

  // Server Listening
  server.listen(PORT, () => {
    console.log(`Bentzip Server Running On Port ${PORT}`);
  });
}
