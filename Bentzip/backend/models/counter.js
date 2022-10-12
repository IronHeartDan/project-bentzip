const mongoose = require("mongoose");

const Counter = mongoose.model(
  "schoolCounter",
  new mongoose.Schema({
    _id: {
      type: Number,
      trim: true,
      required: true,
    },
    schoolEntry: {
      type: Number,
      required: true,
      unique: true,
    },
    teacherCount: {
      type: Number,
      default: 1000,
    },
    studentCount: {
      type: Number,
      default: 1000,
    },
  }),
  "counters"
);

module.exports = Counter;
