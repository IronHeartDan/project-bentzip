const mongoose = require("mongoose");

const StudentAttendance = mongoose.model("studentAttendance", new mongoose.Schema({
    user: {
        type: Number,
        trim: true,
        required: true,
    },
    class: {
        type: mongoose.Types.ObjectId,
        trim: true,
        required: true,
    },
    date: {
        type: Date,
        required: true,
    },
    present: {
        type: Number,
        required: true,
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
        required: true,
    }
}), "attendance");

module.exports = { StudentAttendance, TeacherAttendance };