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
      type: Number,
      required: true,
    },
    section: {
      type: String,
      required: true,
    },
  })
);

module.exports = Class;
