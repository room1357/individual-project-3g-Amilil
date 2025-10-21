import 'package:flutter/material.dart';

import 'advanced_expense_list_screen.dart';
import 'category_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[700]!, Colors.blue[50]!],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[600]!],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 45, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Welcome User!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Manage your expenses',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(context, Icons.home_rounded, 'Home', () => Navigator.pop(context)),
              _buildDrawerItem(context, Icons.person_rounded, 'Profile', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              }),
              _buildDrawerItem(context, Icons.settings_rounded, 'Settings', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }),
              _buildDrawerItem(context, Icons.account_balance_wallet_rounded, 'Expense', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdvancedExpenseListScreen()),
                );
              }),
              _buildDrawerItem(context, Icons.category_rounded, 'Category Management', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen()),
                );
              }),
              _buildDrawerItem(context, Icons.bar_chart_rounded, 'Statistics', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                );
              }),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.dashboard_rounded, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              
              // Quick Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Expenses',
                      '\$0.00',
                      Icons.trending_down_rounded,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'This Month',
                      '\$0.00',
                      Icons.calendar_today_rounded,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              
              // Menu Grid
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildModernCard(
                    context,
                    'Profile',
                    Icons.person_rounded,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    ),
                  ),
                  _buildModernCard(
                    context,
                    'Settings',
                    Icons.settings_rounded,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    ),
                  ),
                  _buildModernCard(
                    context,
                    'Expense',
                    Icons.account_balance_wallet_rounded,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdvancedExpenseListScreen()),
                    ),
                  ),
                  _buildModernCard(
                    context,
                    'Categories',
                    Icons.category_rounded,
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CategoryScreen()),
                    ),
                  ),
                  _buildModernCard(
                    context,
                    'Statistics',
                    Icons.bar_chart_rounded,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.2),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[900]),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue[900],
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}