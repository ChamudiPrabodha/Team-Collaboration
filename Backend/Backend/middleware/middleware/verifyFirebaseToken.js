const admin = require('firebase-admin');

const verifyFirebaseToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Unauthorized - Token missing" });
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken; // user info now available on req.user
    next();
  } catch (error) {
    return res.status(401).json({ error: "Unauthorized - Invalid token" });
  }
};

module.exports = verifyFirebaseToken;
