const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');


const JWT_SECRET = 'your_jwt_secret_key'; // Replace with environment variable in production

// Get all users
const getAllUsers = async (req, res) => {
  try {
    const snapshot = await req.db.collection("users").get();
    const users = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get single user by id
const getUserById = async (req, res) => {
  try {
    const doc = await req.db.collection("users").doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ message: "User not found" });
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update user profile
const updateUser = async (req, res) => {
  try {
    const { email, name, phone, region, address } = req.body;

    if (!email) return res.status(400).json({ message: "Email is required to update user" });

    const usersRef = req.db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (snapshot.empty) {
      return res.status(404).json({ message: "User not found with email: " + email });
    }

    const docId = snapshot.docs[0].id;

    await usersRef.doc(docId).update({
      ...(name && { name }),
      ...(phone && { phone }),
      ...(region && { region }),
      ...(address && { address }),
      updatedAt: new Date().toISOString(),
    });

    return res.json({ message: "User updated successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteUserByEmail = async (req, res) => {
  try {
    const email = req.params.email;

    const usersRef = req.db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (snapshot.empty) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Assuming email is unique, delete the first matching document
    const docId = snapshot.docs[0].id;
    await usersRef.doc(docId).delete();

    return res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
// 🔐 Login with JWT
const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const usersRef = req.db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (snapshot.empty) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const userDoc = snapshot.docs[0];
    const user = userDoc.data();
    const userId = userDoc.id;

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const token = jwt.sign(
      {
        id: userId,
        email: user.email,
      },
      JWT_SECRET,
      { expiresIn: "7d" }
    );

    return res.json({
      message: "Login successful",
      user: { id: userId, name: user.name, email: user.email },
      token,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// 🔐 Signup with hashed password
const signupUser = async (req, res) => {
  try {
    const { email, password, name, phone, region } = req.body;

    if (!email || !password || !name) {
      return res.status(400).json({ message: "email, password, and name are required" });
    }

    const usersRef = req.db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (!snapshot.empty) {
      return res.status(409).json({ message: "User already exists with this email" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = {
      email,
      password: hashedPassword,
      name,
      createdAt: new Date().toISOString(),
    };

    if (phone) newUser.phone = phone;
    if (region) newUser.region = region;

    await usersRef.add(newUser);

    return res.status(200).json({ message: "User signed up successfully" });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

module.exports = {
  getAllUsers,
  getUserById,
  updateUser,
  deleteUserByEmail,
  loginUser,
  signupUser,
};
