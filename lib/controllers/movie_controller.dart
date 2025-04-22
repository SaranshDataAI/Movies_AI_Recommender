import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie_model.dart';

class MovieController extends GetxController {
  var isLoading = false.obs;
  var movies = <MovieModel>[].obs;

  Future<void> fetchRecommendations(String movieName) async {
    try {
      isLoading(true);
      movies.clear();

      final url = Uri.parse("https://movies-ai-api.onrender.com/recommend");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'movie': movieName}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['recommendations'] != null) {
          movies.value = List<MovieModel>.from(
            data['recommendations'].map((item) => MovieModel.fromJson(item)),
          );
        }
      } else {
        Get.snackbar("Error", "Status Code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
