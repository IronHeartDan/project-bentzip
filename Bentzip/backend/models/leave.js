const mongoose = require("mongoose");

const Leave = mongoose.model("leave", new mongoose.Schema({
    user: {
        type: Number,
        trim: true,
        required: true,
    },
    school: {
        type: Number,
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
    reason: {
        type: String,
        trim: true,
        required: true,
    },
    status: {
        type: Number,
        required: true,
    },
})
);

module.exports = Leave;