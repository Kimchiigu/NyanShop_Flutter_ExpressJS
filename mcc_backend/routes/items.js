var express = require("express");
var router = express.Router();
var db = require("../database/db");
var auth = require("./../middleware/auth");

// var getItems = new Promise((resolve, reject) => {
//   db.query("select * from items", (error, result) => {
//     if (!!error) reject(error);
//     resolve(result);
//   });
// });

// var getFoodById = (id) =>
//   new Promise((resolve, reject) => {
//     db.query("select * from foods where id = ?", [id], (error, result) => {
//       if (!!error) reject(error);
//       resolve(result);
//     });
//   });

module.exports = router;
