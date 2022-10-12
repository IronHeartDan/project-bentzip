const mongoose = require("mongoose");

const mainCounter = mongoose.model(
  "mainCounter",
  new mongoose.Schema({
    _id: {
      type: Number,
      trim: true,
      required: true,
    },
    schoolCount: {
      type: Number,
      default: 1000,
    },
  }),
  "counters"
);

module.exports = mainCounter;
