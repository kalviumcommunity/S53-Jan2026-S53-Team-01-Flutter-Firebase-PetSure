import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';
import 'package:pet_sure/screens/caregiver/dashboard_screen.dart';

enum UserRole { petOwner, caregiver }

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppTheme.primaryOrange,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Select Your Role'),
        centerTitle: true,
        backgroundColor: AppTheme.background,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'How will you use PetSure?',
                    style: TextStyle(
                      fontSize: 36,
                      letterSpacing: -1.5,
                      fontWeight: FontWeight.w700,
                      // color: AppTheme.primaryOrange
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Select your primary role. You can switch between profiles anytime.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryGray,
                    ),
                  ),
                ],
              ),
              PetOwnerRoleCard(
                isSelected: selectedRole == UserRole.petOwner,
                onSelected: () {
                  setState(() {
                    selectedRole = UserRole.petOwner;
                  });
                },
              ),
              // const SizedBox(height: 8),
              CareGiverRoleCard(
                isSelected: selectedRole == UserRole.caregiver,
                onSelected: () {
                  setState(() {
                    selectedRole = UserRole.caregiver;
                  });
                },
              ),

              ElevatedButton(
                onPressed: selectedRole == null ? null : () {
                  log("Continue pressed");
                  if (selectedRole == UserRole.caregiver) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRole == null ? AppTheme.primaryGray : AppTheme.primaryOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetOwnerRoleCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onSelected;

  const PetOwnerRoleCard({
    super.key,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: AppTheme.primaryOrange, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(4), // 👈 outer border gap
        child: Container(
          // height: 160,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 252, 250, 246)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: AppTheme.primaryOrange, width: 2)
                : null,
          ),
          child: Stack(
            children: [
              /// BACKGROUND IMAGE (FADED)
              Positioned(
                right: 16,
                bottom: 16,
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset('assets/BackgroundDog.png', height: 120),
                ),
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ICON + CHECK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.yellow.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: AppTheme.primaryOrange,
                            size: 26,
                          ),
                        ),
                        GestureDetector(
                          onTap: onSelected,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryOrange
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryOrange
                                    : const Color(0xFFD0D0D0),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// TITLE
                    const Text(
                      "I'm a Pet Owner",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGray,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// SUBTITLE
                    const Text(
                      'Find trusted caregivers for your pet',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6B3C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// DESCRIPTION
                    const Text(
                      'Find the best care for your furry friends and track their daily activities.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF7A8F6A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CareGiverRoleCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onSelected;

  const CareGiverRoleCard({
    super.key,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: AppTheme.primaryOrange, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(4), // 👈 outer border gap
        child: Container(
          // height: 160,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 252, 250, 246)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: AppTheme.primaryOrange, width: 2)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              /// BACKGROUND IMAGE (FADED)
              Positioned(
                right: 16,
                bottom: 16,
                child: Opacity(
                  opacity: 0.15,
                  //fit the image in circle avatar
                  child: CircleAvatar(
                    radius: 60,
                    // backgroundColor: Colors.pink,
                    backgroundImage: AssetImage(
                      'assets/BackgroundCaregiver.png',
                    ),
                  ),
                ),
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ICON + CHECK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF6CEE2B,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.directions_walk,
                            // color: AppTheme.primaryOrange,
                            size: 26,
                          ),
                        ),
                        GestureDetector(
                          onTap: onSelected,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryOrange
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryOrange
                                    : const Color(0xFFD0D0D0),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// TITLE
                    const Text(
                      "I'm a Caregiver",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGray,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// SUBTITLE
                    const Text(
                      'Get paid to care for pets nearby',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6B3C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// DESCRIPTION
                    const Text(
                      'Start earning by caring for pets in your area and building your business.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF7A8F6A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
