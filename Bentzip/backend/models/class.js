const mongoose = require("mongoose");

const classSchema = new mongoose.Schema({
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
});

classSchema.index({ "school": 1, "standard": 1, "section": 1 }, { unique: true });

const Class = mongoose.model(
  "class",
  classSchema
);

module.exports = Class;
