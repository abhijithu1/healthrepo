import 'package:flutter/material.dart';

class AlertsAndNotificationsScreen extends StatelessWidget {
  const AlertsAndNotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilterOptions(),
            Expanded(child: _buildAlertList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 24),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Alerts and Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSeverityFilter()),
              const SizedBox(width: 16),
              Expanded(child: _buildConditionFilter()),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Clear Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityFilter() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Severity',
        border: OutlineInputBorder(),
      ),
      value: 'All',
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All')),
        DropdownMenuItem(value: 'High', child: Text('High')),
        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
        DropdownMenuItem(value: 'Low', child: Text('Low')),
      ],
      onChanged: (value) {},
    );
  }

  Widget _buildConditionFilter() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Condition',
        border: OutlineInputBorder(),
      ),
      value: 'All',
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All')),
        DropdownMenuItem(value: 'Diabetes', child: Text('Diabetes')),
        DropdownMenuItem(value: 'Hypertension', child: Text('Hypertension')),
        DropdownMenuItem(value: 'Asthma', child: Text('Asthma')),
      ],
      onChanged: (value) {},
    );
  }

  Widget _buildAlertList() {
    final List<Map<String, dynamic>> alerts = [
      {
        'patientName': 'John Doe',
        'condition': 'Heart Disease',
        'severity': 'High',
        'message': 'New report uploaded: Severe risk of heart attack detected!',
        'timestamp': '15 Oct 2023, 10:30 AM',
      },
      {
        'patientName': 'Jane Smith',
        'condition': 'Hypertension',
        'severity': 'Medium',
        'message':
            'Recent checkup: Blood pressure levels are higher than normal.',
        'timestamp': '15 Oct 2023, 09:45 AM',
      },
      {
        'patientName': 'Robert Johnson',
        'condition': 'Diabetes',
        'severity': 'Low',
        'message': 'Routine checkup: Reports indicate normal readings.',
        'timestamp': '14 Oct 2023, 08:15 PM',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(context, alert);
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, Map<String, dynamic> alert) {
    Color severityColor;
    switch (alert['severity']) {
      case 'High':
        severityColor = Colors.red;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        break;
      case 'Low':
        severityColor = Colors.green;
        break;
      default:
        severityColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    alert['patientName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alert['severity'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              alert['condition'],
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(alert['message'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              alert['timestamp'],
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
