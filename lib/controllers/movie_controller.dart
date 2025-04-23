import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../models/movie_model.dart';

final _storage = GetStorage();

class MovieController extends GetxController {
  var isLoading = false.obs;
  var movies = <MovieModel>[].obs;
  var history = <String>[].obs;

  MovieController() {
    loadHistory();
  }

  void loadHistory() {
    final data = _storage.read<List>('history')?.cast<String>() ?? [];
    history.assignAll(data);
  }

  void addToHistory(String movie) {
    if (!history.contains(movie)) {
      history.insert(0, movie);
      _storage.write('history', history);
    }
  }

  void clearHistory() {
    history.clear();
    _storage.remove('history');
  }

  Future<void> fetchRecommendations(String movieName) async {
    try {
      isLoading(true);
      movies.clear();
      addToHistory(movieName);

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
