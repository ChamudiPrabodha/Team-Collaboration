// locationController.js
const admin = require('firebase-admin');
const EARTH_RADIUS_KM = 6371; // Approx Earth radius in KM

// Save or update user location
const updateLocation = async (req, res) => {
  try {
    const { userId, latitude, longitude } = req.body;
    if (!userId || !latitude || !longitude) {
      return res.status(400).json({ message: "userId, latitude, longitude required" });
    }
    const userRef = req.db.collection("users").doc(userId);
    await userRef.set(
      {
        location: new req.admin.firestore.GeoPoint(latitude, longitude),
        updatedAt: new Date().toISOString(),
      },
      { merge: true }
    );
    res.json({ message: "Location updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Helper to calculate distance between two geo points (Haversine formula)
const getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2) => {
  function deg2rad(deg) {
    return deg * (Math.PI / 180);
  }
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return EARTH_RADIUS_KM * c;
};

// Get nearby farmers within radius (default 10km)
const getNearbyFarmers = async (req, res) => {
  try {
    const { latitude, longitude, radius = 10 } = req.query;
    if (!latitude || !longitude) {
      return res.status(400).json({ message: "latitude and longitude are required" });
    }
    const usersSnapshot = await req.db.collection("users").get();
    const nearbyUsers = [];

    usersSnapshot.forEach(doc => {
      const userData = doc.data();
      if (userData.location) {
        const dist = getDistanceFromLatLonInKm(
          parseFloat(latitude),
          parseFloat(longitude),
          userData.location.latitude,
          userData.location.longitude
        );
        if (dist <= radius) {
          nearbyUsers.push({
            id: doc.id,
            distance: dist.toFixed(2),
            ...userData,
          });
        }
      }
    });

    res.json(nearbyUsers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  updateLocation,
  getNearbyFarmers,
};
