import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  String? selectedPetId;
  String selectedService = "Dog Walking";
  String selectedTime = "09:00 AM";
  DateTime selectedDate = DateTime.now();

  final TextEditingController priceController = TextEditingController();

  final services = ["Dog Walking", "Pet Sitting", "Grooming", "Check-up"];

  Future<void> _createJob() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a pet")),
      );
      return;
    }

    // 🔹 Fetch pet document
    final petDoc = await FirebaseFirestore.instance
        .collection('pets')
        .doc(selectedPetId)
        .get();

    final petData = petDoc.data();
    if (petData == null) return;

    // 🔹 Fetch owner document
    final ownerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final ownerData = ownerDoc.data();
    if (ownerData == null) return;

    await FirebaseFirestore.instance.collection('requests').add({
      // OWNER SNAPSHOT
      'ownerId': uid,
      'ownerName': ownerData['name'] ?? '',
      'ownerLocation': ownerData['location'] ?? '',

      // PET SNAPSHOT
      'petId': selectedPetId,
      'petName': petData['name'] ?? '',
      'breed': petData['breed'] ?? '',
      'petAge': petData['age'] ?? 0,
      'petImage': petData['imageUrl'] ?? '',

      // JOB DATA
      'serviceType': selectedService,
      'date': selectedDate,
      'time': selectedTime,
      'price': double.tryParse(priceController.text) ?? 0,

      'status': 'open',
      'appliedCaregivers': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job created successfully!")),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Create Job"),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PET SELECTION
            const Text(
              "Which pet?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pets')
                  .where('ownerId', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final pets = snapshot.data!.docs;

                return SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final petDoc = pets[index];
                      final data =
                          petDoc.data() as Map<String, dynamic>;

                      final isSelected =
                          selectedPetId == petDoc.id;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedPetId = petDoc.id;
                          });
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          margin:
                              const EdgeInsets.only(right: 12),
                          padding:
                              const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                (data['imageUrl'] != null &&
                                        data['imageUrl']
                                            .toString()
                                            .isNotEmpty)
                                    ? NetworkImage(
                                        data['imageUrl'])
                                    : null,
                            child: (data['imageUrl'] ==
                                        null ||
                                    data['imageUrl']
                                        .toString()
                                        .isEmpty)
                                ? const Icon(Icons.pets)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            /// SERVICE SELECTION
            const Text(
              "Select Service",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: services.map((service) {
                final selected =
                    selectedService == service;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedService = service;
                    });
                  },
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.orange.shade50
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.pets,
                          color: selected
                              ? AppTheme.primaryOrange
                              : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(service),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            /// PRICE FIELD
            const Text(
              "Enter Price",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter job price",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// TIME PICKER
            const Text(
              "Select Time",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: [
                "09:00 AM",
                "11:30 AM",
                "02:00 PM",
                "04:30 PM"
              ].map((time) {
                final selected =
                    selectedTime == time;

                return ChoiceChip(
                  label: Text(time),
                  selected: selected,
                  selectedColor:
                      AppTheme.primaryOrange,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            /// CREATE JOB BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.primaryOrange,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16),
                ),
                child: const Text("Create Job"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}