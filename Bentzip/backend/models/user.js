const mongoose = require("mongoose");

const User = mongoose.model(
  "user",
  new mongoose.Schema({
    _id: {
      type: String,
      trim: true,
      required: true,
    },
    name: {
      type: String,
      trim: true,
      required: true,
    },
    address: {
      type: String,
      trim: true,
      required: true,
    },
    dob: {
      type: Date,
      required: true,
    },
    school: {
      type: String,
      trim: true,
      required: true,
    },
    class: {
      type: String,
      trim: true,
    },
    role: {
      type: Number,
      required: true,
    },
    contact: {
      type: [Number],
      trim: true,
      required: true,
    },
  })
);

module.exports = User;
