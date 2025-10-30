import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CumulativeChart extends StatefulWidget {
  final Map<int, double> dailyExpenses;
  final DateTime billingPeriodStart;
  
  const CumulativeChart({
    super.key, 
    required this.dailyExpenses,
    required this.billingPeriodStart,
  });

  @override
  State<CumulativeChart> createState() => _CumulativeChartState();
}

class _CumulativeChartState extends State<CumulativeChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, right: 12.0), // Add padding for top and right labels
      child: LineChart(mainLineData()),
    );
  }

  List<FlSpot> getCumulativeSpots() {
    if (widget.dailyExpenses.isEmpty) {
      return [];
    }

    double cumulativeSum = 0.0;
    final spots = <FlSpot>[];
    
    // Sort entries by day to ensure proper cumulative calculation
    final sortedEntries = widget.dailyExpenses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    for (var entry in sortedEntries) {
      cumulativeSum += entry.value.clamp(0.0, double.infinity);
      spots.add(FlSpot(entry.key.toDouble(), cumulativeSum));
    }
    
    return spots;
  }

  LineChartData mainLineData() {
    if (widget.dailyExpenses.isEmpty) {
      return LineChartData();
    }

    final spots = getCumulativeSpots();
    final maxCumulative = spots.isNotEmpty ? spots.last.y : 0.0;
    final maxY = maxCumulative > 0 ? (maxCumulative * 1.2).ceilToDouble() : 100.0; // Increased from 1.15 to 1.2 for more top space
    final minY = 0.0;
    
    // Get min and max X values from the data
    final minX = widget.dailyExpenses.keys.reduce(min).toDouble();
    final maxX = widget.dailyExpenses.keys.reduce(max).toDouble();
    
    // Calculate interval for bottom titles based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final numberOfDays = widget.dailyExpenses.length;
    int interval = 1;
    
    if (screenWidth < 360) {
      interval = numberOfDays > 20 ? 7 : numberOfDays > 14 ? 5 : 2;
    } else if (screenWidth < 400) {
      interval = numberOfDays > 25 ? 7 : numberOfDays > 18 ? 5 : numberOfDays > 12 ? 3 : 2;
    } else {
      interval = numberOfDays > 25 ? 5 : numberOfDays > 15 ? 3 : 2;
    }

    return LineChartData(
      minY: minY,
      maxY: maxY,
      minX: minX, // No padding - keep exact data range
      maxX: maxX, // No padding - keep exact data range
      clipData: const FlClipData.none(), // Don't clip to show boundary values
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY > 0 ? maxY / 5 : 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42, // Reduced from 55 to minimize left space
            interval: maxY > 0 ? maxY / 5 : 20,
            getTitlesWidget: leftTitles,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38, // Increased from 35 to show bottom numbers fully
            interval: interval.toDouble(),
            getTitlesWidget: bottomTitles,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          left: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false, // Straight lines, no smoothing
          color: Theme.of(context).colorScheme.tertiary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 3,
                color: Theme.of(context).colorScheme.tertiary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Theme.of(context).colorScheme.tertiary,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final dayNumber = spot.x.toInt();
              final actualDate = widget.billingPeriodStart.add(Duration(days: dayNumber - 1));
              final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
              final formattedDate = '${monthNames[actualDate.month - 1]} ${actualDate.day}';
              
              return LineTooltipItem(
                '$formattedDate\nTotal: LKR ${spot.y.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                strokeWidth: 2,
                dashArray: [5, 5],
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: Theme.of(context).colorScheme.tertiary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      fontWeight: FontWeight.w500,
      fontSize: 11,
    );
    
    final dayNumber = value.toInt();
    final actualDate = widget.billingPeriodStart.add(Duration(days: dayNumber - 1));
    
    // Format date as "25" (just the day)
    String text = actualDate.day.toString();
    
    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      fontWeight: FontWeight.w500,
      fontSize: 9, // Reduced from 10 to fit better
    );
    
    String text;
    
    // Always show 0 at the bottom
    if (value == 0) {
      text = '0';
    } else if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(1)}K';
    } else if (value >= 100) {
      text = '${value.toInt()}';
    } else {
      text = '${value.toStringAsFixed(0)}';
    }

    return SideTitleWidget(
      meta: meta,
      space: 4, // Reduced space for more chart area
      child: Text(text, style: style),
    );
  }
}
