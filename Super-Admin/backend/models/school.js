const mongoose = require("mongoose");

const School = mongoose.model(
  "school",
  new mongoose.Schema({
    code: {
      type: String,
      trim: true,
      required: true,
      unique: true,
    },
    name: {
      type: String,
      trim: true,
      required: true,
    },
    principal: {
      type: String,
      trim: true,
      required: true,
    },
    email: {
      type: String,
      trim: true,
      required: true,
      unique: true,
    },
    website: {
      type: String,
      trim: true,
    },
    state: {
      type: String,
      trim: true,
      required: true,
    },
    city: {
      type: String,
      trim: true,
      required: true,
    },
    address: {
      type: String,
      trim: true,
      required: true,
    },
    contact: {
      type: [Number],
      trim: true,
      required: true,
    },
    doi: {
      type: Date,
      required: true,
    },
    joined: {
      type: Date,
      default: Date.now(),
    },
    active: {
      type: Boolean,
      required: true,
    },
  })
);

module.exports = School;
