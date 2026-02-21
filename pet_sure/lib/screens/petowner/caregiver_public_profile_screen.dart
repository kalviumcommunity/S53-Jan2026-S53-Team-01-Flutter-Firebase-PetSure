import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';
import 'package:pet_sure/screens/petowner/booking_bottom_sheet.dart';

class CaregiverPublicProfileScreen extends StatelessWidget {
  final String caregiverId;

  const CaregiverPublicProfileScreen({
    super.key,
    required this.caregiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(caregiverId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>? ?? {};

          final name = data['name'] ?? '';
          final image = data['profileImage'] ?? '';
          final location = data['location'] ?? '';
          final rating = (data['rating'] ?? 0).toString();
          final reviews =
              (data['reviewsCount'] ?? 0).toString();
          final experience =
              (data['experienceYears'] ?? 0).toString();
          final bio = data['bio'] ?? '';
          final price =
              (data['pricePerHour'] ?? 0).toString();

          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  const SizedBox(height: 10),

                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          Navigator.pop(context),
                    ),
                  ),

                  /// PROFILE IMAGE
                  CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        image.isNotEmpty
                            ? NetworkImage(image)
                            : null,
                    child: image.isEmpty
                        ? const Icon(Icons.person,
                            size: 40)
                        : null,
                  ),

                  const SizedBox(height: 12),

                  Text(name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold)),

                  const SizedBox(height: 4),

                  Text(location,
                      style:
                          const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 16),

                  /// STATS ROW
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(rating, "Rating"),
                      _statItem(reviews, "Reviews"),
                      _statItem("$experience yrs",
                          "Experience"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// BIO
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "About Me",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Text(bio),
                  ),

                  const SizedBox(height: 24),

                  /// PRICE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Starting from \$$price/hr",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// BOOK BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.primaryOrange,
                        padding:
                            const EdgeInsets.symmetric(
                                vertical: 16),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        _showBookBottomSheet(
                            context,
                            caregiverId,
                            name);
                      },
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold)),
        Text(label,
            style:
                const TextStyle(color: Colors.grey)),
      ],
    );
  }

  void _showBookBottomSheet(
      BuildContext context,
      String caregiverId,
      String caregiverName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BookingBottomSheet(
          caregiverId: caregiverId,
          caregiverName: caregiverName,
        );
      },
    );
  }
}