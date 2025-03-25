import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/home/providers/track_service.dart';

final trackServiceProvider = Provider<TrackService>((ref) => TrackService());

final dailyConsumptionProvider = FutureProvider<List<dynamic>>((ref) async {
  final trackService = ref.read(trackServiceProvider);
  return await trackService.getDailyConsumption();
});

final weeklyConsumptionProvider = FutureProvider<List<dynamic>>((ref) async {
  final trackService = ref.read(trackServiceProvider);
  return await trackService.getWeeklyConsumption();
});
