// diseasesRoutes.js

const express = require("express");
const router = express.Router();
const {
  getAllDiseases,
  getDiseaseById,
  createDisease,
  addRemedy,
} = require("../controllers/diseasesController");

router.get("/", getAllDiseases);
router.get("/:id", getDiseaseById);
router.post("/", createDisease);
router.post("/:id/remedy", addRemedy);

module.exports = router;
