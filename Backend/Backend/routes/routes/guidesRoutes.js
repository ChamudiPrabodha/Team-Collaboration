const express = require("express");
const router = express.Router();
const {
  getAllGuides,
  getGuideById,
  addGuide,
  updateGuide,
  deleteGuide,
} = require("../controllers/guideController");

router.get("/", getAllGuides);
router.get("/:id", getGuideById);
router.post("/", addGuide);
router.put("/:id", updateGuide);
router.delete("/:id", deleteGuide);

module.exports = router;
