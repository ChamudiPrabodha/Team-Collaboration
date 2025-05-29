const express = require("express");
const router = express.Router();

const {
  addCrop,
  getCropsByUser,
  updateGrowthStage,
  updateProductivity,
} = require("../controllers/cultivationController");

router.post("/", addCrop);
router.get("/", getCropsByUser);
router.put("/:id/growth", updateGrowthStage); // ✅ Add this
router.put("/:id/productivity", updateProductivity);

module.exports = router;
