const jwt = require("jsonwebtoken");

// Models Import
const School = require("./models/school");
const Admin = require("./models/admin");
const Teacher = require("./models/teacher");
const Student = require("./models/student");
const Class = require("./models/class");
const Counter = require("./models/counter");

const checkBody = (body) => {
    let isEmpty = Object.keys(body).length == 0;
    if (body && !isEmpty) {
        return true;
    } else {
        return false;
    }
}

const verifyAuth = (req, res, next) => {
    let token = req.header("Authorization");
    if (!token) res.status(401).send("Access Denied");

    try {
        let verified = jwt.verify(token, process.env.JSON_SECRET);
        req.user = verified;
        next();
    } catch (error) {
        res.status(400).send("Invalid Token");
    }
}

const checkSchool = async (id) => {
    let school = await School.findOne({ _id: id });
    return school ? false : true;
}

function getCurrentDate() {
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const dd = String(today.getDate()).padStart(2, '0');
    const formattedDate = `${yyyy}-${mm}-${dd}`;
    return new Date(formattedDate);
}


module.exports = { checkBody, verifyAuth, checkSchool, getCurrentDate };