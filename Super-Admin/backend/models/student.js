const mongoose = require("mongoose");

const GuardianSchema = mongoose.Schema({
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
}, { _id: false });

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
      sparse: true,
      type: String,
      trim: true,
      required: false,
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
    guardian: {
      type: [GuardianSchema],
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
      type: mongoose.Schema.Types.ObjectId,
      required: true,
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
