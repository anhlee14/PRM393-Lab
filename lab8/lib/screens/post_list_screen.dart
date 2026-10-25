import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    // Gọi API khi màn hình được khởi tạo
    _futurePosts = _apiService.fetchPosts();
  }

  // Tải lại dữ liệu
  void _retryFetch() {
    setState(() {
      _futurePosts = _apiService.fetchPosts();
    });
  }

  // Thêm bài viết mới
  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Post (POST API)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;
              Navigator.pop(context); // Đóng hộp thoại

              try {
                final created = await _apiService.createPost(
                  titleController.text,
                  bodyController.text,
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Created Post ID: ${created.id} - ${created.title}'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to create post'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 8 – REST API Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryFetch,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          // Đang tải dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Lỗi
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    const Text(
                      'Something went wrong!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryFetch,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Tải thành công
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${post.id}'),
                  ),
                  title: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}