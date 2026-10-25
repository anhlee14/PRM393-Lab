import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  // Đường dẫn API
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts_error';

  // Lấy danh sách bài viết
  Future<List<Post>> fetchPosts() async {
    // Chờ 5s
    await Future.delayed(const Duration(seconds: 5));
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) => Post.fromJson(item)).toList();
      } else {
        throw Exception('Server trả về lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối API: $e');
    }
  }

  // Tạo bài viết mới gửi lên Server
  Future<Post> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Không thể tạo bài viết mới');
    }
  }
}