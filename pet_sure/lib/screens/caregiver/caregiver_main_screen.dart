import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';
import 'package:pet_sure/screens/caregiver/dashboard_screen.dart';
import 'package:pet_sure/screens/caregiver/requests_screen.dart';
import 'package:pet_sure/screens/caregiver/schedule_screen.dart';
import 'package:pet_sure/screens/caregiver/profile_screen.dart';

class CaregiverMainScreen extends StatefulWidget {
  const CaregiverMainScreen({super.key});

  @override
  State<CaregiverMainScreen> createState() => _CaregiverMainScreenState();
}

class _CaregiverMainScreenState extends State<CaregiverMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    RequestsScreen(),
    ScheduleScreen(),
    CaregiverProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryOrange,
        unselectedItemColor: AppTheme.tertiaryGray,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_open),
            label: 'Invites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
