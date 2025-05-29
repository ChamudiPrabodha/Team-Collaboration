const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "your-bucket-name.appspot.com" // optional if using Cloud Storage
});

module.exports = admin;
