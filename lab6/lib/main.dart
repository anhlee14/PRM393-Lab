import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Dữ liệu mẫu
List<Movie> sampleMovies = [
  Movie(
    title: 'Dune: Part Two',
    year: 2024,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/200/300?random=1',
    rating: 8.6,
  ),
  Movie(
    title: 'Deadpool & Wolverine',
    year: 2024,
    genres: ['Action', 'Comedy'],
    posterUrl: 'https://picsum.photos/200/300?random=2',
    rating: 8.3,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/200/300?random=3',
    rating: 8.7,
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchKeyword = '';
  List<String> chosenGenres = [];
  String sortType = 'A–Z';

  final List<String> genreList = ['Action', 'Comedy', 'Drama', 'Sci-Fi'];
  final List<String> sortList = ['A–Z', 'Z–A', 'Year', 'Rating'];

  @override
  Widget build(BuildContext context) {
    // 1 Lọc phim theo search và genre
    List<Movie> displayMovies = sampleMovies.where((movie) {
      bool passSearch = movie.title.toLowerCase().contains(searchKeyword.toLowerCase());
      bool passGenre = chosenGenres.isEmpty ||
          movie.genres.any((g) => chosenGenres.contains(g));
      return passSearch && passGenre;
    }).toList();

    // 2 Sắp xếp
    if (sortType == 'A–Z') {
      displayMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortType == 'Z–A') {
      displayMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (sortType == 'Year') {
      displayMovies.sort((a, b) => b.year.compareTo(a.year));
    } else if (sortType == 'Rating') {
      displayMovies.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              const Text(
                'Find a Movie',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Search Bar
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search movie...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    searchKeyword = text;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Genre Chips dùng Wrap
              Wrap(
                spacing: 8.0,
                children: genreList.map((genre) {
                  bool isSelected = chosenGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          chosenGenres.add(genre);
                        } else {
                          chosenGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Sort Dropdown
              Row(
                children: [
                  const Text('Sort: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: sortType,
                    items: sortList.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        sortType = val!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Danh sách phim Responsive
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 800) {
                      // Giao diện Web / Tablet
                      return GridView.builder(
                        itemCount: displayMovies.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return buildMovieItem(displayMovies[index]);
                        },
                      );
                    } else {
                      // Giao diện Điện thoại
                      return ListView.builder(
                        itemCount: displayMovies.length,
                        itemBuilder: (context, index) {
                          return buildMovieItem(displayMovies[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tạo từng thẻ phim
  Widget buildMovieItem(Movie movie) {
    return Card(
      child: ListTile(
        leading: Image.network(
          movie.posterUrl,
          width: 50,
          height: 70,
          fit: BoxFit.cover,
        ),
        title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Year: ${movie.year} | Rating: ${movie.rating}'),
      ),
    );
  }
}