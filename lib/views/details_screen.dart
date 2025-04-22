import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class DetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              movie.posterUrl,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Icon(Icons.broken_image, size: 100),
            ),
            SizedBox(height: 16),
            Text(
              movie.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("⭐ ${movie.rating} • ${movie.releaseDate}"),
            SizedBox(height: 16),
            Text(movie.overview, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
