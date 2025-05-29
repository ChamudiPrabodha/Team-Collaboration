import 'package:flutter/material.dart';
import '../services/forums_service.dart';

class ForumDetailScreen extends StatefulWidget {
  final String forumId;
  const ForumDetailScreen({super.key, required this.forumId});

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  Map<String, dynamic>? forumData;
  bool _isLoading = true;
  bool _isReplying = false;
  final _replyController = TextEditingController();

  Future<void> _fetchForum() async {
    setState(() => _isLoading = true);
    final data = await ForumService.getForumById(widget.forumId);
    setState(() {
      forumData = data;
      _isLoading = false;
    });
  }

  Future<void> _submitReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() => _isReplying = true);
    try {
      await ForumService.addReply(
        forumId: widget.forumId,
        reply: _replyController.text.trim(),
        replier: {"name": "Your Name"}, // Replace with actual user
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reply added successfully')),
      );
      _replyController.clear();
      _fetchForum(); // Refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add reply')),
      );
    } finally {
      setState(() => _isReplying = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchForum();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Details'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/a.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
              : forumData == null
                  ? const Center(child: Text('Forum not found', style: TextStyle(color: Colors.white)))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            forumData!['title'] ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'By: ${forumData!['author']?['name'] ?? 'Unknown'}',
                            style: TextStyle(color: Colors.green[200], fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                forumData!['content'] ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.greenAccent),
                          const Text('Replies', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: (forumData!['replies'] as List?)?.length ?? 0,
                              itemBuilder: (context, index) {
                                final reply = forumData!['replies'][index];
                                return ListTile(
                                  title: Text(reply['reply'] ?? '', style: const TextStyle(color: Colors.white)),
                                  subtitle: Text(reply['replier']?['name'] ?? 'Anonymous', style: TextStyle(color: Colors.green[200])),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _replyController,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Write a reply...',
                              hintStyle: TextStyle(color: Colors.green[100]),
                              filled: true,
                              fillColor: Colors.black54,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _isReplying
                              ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitReply,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 5,
                                      shadowColor: Colors.greenAccent,
                                    ),
                                    child: const Text('Post Reply', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
