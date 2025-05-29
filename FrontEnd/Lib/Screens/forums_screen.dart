import 'package:flutter/material.dart';
import '../services/forums_service.dart';
import 'forum_detail_screen.dart';

class ForumListScreen extends StatefulWidget {
  const ForumListScreen({super.key});

  @override
  State<ForumListScreen> createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  late Future<List<Map<String, dynamic>>> _forumsFuture;

  @override
  void initState() {
    super.initState();
    _forumsFuture = ForumService.getAllForums();
  }

  Future<void> _refreshForums() async {
    setState(() {
      _forumsFuture = ForumService.getAllForums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/a.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _forumsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.greenAccent),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No forums found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final forums = snapshot.data!;

                    return RefreshIndicator(
                      onRefresh: _refreshForums,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: forums.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final forum = forums[index];

                          final String title = forum['title'] ?? 'No Title';

                          String authorName = 'Unknown';
                          final author = forum['author'];
                          if (author is Map && author['name'] is String) {
                            authorName = author['name'];
                          } else if (author is String) {
                            authorName = author;
                          }

                          return Card(
                            color: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              title: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                authorName,
                                style: TextStyle(color: Colors.green[200]),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.greenAccent),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForumDetailScreen(forumId: forum["id"]),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(context, '/create-forum');
                    if (result == true) {
                      _refreshForums();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Forum'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
