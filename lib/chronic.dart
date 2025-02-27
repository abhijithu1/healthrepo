import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ChronicConditionMonitoringScreen extends StatelessWidget {
  const ChronicConditionMonitoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chronic Condition Monitoring',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConditionOverview(),
            const SizedBox(height: 24),
            _buildTrendGraphs(),
            const SizedBox(height: 24),
            _buildAlerts(),
          ],
        ),
      ),
      floatingActionButton: _buildAddDataButton(),
    );
  }

  Widget _buildConditionOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diabetes Type 2',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Diagnosed: 12 Oct 2018',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Controlled with Insulin Therapy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildKeyMetric('Last HbA1c', '6.5%', Colors.green),
                const SizedBox(width: 16),
                _buildKeyMetric('Last Glucose', '120 mg/dL', Colors.orange),
                const SizedBox(width: 16),
                _buildKeyMetric('Blood Pressure', '130/85', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetric(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendGraphs() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Blood Sugar Levels Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              height: 240,
              padding: const EdgeInsets.only(right: 16, left: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('JAN', style: style);
                              break;
                            case 2:
                              text = const Text('MAR', style: style);
                              break;
                            case 4:
                              text = const Text('MAY', style: style);
                              break;
                            case 6:
                              text = const Text('JUL', style: style);
                              break;
                            case 8:
                              text = const Text('SEP', style: style);
                              break;
                            case 10:
                              text = const Text('NOV', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            meta: meta, // Pass the meta parameter
                            space: 8.0, // Optional: Add spacing
                            child: text,
                          );
                        },
                        reservedSize: 22,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta, // Pass the meta parameter
                            space: 8.0, // Optional: Add spacing
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                        interval: 50,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 300,
                  lineBarsData: [
                    // Normal range line (green)
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 110),
                        FlSpot(1, 115),
                        FlSpot(2, 105),
                        FlSpot(3, 118),
                        FlSpot(4, 120),
                        FlSpot(5, 112),
                        FlSpot(6, 125),
                        FlSpot(7, 130),
                        FlSpot(8, 120),
                        FlSpot(9, 115),
                        FlSpot(10, 110),
                        FlSpot(11, 120),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),
                    // High range line (red)
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 180),
                        FlSpot(1, 185),
                        FlSpot(2, 250),
                        FlSpot(3, 230),
                        FlSpot(4, 210),
                        FlSpot(5, 220),
                        FlSpot(6, 200),
                        FlSpot(7, 185),
                        FlSpot(8, 190),
                        FlSpot(9, 195),
                        FlSpot(10, 200),
                        FlSpot(11, 190),
                      ],
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.red.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Within Range', Colors.green),
                const SizedBox(width: 24),
                _buildLegendItem('High', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alerts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildAlertCard(
          'High Blood Sugar – 250 mg/dL',
          '15 Oct 2023',
          Colors.red,
          true,
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          'Elevated Blood Pressure – 140/90',
          '10 Oct 2023',
          Colors.orange,
          false,
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          'Missed Medication – Insulin',
          '05 Oct 2023',
          Colors.yellow,
          false,
        ),
      ],
    );
  }

  Widget _buildAlertCard(
    String message,
    String date,
    Color color,
    bool isCritical,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCritical ? Colors.red : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    elevation: 0,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(10, 10),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('View Details'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(10, 10),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('Mark Resolved'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddDataButton() {
    return FloatingActionButton(
      onPressed: () {
        // Show options when FAB is clicked
      },
      backgroundColor: const Color(0xFF1A73E8),
      child: const Icon(Icons.add),
    );
  }
}

// Sample implementation of the Add Data button functionality
void _showAddDataOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildAddDataOption(
              context,
              Icons.bloodtype,
              'Add Blood Sugar Reading',
              Colors.red,
            ),
            const SizedBox(height: 16),
            _buildAddDataOption(
              context,
              Icons.favorite,
              'Add Blood Pressure Reading',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildAddDataOption(
              context,
              Icons.science,
              'Add Lab Result',
              Colors.purple,
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildAddDataOption(
  BuildContext context,
  IconData icon,
  String label,
  Color color,
) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
      // Handle option selection
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: color.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    ),
  );
}
