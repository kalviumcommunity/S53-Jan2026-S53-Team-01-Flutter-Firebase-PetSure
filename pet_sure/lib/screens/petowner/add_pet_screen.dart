import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

class AddPetScreen extends StatefulWidget {
  final bool isEdit;
  final String? petId;
  final String? existingName;
  final String? existingBreed;
  final String? existingAge;
  final String? existingImage;
  final List<String>? existingTags;

  const AddPetScreen({
    super.key,
    this.isEdit = false,
    this.petId,
    this.existingName,
    this.existingBreed,
    this.existingAge,
    this.existingImage,
    this.existingTags,
  });

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final imageController = TextEditingController();

  List<String> selectedTags = [];

  final tagOptions = ["Active", "Indoor", "Vaccinated", "Friendly"];

  Future<void> _savePet() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (widget.isEdit) {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.petId)
          .update({
            'name': nameController.text,
            'breed': breedController.text,
            'age': int.tryParse(ageController.text) ?? 0,
            'imageUrl': imageController.text,
            'tags': selectedTags,
          });
    } else {
      await FirebaseFirestore.instance.collection('pets').add({
        'ownerId': uid,
        'name': nameController.text,
        'breed': breedController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'imageUrl': imageController.text,
        'tags': selectedTags,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'petsCount': FieldValue.increment(1),
      });
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      nameController.text = widget.existingName ?? '';
      breedController.text = widget.existingBreed ?? '';
      ageController.text = widget.existingAge ?? '';
      imageController.text = widget.existingImage ?? '';
      selectedTags = widget.existingTags ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Add New Pet"),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildField(nameController, "Pet Name"),
            _buildField(breedController, "Breed"),
            _buildField(ageController, "Age", isNumber: true),
            _buildField(imageController, "Image URL"),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tags",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: tagOptions.map((tag) {
                final selected = selectedTags.contains(tag);

                return ChoiceChip(
                  label: Text(tag),
                  selected: selected,
                  selectedColor: AppTheme.primaryOrange,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppTheme.primaryGray,
                  ),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _savePet,
                child: const Text(
                  "Save Pet",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
