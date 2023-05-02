const mongoose = require("mongoose");

const EducationSchema = new mongoose.Schema({
  institution: {
    type: String,
    trim: true,
    required: true,
  },
  qualification: {
    type: String,
    trim: true,
    required: true,
  },
  start: {
    type: String,
    trim: true,
    required: true,
  },
  end: {
    type: String,
    trim: true,
    required: true,
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
}, { _id: false });

const Teacher = mongoose.model(
  "Teacher",
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
    education: {
      type: [EducationSchema],
      required: true,
      validate: [(data) => { return data.length > 0 }, "Education Required"],
    },
    school: {
      type: String,
      trim: true,
      required: true,
    },
    class: {
      type: mongoose.Schema.Types.ObjectId,
    },
    role: {
      type: Number,
      required: true,
    },
    contact: {
      type: [Number],
      default: undefined,
      required: true,
      validate: [(data) => { return data.length > 0 }, "Contact Required"],
    },
  }),
  "users"
);

module.exports = Teacher;
