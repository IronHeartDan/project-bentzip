const mongoose = require("mongoose");

const Class = mongoose.model(
  "class",
  new mongoose.Schema({
    school: {
      type: String,
      trim: true,
      required: true,
    },
    standard: {
      type: String,
      required: true,
    },
    section: {
      type: String,
      required: true,
    },
    teacher: {
      type: String,
      trim: true,
    },
  })
);

module.exports = Class;
