// rentalRoutes.js

const express = require("express");
const router = express.Router();
const {
  listMachine,
  getMachines,
  bookMachine,
  getBookingsByEmail,
  makePayment,
} = require("../controllers/rentalController");


router.get("/", getMachines);
router.post("/machines", listMachine);
router.post("/book", bookMachine);
router.get("/bookings/:email", getBookingsByEmail);
router.post("/payment", makePayment);

module.exports = router;
