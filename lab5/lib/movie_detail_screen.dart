import 'package:flutter/material.dart';
import 'movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner với Gradient phủ chữ
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  movie.posterUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 240,
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Danh sách Genre Chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: movie.genres
                        .map((genre) => Chip(
                      label: Text(genre),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // 3. Overview Text
                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // 4. Action Buttons (Favorite / Rate / Share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.black87,
                        label: 'Favorite',
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.star_border,
                        label: 'Rate',
                        onTap: () {},
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 5. Trailers Section Header
                  const Text(
                    'Trailers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // 6. Trailer List
                  ...movie.trailers.map(
                        (trailer) => Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.play_circle_fill, size: 32, color: Colors.black87),
                          title: Text(trailer, style: const TextStyle(fontSize: 16)),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}