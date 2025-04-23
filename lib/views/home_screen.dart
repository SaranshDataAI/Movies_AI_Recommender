// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';
import '../main.dart';
import 'details_screen.dart';

class MovieHomeScreen extends StatelessWidget {
  final controller = Get.put(MovieController());
  final themeController = Get.find<ThemeController>();
  final TextEditingController inputController = TextEditingController();

  MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🎬 Movie Recommender"),
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(
                themeController.isDark.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
            onPressed: () => themeController.toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                hintText: "Enter a movie name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final movie = inputController.text.trim();
                      if (movie.isNotEmpty) {
                        controller.fetchRecommendations(movie);
                      }
                    },
                    child: Text("Recommend"),
                  ),
                ),
                SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () => Get.toNamed('/history'),
                  icon: Icon(Icons.history),
                  label: Text("History"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 90,
                              color: Colors.white,
                            ),
                            title: Container(
                              width: 150,
                              height: 16,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              width: 100,
                              height: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (controller.movies.isEmpty) {
                return Text("No recommendations yet.");
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.movies.length,
                    itemBuilder: (context, index) {
                      final movie = controller.movies[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Hero(
                            tag: movie.title,
                            child: Image.network(
                              movie.posterUrl,
                              width: 60,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (c, e, s) => Icon(Icons.broken_image),
                            ),
                          ),
                          title: Text(movie.title),
                          subtitle: Text(
                            "⭐ ${movie.rating}    📅 ${movie.releaseDate}",
                          ),
                          onTap:
                              () => Get.to(() => DetailsScreen(movie: movie)),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
