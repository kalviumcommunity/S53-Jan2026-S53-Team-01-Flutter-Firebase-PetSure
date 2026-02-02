import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';
import 'package:pet_sure/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.0,
            colors: [Color(0xFFFFF6E5), Color(0xFFFFF1D6)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 80), // for empty space at the top
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.pets,
                        size: 56,
                        color: AppTheme.primaryOrange,
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'PetSure',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4E2A0B),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Warm discovery & monitoring for\nyour loved companions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF9A6A3A),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  height: 42,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFF1C27D)),
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.verified_user,
                        color: AppTheme.primaryOrange,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Trusted Connection',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB9773A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Color(0xFFF3E3C8),
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryOrange),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
