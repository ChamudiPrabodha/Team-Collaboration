

// controllers/predictController.js
const axios = require('axios');
const FormData = require('form-data');

async function predict(req, res) {
  if (!req.file) {
    return res.status(400).json({ error: 'No image uploaded' });
  }

  try {
    const form = new FormData();
    form.append('image', req.file.buffer, {
      filename: req.file.originalname,
      contentType: req.file.mimetype,
    });

    // Replace with your Flask backend URL
    const response = await axios.post('http://127.0.0.1:8080/predict', form, {
      headers: form.getHeaders(),
      timeout: 10000, // optional timeout
    });

    return res.json(response.data);
  } catch (error) {
    console.error('Error forwarding to Flask:', error.message);
    return res.status(500).json({ error: 'Prediction failed' });
  }
}

module.exports = {
  predict,
};
