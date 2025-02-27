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
            // 1. Header Section
            _buildHeader(context),

            // 2. Filter Options
            _buildFilterOptions(),

            // 3. Alert List (Scrollable)
            Expanded(child: _buildAlertList()),
          ],
        ),
      ),
    );
  }

  // 1. Header Section
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back Button
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
          // Empty SizedBox to balance the layout
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  // 2. Filter Options
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
              onPressed: () {
                // Clear filter functionality would be implemented here
              },
              child: const Text('Clear Filters'),
            ),
          ),
        ],
      ),
    );
  }

  // Severity Filter Dropdown
  Widget _buildSeverityFilter() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Severity',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: 'All',
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All')),
        DropdownMenuItem(value: 'High', child: Text('High')),
        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
        DropdownMenuItem(value: 'Low', child: Text('Low')),
      ],
      onChanged: (value) {
        // Filter by severity implementation would go here
      },
    );
  }

  // Condition Filter Dropdown
  Widget _buildConditionFilter() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Condition',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: 'All',
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All')),
        DropdownMenuItem(value: 'Diabetes', child: Text('Diabetes')),
        DropdownMenuItem(value: 'Hypertension', child: Text('Hypertension')),
        DropdownMenuItem(value: 'Asthma', child: Text('Asthma')),
      ],
      onChanged: (value) {
        // Filter by condition implementation would go here
      },
    );
  }

  // 3. Alert List
  Widget _buildAlertList() {
    // Sample alert data
    final List<Map<String, dynamic>> alerts = [
      {
        'patientName': 'John Doe',
        'condition': 'Diabetes',
        'severity': 'High',
        'message': 'High Blood Sugar – 250 mg/dL',
        'timestamp': '15 Oct 2023, 10:30 AM',
      },
      {
        'patientName': 'Jane Smith',
        'condition': 'Hypertension',
        'severity': 'Medium',
        'message': 'Blood Pressure – 150/95 mmHg',
        'timestamp': '15 Oct 2023, 09:45 AM',
      },
      {
        'patientName': 'Robert Johnson',
        'condition': 'Diabetes',
        'severity': 'Low',
        'message': 'Missed medication dose',
        'timestamp': '14 Oct 2023, 08:15 PM',
      },
      {
        'patientName': 'Emily Wilson',
        'condition': 'Asthma',
        'severity': 'High',
        'message': 'Severe asthma attack reported',
        'timestamp': '14 Oct 2023, 06:30 PM',
      },
      {
        'patientName': 'Michael Brown',
        'condition': 'Hypertension',
        'severity': 'Medium',
        'message': 'Heart rate – 110 BPM',
        'timestamp': '14 Oct 2023, 04:15 PM',
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

  // Alert Card
  Widget _buildAlertCard(BuildContext context, Map<String, dynamic> alert) {
    // Determine severity color
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View Details Button
                ElevatedButton(
                  onPressed: () {
                    // View details functionality would be implemented here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Details'),
                ),
                // Mark as Resolved Button
                OutlinedButton(
                  onPressed: () {
                    _showResolveConfirmation(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5F6368),
                  ),
                  child: const Text('Mark as Resolved'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Confirmation Dialog for Marking as Resolved
  void _showResolveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text(
            'Are you sure you want to mark this alert as resolved?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                // Mark as resolved functionality would be implemented here
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
