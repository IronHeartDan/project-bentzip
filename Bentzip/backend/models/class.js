const mongoose = require("mongoose");

const classSchema = new mongoose.Schema({
  school: {
    type: Number,
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
});

classSchema.index({ "school": 1, "standard": 1, "section": 1 }, { unique: true });

const Class = mongoose.model(
  "class",
  classSchema
);

module.exports = Class;
