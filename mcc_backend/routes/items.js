var express = require("express");
var router = express.Router();
var db = require("../database/db");

// Get all items
router.get("/get", async (req, res) => {
  try {
    db.query("SELECT * FROM items", (error, results) => {
      if (error) {
        return res.status(500).json({ error: "Failed to fetch items" });
      }
      res.status(200).json(results);
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get item by ID
router.get("/get/:id", async (req, res) => {
  const itemId = req.params.id;
  try {
    db.query("SELECT * FROM items WHERE id = ?", [itemId], (error, results) => {
      if (error) {
        return res.status(500).json({ error: "Failed to fetch item" });
      }
      if (results.length === 0) {
        return res.status(404).json({ error: "Item not found" });
      }
      res.status(200).json(results[0]);
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create a new item
router.post("/create", async (req, res) => {
  const { name, image, price, description } = req.body;
  try {
    const query =
      "INSERT INTO items (name, image, price, description) VALUES (?, ?, ?, ?)";
    db.query(query, [name, image, price, description], (error, results) => {
      if (error) {
        return res.status(500).json({ error: "Failed to create item" });
      }
      res
        .status(201)
        .json({ id: results.insertId, name, image, price, description });
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update an existing item
router.put("/update/:id", async (req, res) => {
  const itemId = req.params.id;
  const { name, image, price, description } = req.body;
  try {
    const query =
      "UPDATE items SET name = ?, image = ?, price = ?, description = ? WHERE id = ?";
    db.query(
      query,
      [name, image, price, description, itemId],
      (error, results) => {
        if (error) {
          return res.status(500).json({ error: "Failed to update item" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Item not found" });
        }
        res.status(200).json({ id: itemId, name, image, price, description });
      }
    );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete an item
router.delete("/delete/:id", async (req, res) => {
  const itemId = req.params.id;
  try {
    db.query("DELETE FROM items WHERE id = ?", [itemId], (error, results) => {
      if (error) {
        return res.status(500).json({ error: "Failed to delete item" });
      }
      if (results.affectedRows === 0) {
        return res.status(404).json({ error: "Item not found" });
      }
      res.status(200).json({ message: "Item deleted successfully" });
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
