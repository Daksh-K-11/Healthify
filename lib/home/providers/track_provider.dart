// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:healthify/home/service/track_service.dart';

// final trackServiceProvider = Provider<TrackService>((ref) => TrackService());

// final dailyConsumptionProvider = FutureProvider<List<dynamic>>((ref) async {
//   final trackService = ref.read(trackServiceProvider);
//   return await trackService.getDailyConsumption();
// });

// final weeklyConsumptionProvider = FutureProvider<List<dynamic>>((ref) async {
//   final trackService = ref.read(trackServiceProvider);
//   return await trackService.getWeeklyConsumption();
// });




import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/home/models/track_item.dart';
import 'package:healthify/home/models/daily_consumption.dart';
import 'package:healthify/home/service/track_service.dart';

// Provider for the TrackService
final trackServiceProvider = Provider<TrackService>((ref) {
  return TrackService();
});

// Provider for track items
final trackItemsProvider = AsyncNotifierProvider<TrackItemsNotifier, List<TrackItem>>(() {
  return TrackItemsNotifier();
});

class TrackItemsNotifier extends AsyncNotifier<List<TrackItem>> {
  @override
  Future<List<TrackItem>> build() async {
    return [];
  }

  Future<void> fetchTrackItems() async {
    state = const AsyncValue.loading();
    try {
      final trackService = ref.read(trackServiceProvider);
      final items = await trackService.fetchTrackItems();
      state = AsyncValue.data(items);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addTrackItem(String name) async {
    try {
      final trackService = ref.read(trackServiceProvider);
      final newItem = await trackService.addTrackItem(name);
      
      state.whenData((items) {
        state = AsyncValue.data([...items, newItem]);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}


final dailyConsumptionProvider = AsyncNotifierProvider<DailyConsumptionNotifier, List<DailyConsumption>>(() {
  return DailyConsumptionNotifier();
});

class DailyConsumptionNotifier extends AsyncNotifier<List<DailyConsumption>> {
  @override
  Future<List<DailyConsumption>> build() async {
    return [];
  }

  Future<void> fetchDailyConsumption() async {
    state = const AsyncValue.loading();
    try {
      final trackService = ref.read(trackServiceProvider);
      final consumption = await trackService.fetchDailyConsumption();
      state = AsyncValue.data(consumption);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> recordConsumption(int trackItemId, String date, int units) async {
    try {
      final trackService = ref.read(trackServiceProvider);
      final newConsumption = await trackService.recordConsumption(trackItemId, date, units);
      
      state.whenData((consumptions) {
        final filtered = consumptions.where(
          (c) => !(c.trackItem == trackItemId && c.date == date)
        ).toList();
        
        state = AsyncValue.data([...filtered, newConsumption]);
      });
      
      ref.read(weeklyConsumptionProvider.notifier).fetchWeeklyConsumption(trackItemId);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider for weekly consumption
final weeklyConsumptionProvider = AsyncNotifierProvider<WeeklyConsumptionNotifier, List<DailyConsumption>>(() {
  return WeeklyConsumptionNotifier();
});

class WeeklyConsumptionNotifier extends AsyncNotifier<List<DailyConsumption>> {
  @override
  Future<List<DailyConsumption>> build() async {
    return [];
  }

  Future<void> fetchWeeklyConsumption(int trackItemId) async {
    state = const AsyncValue.loading();
    try {
      final trackService = ref.read(trackServiceProvider);
      final consumption = await trackService.fetchWeeklyConsumption(trackItemId);
      state = AsyncValue.data(consumption);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

