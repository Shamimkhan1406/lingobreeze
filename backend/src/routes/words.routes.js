const express = require("express");
const router = express.Router();

const words = require("../data/words");

router.get("/", (req, res) => {
  res.status(200).json({
    success: true,
    data: words,
  });
});

module.exports = router;