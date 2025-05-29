// controllers/cropController.js
const addCrop = async (req, res) => {
  try {
    const { userId, cropName, type, plantingDate, location } = req.body;

    const newCrop = {
      userId,  // ✅ use directly from req.body
      cropName,
      type,
      plantingDate,
      location,
      growthStage: "Planted",
      productivity: null,
      createdAt: new Date().toISOString(),
    };

    const docRef = await req.db.collection("crops").add(newCrop);
    res.status(201).json({ id: docRef.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};



const getCropsByUser = async (req, res) => {
  try {
    const userId = req.query.userId;  // ✅ send userId as query param

    const snapshot = await req.db
      .collection("crops")
      .where("userId", "==", userId)
      .get();

    const crops = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(crops);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
const updateGrowthStage = async (req, res) => {
  try {
    const { growthStage } = req.body;
    await req.db.collection("crops").doc(req.params.id).update({ growthStage });
    res.json({ message: "Growth stage updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateProductivity = async (req, res) => {
  try {
    const { productivity } = req.body;
    await req.db.collection("crops").doc(req.params.id).update({ productivity });
    res.json({ message: "Productivity updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  addCrop,
  getCropsByUser,
  updateGrowthStage,
  updateProductivity,
};
