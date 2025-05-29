// forumsRoutes.js

const express = require("express");
const router = express.Router();
const {
  getAllForums,
  getForumById,
  createForum,
  addReply,
} = require("../controllers/forumsController");

router.get("/", getAllForums);
router.get("/:id", getForumById);


router.post("/", createForum);
router.post("/:id/reply", addReply);

module.exports = router;
