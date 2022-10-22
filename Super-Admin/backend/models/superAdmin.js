const mongoose = require("mongoose");

const superAdmin = mongoose.model(
    "SuperAdmin",
    new mongoose.Schema({
        email: {
            type: String,
            unique:true,
            required: true,
            trim: true,
        },
        password: {
            type: String,
            required: true,
            trim: true,
        }
    }),
    "users"
);

module.exports = superAdmin;