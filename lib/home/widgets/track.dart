import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/home/providers/track_provider.dart';

class TrackPage extends ConsumerStatefulWidget {
  const TrackPage({super.key});

  @override
  ConsumerState<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends ConsumerState<TrackPage> {
  final TextEditingController _trackItemController = TextEditingController();
  final TextEditingController _recordUnitsController = TextEditingController();

  int selectedTrackItemId = 1;

  @override
  void dispose() {
    _trackItemController.dispose();
    _recordUnitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyAsync = ref.watch(dailyConsumptionProvider);
    final weeklyAsync = ref.watch(weeklyConsumptionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Consumption"),
        backgroundColor: Pallete.gradient1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Create Trackable Item Section
              FadeInDown(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Create Trackable Item",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _trackItemController,
                          decoration: const InputDecoration(
                            hintText: "Enter item name, e.g., Cigarettes",
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.gradient1,
                          ),
                          onPressed: () async {
                            final name = _trackItemController.text.trim();
                            if (name.isEmpty) return;
                            try {
                              await ref
                                  .read(trackServiceProvider)
                                  .createTrackableItem(name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Trackable item created")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: const Text("Create"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Record Daily Consumption Section
              FadeInLeft(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Record Daily Consumption",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _recordUnitsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter units consumed",
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.gradient1,
                          ),
                          onPressed: () async {
                            final units = int.tryParse(
                                _recordUnitsController.text.trim());
                            if (units == null) return;
                            try {
                              final today = DateTime.now()
                                  .toIso8601String()
                                  .substring(0, 10);
                              await ref.read(trackServiceProvider)
                                  .recordDailyConsumption(
                                      trackItem: selectedTrackItemId,
                                      date: today,
                                      units: units);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Daily consumption recorded")));
                              _recordUnitsController.clear();
                              ref.refresh(dailyConsumptionProvider);
                              ref.refresh(weeklyConsumptionProvider);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: const Text("Record"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Today's Consumption Section
              FadeInUp(
                child: dailyAsync.when(
                  data: (dailyData) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Consumption",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...dailyData.map((record) {
                        return ListTile(
                          leading: const Icon(Icons.local_fire_department,
                              color: Colors.red),
                          title: Text(
                              "${record['track_item_name']} - ${record['units']} units"),
                          subtitle: Text("Date: ${record['date']}"),
                        );
                      }).toList(),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Center(child: Text("Error: $err")),
                ),
              ),
              const SizedBox(height: 20),
              // Weekly Consumption Section with Line Chart & Details
              FadeInUp(
                child: ExpansionTile(
                  title: const Text(
                    "Weekly Consumption",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    weeklyAsync.when(
                      data: (weeklyData) => Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: weeklyData.map<FlSpot>((record) {
                                      final date =
                                          DateTime.parse(record['date']);
                                      // Use day of month as x value (for demo purposes)
                                      return FlSpot(
                                          date.day.toDouble(),
                                          (record['units'] as num)
                                              .toDouble());
                                    }).toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    dotData: const FlDotData(show: true),
                                  ),
                                ],
                                titlesData: const FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...weeklyData.map((record) {
                            return ListTile(
                              leading: const Icon(Icons.calendar_today,
                                  color: Colors.blue),
                              title: Text(
                                  "${record['track_item_name']} - ${record['units']} units"),
                              subtitle: Text("Date: ${record['date']}"),
                            );
                          }).toList(),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) =>
                          Center(child: Text("Error: $err")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
