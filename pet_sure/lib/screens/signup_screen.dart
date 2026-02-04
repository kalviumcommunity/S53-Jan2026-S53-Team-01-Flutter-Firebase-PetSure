import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_sure/core/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.tertiaryGray),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppTheme.primaryOrange.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // ANDROID
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/puppy.jpg',
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              /// TITLE
              const Text(
                'Join our furry\ncommunity',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 10),

              /// SUBTITLE
              const Text(
                'Your pet’s safety and happiness are our priority. '
                'We’re here to help you find the perfect care.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.secondaryGray,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              /// FULL NAME
              const Text('Full Name',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration('e.g. Jane Doe'),
              ),

              const SizedBox(height: 14),

              /// EMAIL
              const Text('Email Address',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('name@example.com'),
              ),

              const SizedBox(height: 14),

              /// PASSWORD
              const Text('Password',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                obscureText: _obscurePassword,
                decoration:
                    _inputDecoration('Minimum 8 characters').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.tertiaryGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// CREATE ACCOUNT
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// SECURE TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock,
                      size: 14, color: AppTheme.secondaryGray),
                  SizedBox(width: 6),
                  Text(
                    'Secure, encrypted registration',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// OR
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(color: AppTheme.secondaryGray),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              /// GOOGLE + APPLE
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      label: const Text('Apple'),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// LOGIN LINK
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'Already part of the family? ',
                    style:
                        TextStyle(color: AppTheme.secondaryGray),
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// TERMS
              const Center(
                child: Text(
                  'By joining, you agree to our Terms and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.secondaryGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
