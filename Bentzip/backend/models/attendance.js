const mongoose = require("mongoose");

const StudentAttendance = mongoose.model("studentAttendance", new mongoose.Schema({
    user: {
        type: Number,
        trim: true,
        required: true,
    },
    standard: {
        type: Number,
        trim: true,
        required: true,
    },
    date: {
        type: Date,
        default: Date.now(),
    }
}), "attendance");


const TeacherAttendance = mongoose.model("teacherAttendance", new mongoose.Schema({
    user: {
        type: Number,
        trim: true,
        required: true,
    },
    term: {
        type: String,
        trim: true,
        required: true,
    },
    date: {
        type: Date,
        default: Date.now(),
    }
}), "attendance");

module.exports = {StudentAttendance,TeacherAttendance};