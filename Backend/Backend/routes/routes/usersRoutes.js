const express = require("express");
const router = express.Router();
const {
  getAllUsers,
  getUserById,
  updateUser,
  deleteUserByEmail,
  loginUser,
  signupUser, 
} = require("../controllers/userController");

// In routes/user.js


router.post("/login", loginUser);
router.post("/signup", signupUser);
router.get("/", getAllUsers);
router.get("/:id", getUserById);
router.put("/update", updateUser); // Add or update
router.delete("/:email", deleteUserByEmail);


module.exports = router;
