const mongoose = require("mongoose");

const Admin = mongoose.model(
    "Admin",
    new mongoose.Schema({
        _id: {
            type: Number,
            trim: true,
            required: true,
        },
        password: {
            type: String,
            required: true,
            trim: true,
        },
        school: {
            type: String,
            trim: true,
            required: true,
        },
        role: {
            type: Number,
            required: true,
        },
    }),
    "users"
);

module.exports = Admin;