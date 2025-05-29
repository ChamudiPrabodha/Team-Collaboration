const admin = require('firebase-admin');

const getAllForums = async (req, res) => {
  try {
    const snapshot = await req.db.collection("forums").get();
    const forums = snapshot.docs.map(doc => {
      const data = doc.data();

      // Normalize author name to string
      if (data.author?.name) {
        data.author.name = String(data.author.name);
      }

      // Normalize all replier names to string
      if (Array.isArray(data.replies)) {
        data.replies = data.replies.map(reply => ({
          ...reply,
          replier: {
            ...reply.replier,
            name: String(reply.replier?.name ?? 'Unknown'),
          },
        }));
      }

      return { id: doc.id, ...data };
    });
    res.json(forums);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getForumById = async (req, res) => {
  try {
    const doc = await req.db.collection("forums").doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ message: "Forum post not found" });

    const data = doc.data();

    // Normalize author name to string
    if (data.author?.name) {
      data.author.name = String(data.author.name);
    }

    // Normalize all replier names to string
    if (Array.isArray(data.replies)) {
      data.replies = data.replies.map(reply => ({
        ...reply,
        replier: {
          ...reply.replier,
          name: String(reply.replier?.name ?? 'Unknown'),
        },
      }));
    }

    res.json({ id: doc.id, ...data });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const createForum = async (req, res) => {
  try {
    const { title, content, author } = req.body;

    // Ensure author name is string
    const safeAuthor = (typeof author === 'string')
      ? { name: String(author) }
      : { ...author, name: String(author.name) };

    const newForum = {
      title,
      content,
      author: safeAuthor,
      createdAt: new Date().toISOString(),
      replies: [],
    };

    const docRef = await req.db.collection("forums").add(newForum);
    res.status(201).json({ id: docRef.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const addReply = async (req, res) => {
  try {
    const { reply, replier } = req.body;
    const forumRef = req.db.collection("forums").doc(req.params.id);
    const doc = await forumRef.get();

    if (!doc.exists) return res.status(404).json({ message: "Forum post not found" });

    const existingReplies = doc.data().replies || [];

    // Ensure replier name is string
    const safeReplier = { ...replier, name: String(replier.name) };

    existingReplies.push({ reply, replier: safeReplier, repliedAt: new Date().toISOString() });

    await forumRef.update({ replies: existingReplies });

    res.json({ message: "Reply added" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  getAllForums,
  getForumById,
  createForum,
  addReply,
};
