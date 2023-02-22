const mongoose = require("mongoose");
const User = require("./student");
const Teacher = require("./teacher");

const Record = mongoose.model("record", new mongoose.Schema({
    createdAt: {
        type: Date,
        default: Date.now(),
    },
    user: {
        type: User.schema || Teacher.schema,
        require: true,
    }
}));

module.exports = Record;