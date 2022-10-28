const mongoose = require("mongoose");

const attendance = mongoose.model("attendance", new mongoose.Schema({
    _id: {
        type: Number,
        trim: true,
        required: true,
    },
}));