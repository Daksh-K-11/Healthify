import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthify/core/constant.dart';

class TrackService {
  Future<void> createTrackableItem(String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/track/trackable-items/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw Exception("Failed to create trackable item");
    }
  }

  Future<List<dynamic>> getDailyConsumption() async {
    final response = await http.get(Uri.parse("$baseUrl/track/daily-consumption/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to fetch daily consumption");
    }
  }

  Future<List<dynamic>> getWeeklyConsumption() async {
    final response = await http.get(Uri.parse("$baseUrl/track/weekly-consumption/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to fetch weekly consumption");
    }
  }

  Future<void> recordDailyConsumption({
    required int trackItem,
    required String date,
    required int units,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/track/daily-consumption/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "track_item": trackItem,
        "date": date,
        "units": units,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw Exception("Failed to record daily consumption");
    }
  }
}
