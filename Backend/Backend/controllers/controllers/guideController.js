const admin = require('firebase-admin');

// Helper to remove undefined fields from an object
const cleanData = (data) => {
  return Object.fromEntries(Object.entries(data).filter(([_, v]) => v !== undefined));
};

// Get all guides
const getAllGuides = async (req, res) => {
  try {
    const snapshot = await req.db.collection("guides").get();
    const guides = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(guides);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get single guide by id
const getGuideById = async (req, res) => {
  try {
    const doc = await req.db.collection("guides").doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ message: "Guide not found" });
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Add a new guide
const addGuide = async (req, res) => {
  try {
    const { title, content, category } = req.body;

    if (!title || !content) {
      return res.status(400).json({ message: "Title and content are required" });
    }

    const newGuide = cleanData({
      title,
      content,
      category,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const docRef = await req.db.collection("guides").add(newGuide);
    res.status(201).json({ id: docRef.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update guide by id
const updateGuide = async (req, res) => {
  try {
    const { title, content, category } = req.body;
    const guideRef = req.db.collection("guides").doc(req.params.id);
    const doc = await guideRef.get();
    if (!doc.exists) return res.status(404).json({ message: "Guide not found" });

    const updates = cleanData({ title, content, category });
    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ message: "At least one field (title, content, category) must be provided for update" });
    }

    await guideRef.update(updates);
    res.json({ message: "Guide updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete guide by id
const deleteGuide = async (req, res) => {
  try {
    const guideRef = req.db.collection("guides").doc(req.params.id);
    const doc = await guideRef.get();
    if (!doc.exists) return res.status(404).json({ message: "Guide not found" });

    await guideRef.delete();
    res.json({ message: "Guide deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  getAllGuides,
  getGuideById,
  addGuide,
  updateGuide,
  deleteGuide,
};
