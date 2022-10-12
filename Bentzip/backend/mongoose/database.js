// Databse

// Imports
const mongoose = require("mongoose");

// Config
const DB_URI =
  "mongodb+srv://SuperAdmin:CVuH3vUK1XwwCfSo@cluster0.wqe9a08.mongodb.net/?retryWrites=true&w=majority";

async function connectDB() {
  await mongoose.connect(DB_URI, {
    dbName: "database",
  });
}

module.exports = {
  connectDB,
};
