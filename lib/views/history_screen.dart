import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';

class HistoryScreen extends StatelessWidget {
  final controller = Get.find<MovieController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🔁 Search History"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              controller.clearHistory();
              Get.snackbar("History", "Cleared successfully");
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.history.isEmpty) {
          return Center(child: Text("No search history yet."));
        }
        return ListView.builder(
          itemCount: controller.history.length,
          itemBuilder: (context, index) {
            final title = controller.history[index];
            return ListTile(
              title: Text(title),
              trailing: Icon(Icons.history),
              onTap: () {
                controller.fetchRecommendations(title);
                Get.back(); // Return to home screen
              },
            );
          },
        );
      }),
    );
  }
}
