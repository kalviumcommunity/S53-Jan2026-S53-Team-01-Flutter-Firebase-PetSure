import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';
import 'package:pet_sure/screens/caregiver/caregiver_main_screen.dart';
import 'package:pet_sure/screens/petowner/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_sure/services/user_service.dart';

enum UserRole { petOwner, caregiver }

class RoleSelectionScreen extends StatefulWidget {
  final String? name;
  const RoleSelectionScreen({super.key, this.name});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? selectedRole;

  Future<void> _handleContinue() async {
    if (selectedRole == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String roleString = selectedRole == UserRole.petOwner
        ? "pet_owner"
        : "caregiver";

    await UserService().createUserProfile(
      uid: currentUser.uid,
      name: widget.name ?? '',
      email: currentUser.email ?? "",
      role: roleString,
    );

    if (roleString == "pet_owner") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DiscoverScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CaregiverMainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   color: AppTheme.primaryOrange,
        //   icon: const Icon(Icons.arrow_back_ios),
        // ),
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
                children: const [
                  Text(
                    'How will you use PetSure?',
                    style: TextStyle(
                      fontSize: 36,
                      letterSpacing: -1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Select your primary role. You can switch between profiles anytime.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryGray,
                    ),
                  ),
                ],
              ),

              /// PET OWNER
              PetOwnerRoleCard(
                isSelected: selectedRole == UserRole.petOwner,
                onSelected: () {
                  setState(() {
                    selectedRole = UserRole.petOwner;
                  });
                },
              ),

              /// CAREGIVER
              CareGiverRoleCard(
                isSelected: selectedRole == UserRole.caregiver,
                onSelected: () {
                  setState(() {
                    selectedRole = UserRole.caregiver;
                  });
                },
              ),

              /// CONTINUE BUTTON
              ElevatedButton(
                onPressed: selectedRole == null ? null : _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRole == null
                      ? AppTheme.primaryGray
                      : AppTheme.primaryOrange,
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

/* ---------------- PET OWNER CARD ---------------- */

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
        padding: const EdgeInsets.all(4),
        child: Container(
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
              Positioned(
                right: 16,
                bottom: 16,
                child: Opacity(
                  opacity: 0.15,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: const AssetImage(
                      'assets/BackgroundDog.png',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerIcon(
                      icon: Icons.pets,
                      isSelected: isSelected,
                      onSelected: onSelected,
                      bgColor: Colors.yellow.withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "I'm a Pet Owner",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGray,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Find trusted caregivers for your pet',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6B3C),
                      ),
                    ),
                    const SizedBox(height: 6),
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

/* ---------------- CAREGIVER CARD ---------------- */

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
        padding: const EdgeInsets.all(4),
        child: Container(
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
              Positioned(
                right: 16,
                bottom: 16,
                child: Opacity(
                  opacity: 0.15,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: const AssetImage(
                      'assets/BackgroundCaregiver.png',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerIcon(
                      icon: Icons.directions_walk,
                      isSelected: isSelected,
                      onSelected: onSelected,
                      bgColor: const Color(0xFF6CEE2B).withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "I'm a Caregiver",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGray,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Get paid to care for pets nearby',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6B3C),
                      ),
                    ),
                    const SizedBox(height: 6),
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

/* ---------------- SHARED HEADER ICON ---------------- */

Widget _headerIcon({
  required IconData icon,
  required bool isSelected,
  required VoidCallback onSelected,
  required Color bgColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 26),
      ),
      GestureDetector(
        onTap: onSelected,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryOrange : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryOrange
                  : const Color(0xFFD0D0D0),
              width: 2,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
        ),
      ),
    ],
  );
}
