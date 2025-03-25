import 'dart:convert';
import 'package:healthify/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/home/models/track_item.dart';
import 'package:healthify/home/models/daily_consumption.dart';

class TrackService {
  Future<List<TrackItem>> fetchTrackItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/track/trackable-items/'),
      headers: headersForAuth,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => TrackItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load track items: ${response.statusCode}');
    }
  }

  Future<TrackItem> addTrackItem(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/track/trackable-items/'),
      headers: headersForAuth,
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 201) {
      return TrackItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add track item: ${response.statusCode}');
    }
  }

  Future<List<DailyConsumption>> fetchDailyConsumption() async {
    final response = await http.get(
      Uri.parse('$baseUrl/track/daily-consumption/'),
      headers: headersForAuth,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => DailyConsumption.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load daily consumption: ${response.statusCode}');
    }
  }

  Future<List<DailyConsumption>> fetchWeeklyConsumption(int trackItemId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/track/weekly-consumption/'),
      headers: headersForAuth,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => DailyConsumption.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load weekly consumption: ${response.statusCode}');
    }
  }

  Future<DailyConsumption> recordConsumption(
      int trackItemId, String date, int units) async {
    final response = await http.post(
      Uri.parse('${baseUrl}track/daily-consumption/'),
      headers: headersForAuth,
      body: json.encode({
        'track_item': trackItemId,
        'date': date,
        'units': units,
      }),
    );

    if (response.statusCode == 201) {
      return DailyConsumption.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to record consumption: ${response.statusCode}');
    }
  }
}
