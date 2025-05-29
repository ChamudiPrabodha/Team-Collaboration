// locationRoutes.js

const express = require("express");
const router = express.Router();
const { updateLocation, getNearbyFarmers } = require("../controllers/locationController");

router.post("/update", updateLocation);
router.get("/nearby", getNearbyFarmers);

module.exports = router;
