const mongoose = require("mongoose");

const Counter = mongoose.model(
  "counter",
  new mongoose.Schema({
    school: {
      type: String,
      trim: true,
      required: true,
      unique: true,
    },
    teachers: {
      type: Number,
      default: 1000,
    },
    students: {
      type: Number,
      default: 1000,
    },
  })
);

module.exports = Counter;
