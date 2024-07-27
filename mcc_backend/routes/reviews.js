var express = require("express");
var router = express.Router();
var db = require("../database/db");

// Get reviews by item ID
router.get("/get/:itemId", async (req, res) => {
  const itemId = req.params.itemId;
  try {
    db.query(
      "SELECT r.review_text, u.username FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.item_id = ?",
      [itemId],
      (error, results) => {
        if (error)
          return res.status(500).json({ error: "Failed to fetch reviews" });
        res.status(200).json(results);
      }
    );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create a review
router.post("/create", async (req, res) => {
  const { itemId, review_text, userId } = req.body; // Note review_text

  if (!itemId || !review_text || !userId) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  try {
    const query =
      "INSERT INTO reviews (item_id, user_id, review_text) VALUES (?, ?, ?)";
    db.query(query, [itemId, userId, review_text], (error, results) => {
      if (error) {
        console.error("Database Error: ", error);
        return res
          .status(500)
          .json({ error: "Failed to create review", details: error.message });
      }
      res.status(201).json({ message: "Review created successfully" });
    });
  } catch (err) {
    console.error("Server Error: ", err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
