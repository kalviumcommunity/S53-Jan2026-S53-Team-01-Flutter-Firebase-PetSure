import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

class EditCaregiverProfileScreen extends StatefulWidget {
  const EditCaregiverProfileScreen({super.key});

  @override
  State<EditCaregiverProfileScreen> createState() =>
      _EditCaregiverProfileScreenState();
}

class _EditCaregiverProfileScreenState
    extends State<EditCaregiverProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  final experienceController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  List<String> selectedServices = [];
  List<String> selectedDays = [];

  final allServices = [
    "Dog Walking",
    "House Sitting",
    "Drop-In Visit",
    "Pet Sitting",
  ];

  final allDays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data()!;

    nameController.text = data['name'] ?? '';
    locationController.text = data['location'] ?? '';
    bioController.text = data['bio'] ?? '';
    experienceController.text = (data['experienceYears'] ?? 0).toString();
    priceController.text = (data['pricePerHour'] ?? 0).toString();
    imageController.text = data['profileImage'] ?? '';

    selectedServices = List<String>.from(data['servicesOffered'] ?? []);
    selectedDays = List<String>.from(data['weeklyAvailability'] ?? []);

    setState(() {});
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': nameController.text,
      'location': locationController.text,
      'bio': bioController.text,
      'experienceYears': int.tryParse(experienceController.text) ?? 0,
      'pricePerHour': int.tryParse(priceController.text) ?? 0,
      'profileImage': imageController.text,
      'servicesOffered': selectedServices,
      'weeklyAvailability': selectedDays,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            _sectionTitle("BASIC INFO"),
            const SizedBox(height: 12),
            _buildCard(
              Column(
                children: [
                  _buildTextField(nameController, "Name"),
                  _buildTextField(locationController, "Location"),
                  _buildTextField(imageController, "Profile Image URL"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle("ABOUT YOU"),
            const SizedBox(height: 12),
            _buildCard(_buildTextField(bioController, "Bio", maxLines: 3)),

            const SizedBox(height: 24),

            _sectionTitle("EXPERIENCE & PRICING"),
            const SizedBox(height: 12),
            _buildCard(
              Column(
                children: [
                  _buildTextField(
                    experienceController,
                    "Experience (Years)",
                    isNumber: true,
                  ),
                  _buildTextField(
                    priceController,
                    "Price Per Hour",
                    isNumber: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle("SERVICES"),
            const SizedBox(height: 12),
            _buildCard(
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allServices.map((service) {
                  final selected = selectedServices.contains(service);

                  return ChoiceChip(
                    label: Text(service),
                    selected: selected,
                    selectedColor: AppTheme.primaryOrange,
                    backgroundColor: AppTheme.background,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.primaryGray,
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          selectedServices.add(service);
                        } else {
                          selectedServices.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle("WEEKLY AVAILABILITY"),
            const SizedBox(height: 12),
            _buildCard(
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allDays.map((day) {
                  final selected = selectedDays.contains(day);

                  return ChoiceChip(
                    label: Text(day),
                    selected: selected,
                    selectedColor: AppTheme.primaryOrange,
                    backgroundColor: AppTheme.background,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.primaryGray,
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveProfile,
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppTheme.secondaryGray,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppTheme.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
