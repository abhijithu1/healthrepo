import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/controllers/profilectrl.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1A73E8),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const PatientProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _pastVisitsExpanded = true;
  bool _diagnosesExpanded = false;
  bool _treatmentsExpanded = false;
  bool _medicationsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: PatientInfoHeader()),
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: VitalSignsSummary(),
                ),
                _buildMedicalHistorySection(),
                _buildChronicConditionSection(),
                _buildAllergiesSection(),
                _buildEmergencyContactsSection(),
                _buildNotesSection(),
                const SizedBox(height: 80), // Space for FAB
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddNewRecordFAB(),
    );
  }

  // 2. Medical History Section
  Widget _buildMedicalHistorySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 16),

          // Past Visits
          _buildExpandableSection(
            title: 'Past Visits',
            icon: Icons.event_note,
            isExpanded: _pastVisitsExpanded,
            onTap: () {
              setState(() {
                _pastVisitsExpanded = !_pastVisitsExpanded;
              });
            },
            children: [
              _buildVisitCard(
                date: '15 Oct 2023',
                reason: 'Routine Checkup',
                notes:
                    'Patient reported feeling well. Blood pressure normal. Recommended continued diet and exercise regimen.',
              ),
              _buildVisitCard(
                date: '30 Sep 2023',
                reason: 'Fever',
                notes:
                    'Patient had fever of 101°F. Prescribed antibiotics and rest. Follow-up scheduled.',
              ),
              _buildVisitCard(
                date: '12 Aug 2023',
                reason: 'Diabetes Follow-up',
                notes:
                    'Blood sugar levels higher than normal. Adjusted medication dosage. Emphasized importance of dietary control.',
              ),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View More',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Diagnoses
          _buildExpandableSection(
            title: 'Diagnoses',
            icon: Icons.medical_services,
            isExpanded: _diagnosesExpanded,
            onTap: () {
              setState(() {
                _diagnosesExpanded = !_diagnosesExpanded;
              });
            },
            children: [
              _buildDiagnosisCard(
                condition: 'Type 2 Diabetes',
                date: 'Diagnosed: 10 Jan 2018',
                status: 'Active',
                statusColor: Colors.red,
              ),
              _buildDiagnosisCard(
                condition: 'Hypertension',
                date: 'Diagnosed: 15 Mar 2019',
                status: 'Active',
                statusColor: Colors.orange,
              ),
              _buildDiagnosisCard(
                condition: 'Seasonal Allergies',
                date: 'Diagnosed: 05 May 2017',
                status: 'Seasonal',
                statusColor: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Treatments
          _buildExpandableSection(
            title: 'Treatments',
            icon: Icons.healing,
            isExpanded: _treatmentsExpanded,
            onTap: () {
              setState(() {
                _treatmentsExpanded = !_treatmentsExpanded;
              });
            },
            children: [
              _buildTreatmentCard(
                treatment: 'Insulin Therapy',
                dates: 'Started: 15 Feb 2018 - Ongoing',
                status: 'Ongoing',
                statusColor: Colors.blue,
              ),
              _buildTreatmentCard(
                treatment: 'Physical Therapy',
                dates: '10 Apr 2022 - 10 Jul 2022',
                status: 'Completed',
                statusColor: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Medications
          _buildExpandableSection(
            title: 'Medications',
            icon: Icons.medication,
            isExpanded: _medicationsExpanded,
            onTap: () {
              setState(() {
                _medicationsExpanded = !_medicationsExpanded;
              });
            },
            children: [
              _buildMedicationCard(
                medication: 'Metformin',
                dosage: '500mg, twice daily',
                dates: 'Prescribed: 20 Jan 2018 - Ongoing',
              ),
              _buildMedicationCard(
                medication: 'Lisinopril',
                dosage: '10mg, once daily',
                dates: 'Prescribed: 25 Mar 2019 - Ongoing',
              ),
              _buildMedicationCard(
                medication: 'Paracetamol',
                dosage: '500mg, as needed for pain',
                dates: 'Prescribed: 30 Sep 2023 - 07 Oct 2023',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Chronic Condition Monitoring Section
  Widget _buildChronicConditionSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chronic Condition Monitoring',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diabetes – Type 2, Diagnosed in 2018',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildBloodSugarChart(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem(
                        label: 'Last Blood Sugar',
                        value: '120 mg/dL',
                        isNormal: true,
                      ),
                      _buildMetricItem(
                        label: 'Average (30 days)',
                        value: '135 mg/dL',
                        isNormal: true,
                      ),
                      _buildMetricItem(
                        label: 'Highest Reading',
                        value: '180 mg/dL',
                        isNormal: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hypertension, Diagnosed in 2019',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildBloodPressureChart(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem(
                        label: 'Last BP Reading',
                        value: '130/85 mmHg',
                        isNormal: true,
                      ),
                      _buildMetricItem(
                        label: 'Average (30 days)',
                        value: '135/88 mmHg',
                        isNormal: true,
                      ),
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'High Reading',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                '160/95 mmHg',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Allergies Section
  Widget _buildAllergiesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Allergies',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildAllergyItem('Penicillin', 'Severe'),
                  const Divider(),
                  _buildAllergyItem('Peanuts', 'Moderate'),
                  const Divider(),
                  _buildAllergyItem('Dust Mites', 'Mild'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Emergency Contacts Section
  Widget _buildEmergencyContactsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Contacts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildContactItem('Maria Johnson', 'Spouse', '9876543210'),
                  const Divider(),
                  _buildContactItem('David Johnson', 'Son', '9876543211'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Notes Section
  Widget _buildNotesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doctor\'s Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient is generally compliant with medication but struggles with dietary restrictions. Recommend nutritionist referral at next visit. Family history of cardiac issues - should monitor closely.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Note'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitCard({
    required String date,
    required String reason,
    required String notes,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reason,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(notes, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard({
    required String condition,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.local_hospital, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condition,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentCard({
    required String treatment,
    required String dates,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.healing, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treatment,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    dates,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard({
    required String medication,
    required String dosage,
    required String dates,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.medication, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(dosage, style: const TextStyle(fontSize: 14)),
                  Text(
                    dates,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required bool isNormal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isNormal ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildAllergyItem(String allergen, String severity) {
    Color severityColor;
    if (severity == 'Severe') {
      severityColor = Colors.red;
    } else if (severity == 'Moderate') {
      severityColor = Colors.orange;
    } else {
      severityColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.warning, color: severityColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              allergen,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              severity,
              style: TextStyle(
                fontSize: 12,
                color: severityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String relation, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Icon(Icons.person, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  relation,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.phone, size: 16),
            label: Text(phone),
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodSugarChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 50,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white10, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.white10, strokeWidth: 1);
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
                const style = TextStyle(color: Colors.white60, fontSize: 10);
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('OCT 1', style: style);
                    break;
                  case 2:
                    text = const Text('OCT 5', style: style);
                    break;
                  case 4:
                    text = const Text('OCT 10', style: style);
                    break;
                  case 6:
                    text = const Text('OCT 15', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  meta: meta, // Pass the meta parameter
                  space: 8.0,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return SideTitleWidget(
                  meta: meta, // Pass the meta parameter
                  space: 8.0,
                  child: Text(
                    '${value.toInt()}',
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                    textAlign: TextAlign.left,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: 7,
        minY: 50,
        maxY: 200,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 110),
              FlSpot(1, 120),
              FlSpot(2, 135),
              FlSpot(3, 140),
              FlSpot(4, 130),
              FlSpot(5, 125),
              FlSpot(6, 120),
              FlSpot(7, 115),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.2),
            ),
          ),
          LineChartBarData(
            spots: const [
              FlSpot(0, 180),
              FlSpot(1, 170),
              FlSpot(2, 160),
              FlSpot(3, 150),
              FlSpot(4, 140),
              FlSpot(5, 130),
              FlSpot(6, 120),
              FlSpot(7, 110),
            ],
            isCurved: true,
            color: Colors.red.withOpacity(0.6),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${flSpot.y.toInt()} mg/dL',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBloodPressureChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white10, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.white10, strokeWidth: 1);
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
                const style = TextStyle(color: Colors.white60, fontSize: 10);
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('OCT 1', style: style);
                    break;
                  case 2:
                    text = const Text('OCT 5', style: style);
                    break;
                  case 4:
                    text = const Text('OCT 10', style: style);
                    break;
                  case 6:
                    text = const Text('OCT 15', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  meta: meta, // Pass the meta parameter
                  space: 8.0,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return SideTitleWidget(
                  meta: meta, // Pass the meta parameter
                  space: 8.0,
                  child: Text(
                    '${value.toInt()}',
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                    textAlign: TextAlign.left,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: 7,
        minY: 60,
        maxY: 180,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 130),
              FlSpot(1, 135),
              FlSpot(2, 140),
              FlSpot(3, 145),
              FlSpot(4, 150),
              FlSpot(5, 145),
              FlSpot(6, 140),
              FlSpot(7, 135),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
          LineChartBarData(
            spots: const [
              FlSpot(0, 85),
              FlSpot(1, 90),
              FlSpot(2, 95),
              FlSpot(3, 100),
              FlSpot(4, 95),
              FlSpot(5, 90),
              FlSpot(6, 85),
              FlSpot(7, 80),
            ],
            isCurved: true,
            color: Colors.green.withOpacity(0.6),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${flSpot.y.toInt()} mmHg',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  // Floating Action Button for Adding New Records
  Widget _buildAddNewRecordFAB() {
    return FloatingActionButton(
      onPressed: () {
        debugPrint("pressed");
        Get.toNamed("/anrc");
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

// Patient Info Header
class PatientInfoHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final prfc = Get.find<ProfileController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: const Icon(Icons.person, size: 40),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                prfc.name.value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202124),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Patient ID: ${prfc.id.value}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              // Add functionality to edit patient info
            },
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// Vital Signs Summary Widget
class VitalSignsSummary extends StatelessWidget {
  const VitalSignsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildVitalSignItem(
              'Heart Rate',
              '72 bpm',
              Icons.favorite,
              Colors.red,
            ),
            _buildVitalSignItem(
              'Blood Pressure',
              '120/80 mmHg',
              Icons.monitor_heart,
              Colors.blue,
            ),
            _buildVitalSignItem(
              'Temperature',
              '98.6°F',
              Icons.thermostat,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
