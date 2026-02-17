import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

// TODO: update imports with your actual screen paths
import 'package:pet_sure/screens/petowner/dashboard_screen.dart';
import 'package:pet_sure/screens/petowner/invites_screen.dart';
import 'package:pet_sure/screens/petowner/profile_screen.dart';

class PetOwnerMainScreen extends StatefulWidget {
  const PetOwnerMainScreen({super.key});

  @override
  State<PetOwnerMainScreen> createState() => _PetOwnerMainScreenState();
}

class _PetOwnerMainScreenState extends State<PetOwnerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DiscoverScreen(),
    InviteScreen(),
    ProfileScreen(),
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
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_open_outlined),
            activeIcon: Icon(Icons.file_open),
            label: 'Invites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Pets',
          ),
        ],
      ),
    );
  }
}
