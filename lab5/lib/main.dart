import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'movie_detail_screen.dart';
import 'sample_data.dart';

void main() {
  runApp(const MovieDetailApp());
}

class MovieDetailApp extends StatelessWidget {
  const MovieDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Detail App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 0,
              color: const Color(0xFFF6F5FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Navigation: Chuyển trang và truyền object movie sang Detail Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Poster thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          movie.posterUrl,
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.movie),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Thông tin phim
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '☆ ${movie.rating} • ${movie.genres.join(", ")}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Mũi tên điều hướng
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}