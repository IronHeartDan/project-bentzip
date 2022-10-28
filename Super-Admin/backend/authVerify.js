const jwt = require("jsonwebtoken");

module.exports = function (req, res, next) {
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