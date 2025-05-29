// routes/predictRoutes.js
const express = require('express');
const multer = require('multer');
const { predict } = require('../controllers/predictController');

const router = express.Router();
const upload = multer(); // Memory storage

router.post('/predict', upload.single('image'), predict);

module.exports = router;