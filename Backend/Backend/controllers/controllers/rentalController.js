// rentalController.js

const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(), // or use serviceAccount
  });
}

const db = admin.firestore();

// Add a new machine listing
const listMachine = async (req, res) => {
  try {
    const { ownerId, title, description, pricePerDay, location } = req.body;
    const newMachine = {
      ownerId,
      title,
      description,
      pricePerDay,
      location,
      isAvailable: true,
      createdAt: new Date().toISOString()
    };
    const docRef = await req.db.collection("machines").add(newMachine);
    res.status(201).json({ id: docRef.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get available machines
const getMachines = async (req, res) => {
  try {
    const snapshot = await req.db.collection("machines").where("isAvailable", "==", true).get();
    const machines = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    console.log("Retrieved machines:", machines);
    res.json(machines);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
//book a machine
const bookMachine = async (req, res) => {
  try {
    const { machineId, userId, startDate, endDate, paymentMode = "Card" } = req.body;

    if (!machineId || !userId || !startDate || !endDate) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const machineRef = req.db.collection("machines").doc(machineId);
    const machineSnap = await machineRef.get();

    if (!machineSnap.exists) {
      return res.status(404).json({ message: "Machine not found" });
    }

    const machine = machineSnap.data();
    const start = new Date(startDate);
    const end = new Date(endDate);
    const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));

    if (days <= 0) {
      return res.status(400).json({ message: "End date must be after start date" });
    }

    const totalCost = days * machine.pricePerDay;

    const booking = {
      machineId,
      ownerId: machine.ownerId,
      userId,
      startDate,
      endDate,
      days,
      totalCost,
      paymentMode,
      paymentStatus: "Unpaid",
      status: "Pending",
      bookedAt: new Date().toISOString(),
    };

    const bookingRef = await req.db.collection("bookings").add(booking);

    await machineRef.update({ isAvailable: false });

    // ✅ Logging to console for verification
    console.log("Booking created with ID:", bookingRef.id);
    
    // ✅ Sending bookingId in response
    res.status(201).json({
      message: "Machine booked successfully",
      bookingId: bookingRef.id,
      booking,
    });

  } catch (err) {
    console.error("Booking error:", err);
    res.status(500).json({ error: err.message });
  }
};

// Simulate payment for a booking
const makePayment = async (req, res) => {
  try {
    const { bookingId, paymentMethod, amount, cardType, cardNumber } = req.body;

    const bookingRef = req.db.collection("bookings").doc(bookingId);
    const bookingSnap = await bookingRef.get();

    if (!bookingSnap.exists) {
      return res.status(404).json({ message: "Booking not found" });
    }

    const booking = bookingSnap.data();

    // Save payment record
    const paymentRecord = {
      bookingId,
      userId: booking.userId,
      amount,
      paymentMethod,
      paidAt: new Date().toISOString(),
      cardType: cardType || null,
      cardNumber: cardNumber || null, // Consider encrypting in production
    };

    await req.db.collection("payments").add(paymentRecord);

    // Update booking status AND store card details in booking document
    await bookingRef.update({
      paymentStatus: "Paid",
      status: "Confirmed",
      cardType: cardType || null,
      cardNumber: cardNumber || null,
    });

    res.status(200).json({ message: "Payment successful and booking confirmed" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get bookings by user email
const getBookingsByEmail = async (req, res) => {
  try {
    const { email } = req.params;
    const snapshot = await req.db.collection("bookings").where("userEmail", "==", email).get();
    const bookings = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  listMachine,
  getMachines,
  bookMachine,
  makePayment,
  getBookingsByEmail,
};
