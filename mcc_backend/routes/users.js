var express = require("express");
var router = express.Router();
var db = require("./../database/db");
var bcrypt = require("bcrypt");
var jwt = require("jsonwebtoken");

////////////// Method Variables //////////////
// Register
var doRegister = (username, email, password) => {
  return new Promise((resolve, reject) => {
    var hashPassword = bcrypt.hashSync(password, 10);

    db.query(
      "insert into users (username, email, password) value (?, ?, ?)",
      [username, email, hashPassword],
      (error, result) => {
        if (!!error) reject(error);
        resolve(result);
      }
    );
  });
};

// Login
var doLogin = (email, password) => {
  return new Promise((resolve, reject) => {
    db.query(
      "select id, email, username, password from users where email = ?",
      [email],
      (error, result) => {
        if (!!error) return reject(error);

        if (result.length > 0) {
          const isUserExists = bcrypt.compareSync(password, result[0].password);

          if (isUserExists) {
            const token = jwt.sign(
              {
                email: result[0].email,
              },
              process.env.API_SECRET,
              {
                expiresIn: "1d",
              }
            );

            return resolve({
              id: result[0].id,
              email: result[0].email,
              username: result[0].username,
              token: token,
            });
          } else {
            return reject(new Error("Invalid email or password."));
          }
        } else {
          return reject(new Error("User not found."));
        }
      }
    );
  });
};

// Get user by ID
var getUserById = (id) =>
  new Promise((resolve, reject) => {
    db.query("select * from users where id = ?", [id], (error, result) => {
      if (!!error) reject(error);
      resolve(result);
    });
  });

////////////// Routes //////////////
// Register
router.post("/register", function (req, res, next) {
  const body = req.body;
  doRegister(body.username, body.email, body.password).then(
    (result) => {
      res.status(200).send("Register Success");
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

// Login
router.post("/login", function (req, res, next) {
  const body = req.body;
  doLogin(body.email, body.password).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

// Get user by ID
router.get("/get/:id", function (req, res, next) {
  getUserById(req.params.id).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

// Update User
router.put("/update/:id", function (req, res, next) {
  const { username, email, password } = req.body;
  const userId = req.params.id;

  let updateFields = [];
  let updateValues = [];

  if (username) {
    updateFields.push("username = ?");
    updateValues.push(username);
  }

  if (email) {
    updateFields.push("email = ?");
    updateValues.push(email);
  }

  if (password) {
    // Hash the new password
    const hashPassword = bcrypt.hashSync(password, 10);
    updateFields.push("password = ?");
    updateValues.push(hashPassword);
  }

  if (updateFields.length === 0) {
    return res.status(400).json({ message: "No fields to update" });
  }

  // Add the user ID to the end of the updateValues array
  updateValues.push(userId);

  const updateQuery = `UPDATE users SET ${updateFields.join(
    ", "
  )} WHERE id = ?`;

  db.query(updateQuery, updateValues, (error, result) => {
    if (error) return res.status(500).json({ message: error.message });
    res.status(200).json({ message: "User updated successfully" });
  });
});

// Delete User
router.delete("/delete/:id", function (req, res, next) {
  const userId = req.params.id;

  db.query("DELETE FROM users WHERE id = ?", [userId], (error, result) => {
    if (error) return res.status(500).json({ message: error.message });
    if (result.affectedRows === 0)
      return res.status(404).json({ message: "User not found" });
    res.status(200).json({ message: "User deleted successfully" });
  });
});

// Get All Users
router.get("/get", function (req, res, next) {
  db.query("SELECT id, username, email FROM users", (error, result) => {
    if (error) return res.status(500).json({ message: error.message });
    res.status(200).json(result);
  });
});

// Get user by ID
router.get("/get/:id", function (req, res, next) {
  getUserById(req.params.id).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

module.exports = router;
