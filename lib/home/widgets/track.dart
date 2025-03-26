import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/home/providers/track_provider.dart';
import 'package:intl/intl.dart';
import 'package:healthify/home/models/track_item.dart';
import 'package:healthify/home/models/daily_consumption.dart';

class Track extends ConsumerStatefulWidget {
  const Track({super.key});

  @override
  ConsumerState<Track> createState() => _TrackState();
}

class _TrackState extends ConsumerState<Track>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int? _expandedIndex;
  final TextEditingController _unitsController = TextEditingController();

  bool _showAddTile = false;
  final TextEditingController _addTrackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();

    // Fetch data when widget initializes.
    Future.microtask(() {
      ref.read(trackItemsProvider.notifier).fetchTrackItems();
      ref.read(dailyConsumptionProvider.notifier).fetchDailyConsumption();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _unitsController.dispose();
    _addTrackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackItems = ref.watch(trackItemsProvider);
    final weeklyData = ref.watch(weeklyConsumptionProvider);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with title and add button.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Track Your Habits',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                _buildAddTrackButton(),
              ],
            ),
          ),
          // Use trackItems.when to build list or show a loading/error state.
          trackItems.when(
            data: (items) {
              return _buildTrackList(items, weeklyData);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTrackButton() {
    return Hero(
      tag: 'add_track_button',
      child: TextButton.icon(
        style: TextButton.styleFrom().copyWith(
          foregroundColor: WidgetStateProperty.all(
              Pallete.gradient1),
        ),
        onPressed: () {
          setState(() {
            _showAddTile = true;
          });
        },
        label: const Text('Add New'),
        icon: const Icon(Icons.add_box_outlined),
      ),
    );
  }

  Widget _buildTrackList(
      List<TrackItem> items, AsyncValue<List<DailyConsumption>> weeklyData) {
    final List<Widget> children = [];
    if (_showAddTile) {
      children.add(_buildAddTrackTile());
    }

    children.addAll(
      items.map((item) {
        final index = items.indexOf(item);
        final isExpanded = _expandedIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ExpansionTile(
              initiallyExpanded: isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedIndex = expanded ? index : null;
                });
                if (expanded) {
                  ref
                      .read(weeklyConsumptionProvider.notifier)
                      .fetchWeeklyConsumption(item.id);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.track_changes,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        _buildTodayStatus(item.id),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: _buildQuickAddButton(item),
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last 7 Days',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        _buildWeeklyChart(item.id, weeklyData),
                        const SizedBox(height: 24),
                        _buildTrackingForm(item),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget _buildAddTrackTile() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addTrackController,
              decoration: const InputDecoration(
                hintText: 'e.g., Cigarettes, Water, Steps',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _addTrackController.clear();
                    setState(() {
                      _showAddTile = false;
                    });
                  },
                  style: TextButton.styleFrom().copyWith(
                    foregroundColor: WidgetStateProperty.all(Pallete.gradient1),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    if (_addTrackController.text.trim().isNotEmpty) {
                      ref
                          .read(trackItemsProvider.notifier)
                          .addTrackItem(_addTrackController.text.trim());
                      _addTrackController.clear();
                      setState(() {
                        _showAddTile = false;
                      });
                    }
                  },
                  style: FilledButton.styleFrom().copyWith(
                    backgroundColor: WidgetStateProperty.all(Pallete.gradient1),
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStatus(int trackItemId) {
    final dailyConsumption = ref.watch(dailyConsumptionProvider);

    return dailyConsumption.when(
      data: (consumptions) {
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final todayConsumption = consumptions.firstWhere(
          (c) => c.trackItem == trackItemId && c.date == today,
          orElse: () => DailyConsumption(
            id: 0,
            trackItem: trackItemId,
            trackItemName: '',
            date: today,
            units: null,
          ),
        );

        if (todayConsumption.units == null) {
          return Text(
            'Not tracked today',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          );
        } else {
          return Text(
            'Today: ${todayConsumption.units} units',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          );
        }
      },
      loading: () => const Text('Loading...'),
      error: (_, __) => Text('Error loading data: ${_.toString()}'),
    );
  }

  Widget _buildQuickAddButton(TrackItem item) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.add,
          color: Pallete.gradient1,
          size: 16,
        ),
      ),
      onPressed: () => _quickAddUnit(item),
    );
  }

  Widget _buildWeeklyChart(
      int trackItemId, AsyncValue<List<DailyConsumption>> weeklyData) {
    return weeklyData.when(
      data: (data) {
        final filteredData =
            data.where((item) => item.trackItem == trackItemId).toList();

        if (filteredData.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              'No data available for the past week',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        }

        // Sort data by date.
        filteredData.sort((a, b) => a.date.compareTo(b.date));

        // Create spots for the chart.
        final spots = filteredData.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final item = entry.value;
          return FlSpot(index, item.units?.toDouble() ?? 0);
        }).toList();

        return Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= filteredData.length ||
                          value.toInt() < 0) {
                        return const SizedBox.shrink();
                      }
                      final date =
                          DateTime.parse(filteredData[value.toInt()].date);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              minX: 0,
              maxX: filteredData.length.toDouble() - 1,
              minY: 0,
              maxY: filteredData.fold<double>(
                      0,
                      (max, item) => (item.units?.toDouble() ?? 0) > max
                          ? (item.units?.toDouble() ?? 0)
                          : max) +
                  1,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: Theme.of(context).colorScheme.surface,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, _) => Center(
        child: Text('Error loading chart data: $error'),
      ),
    );
  }

  Widget _buildTrackingForm(TrackItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Record Today\'s Value',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _unitsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Units',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _recordConsumption(item.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  void _recordConsumption(int trackItemId) {
    if (_unitsController.text.isEmpty) return;

    final units = int.tryParse(_unitsController.text);
    if (units == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    ref.read(dailyConsumptionProvider.notifier).recordConsumption(
          trackItemId,
          today,
          units,
        );

    _unitsController.clear();
  }

  void _quickAddUnit(TrackItem item) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final dailyConsumption = ref.read(dailyConsumptionProvider);
    int currentUnits = 0;

    if (dailyConsumption is AsyncData) {
      final todayConsumption = dailyConsumption.value!.firstWhere(
        (c) => c.trackItem == item.id && c.date == today,
        orElse: () => DailyConsumption(
          id: 0,
          trackItem: item.id,
          trackItemName: item.name,
          date: today,
          units: 0,
        ),
      );

      currentUnits = todayConsumption.units ?? 0;
    }

    ref.read(dailyConsumptionProvider.notifier).recordConsumption(
          item.id,
          today,
          currentUnits + 1,
        );
  }
}
