// diseasesController.js
const admin = require('firebase-admin');
const getAllDiseases = async (req, res) => {
  try {
    const snapshot = await req.db.collection("diseases").get();
    const diseases = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(diseases);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getDiseaseById = async (req, res) => {
  try {
    const doc = await req.db.collection("diseases").doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ message: "Disease not found" });
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const createDisease = async (req, res) => {
  try {
    const { name, description, imageUrl, identifiedBy } = req.body;
    const newDisease = {
      name,
      description,
      imageUrl,
      identifiedBy,
      remedies: [],
      createdAt: new Date().toISOString(),
    };
    const docRef = await req.db.collection("diseases").add(newDisease);
    res.status(201).json({ id: docRef.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const addRemedy = async (req, res) => {
  try {
    const { remedy, contributor } = req.body;
    const diseaseRef = req.db.collection("diseases").doc(req.params.id);
    const doc = await diseaseRef.get();

    if (!doc.exists) return res.status(404).json({ message: "Disease not found" });

    const remedies = doc.data().remedies || [];
    remedies.push({ remedy, contributor, addedAt: new Date().toISOString() });

    await diseaseRef.update({ remedies });

    res.json({ message: "Remedy added successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  getAllDiseases,
  getDiseaseById,
  createDisease,
  addRemedy,
};
