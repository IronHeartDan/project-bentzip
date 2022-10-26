const mongoose = require("mongoose");

const gaurdian = mongoose.Schema({
  name: {
    type: String,
    trim: true,
    required: true,
  },
  contact: {
    type: Number,
    trim: true,
    required: true,
  },
  address: {
    type: String,
    trim: true,
    required: true,
  },
},{ _id : false });

const Student = mongoose.model(
  "Student",
  new mongoose.Schema({
    _id: {
      type: Number,
      trim: true,
      required: true,
    },
    email: {
      unique: true,
      type: String,
      trim: true,
      required: true,
    },
    password: {
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
    gaurdian: {
      type: [gaurdian],
      trim: true,
      required: true,
      validate: [(data) => { return data.length > 0 }, "Gaurdian Required"],
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
      validate: [(data) => { return data.length > 0 }, "Contact Required"],
    },
  }),
  "users"
);

module.exports = Student;
