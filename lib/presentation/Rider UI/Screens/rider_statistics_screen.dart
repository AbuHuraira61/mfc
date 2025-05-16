import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class RiderStatisticsScreen extends StatelessWidget {
  const RiderStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startTimestamp = Timestamp.fromDate(startOfMonth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Monthly Statistics', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('AssignedOrders')
            .where('riderId', isEqualTo: user?.uid)
            .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data?.docs ?? [];
          
          // Calculate statistics
          int totalOrders = orders.length;
          int completedOrders = 0;
          int dispatchedOrders = 0;
          int assignedOrders = 0;
          double totalEarnings = 0;
          
          // Daily statistics for chart
          Map<int, int> dailyOrders = {};
          Map<int, double> dailyEarnings = {};
          
          for (var order in orders) {
            final data = order.data() as Map<String, dynamic>;
            final status = data['status'] as String;
            final timestamp = data['timestamp'] as Timestamp;
            final day = timestamp.toDate().day;
            
            // Update status counts
            switch (status) {
              case 'Complete':
                completedOrders++;
                if (data['totalPrice'] != null) {
                  final price = double.parse(data['totalPrice'].toString());
                  totalEarnings += price;
                  dailyEarnings[day] = (dailyEarnings[day] ?? 0) + price;
                }
                break;
              case 'Dispatched':
                dispatchedOrders++;
                break;
              case 'Assigned':
                assignedOrders++;
                break;
            }
            
            // Update daily orders count
            dailyOrders[day] = (dailyOrders[day] ?? 0) + 1;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    _buildStatCard(
                      'Total Orders',
                      totalOrders.toString(),
                      Icons.assignment,
                      Colors.blue,
                    ),
                    SizedBox(width: 16),
                    _buildStatCard(
                      'Completed',
                      completedOrders.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      'In Progress',
                      dispatchedOrders.toString(),
                      Icons.local_shipping,
                      Colors.orange,
                    ),
                    SizedBox(width: 16),
                    _buildStatCard(
                      'Earnings',
                      '\$${totalEarnings.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.purple,
                    ),
                  ],
                ),
                
                // Performance Metrics
                SizedBox(height: 24),
                Text(
                  'Performance Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildPerformanceCard(completedOrders, totalOrders),
                
                // Daily Orders Chart
                SizedBox(height: 24),
                Text(
                  'Daily Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: _buildDailyOrdersChart(dailyOrders),
                ),
                
                // Daily Earnings Chart
                SizedBox(height: 24),
                Text(
                  'Daily Earnings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: _buildDailyEarningsChart(dailyEarnings),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(int completed, int total) {
    final completionRate = total > 0 ? (completed / total * 100) : 0.0;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completion Rate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${completionRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getCompletionRateColor(completionRate.toDouble()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: completionRate / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getCompletionRateColor(completionRate.toDouble()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOrdersChart(Map<int, int> dailyOrders) {
    if (dailyOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders data available',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    final spots = dailyOrders.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
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
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: primaryColor,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEarningsChart(Map<int, double> dailyEarnings) {
    if (dailyEarnings.isEmpty) {
      return Center(
        child: Text(
          'No earnings data available',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    final spots = dailyEarnings.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('\$${value.toInt()}');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
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
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 70) return Colors.orange;
    return Colors.red;
  }
} 