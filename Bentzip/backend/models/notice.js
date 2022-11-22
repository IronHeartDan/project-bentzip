const mongoose = require("mongoose");

const Notice = mongoose.model("notice", new mongoose.Schema({
    title: {
        type: String,
        trim: true,
        required: true,
    },
    description: {
        type: String,
        trim: true,
        required: true,
    },
    school: {
        type: Number,
        trim: true,
        required: true,
    },
    date: {
        type: Date,
        default: Date.now()
    },
}));

module.exports = Notice;