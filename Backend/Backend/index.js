const bodyParser = require("body-parser");
const cors = require("cors");
const admin = require("firebase-admin");
const express = require("express");
const app = express();

// Firebase setup - initialize app first
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Firestore instance
const firestore = admin.firestore();

// Import other routes
const guidesRoutes = require("./routes/guidesRoutes");
const usersRoutes = require("./routes/usersRoutes");
const forumsRoutes = require("./routes/forumsRoutes");
const diseasesRoutes = require("./routes/diseasesRoutes");
const cultivationRoutes = require("./routes/cultivationRoutes");
const locationRoutes = require("./routes/locationRoutes");
const rentalRoutes = require("./routes/rentalRoutes");

// Import predict route (with controller logic)
const predictRoute = require('./routes/predict');

app.use(cors());
app.use(bodyParser.json());

// Middleware to pass firestore db instance to routes/controllers
app.use((req, _res, next) => {
  req.db = firestore;
  next();
});

// Use routes
app.use("/api/guides", guidesRoutes);
app.use("/api/users", usersRoutes);
app.use("/api/forums", forumsRoutes);
app.use("/api/diseases", diseasesRoutes);
app.use("/api/crops", cultivationRoutes);
app.use("/api/location", locationRoutes);
app.use("/api/rentals", rentalRoutes);
app.use('/', predictRoute);  // <-- Predict routes handled here

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
