import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

class BookingBottomSheet extends StatefulWidget {
  final String caregiverId;
  final String caregiverName;

  const BookingBottomSheet({
    super.key,
    required this.caregiverId,
    required this.caregiverName,
  });

  @override
  State<BookingBottomSheet> createState() =>
      _BookingBottomSheetState();
}

class _BookingBottomSheetState
    extends State<BookingBottomSheet> {

  String? selectedRequestId;
  String? selectedService;

  Future<void> _assignCaregiver() async {
    if (selectedRequestId == null) return;

    await FirebaseFirestore.instance
        .collection('requests')
        .doc(selectedRequestId)
        .update({
      'caregiverId': widget.caregiverId,
      'caregiverName': widget.caregiverName, // optional (denormalization)
      'status': 'pending',
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking request sent 🎉"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 350,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text("Select Job",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),

          const SizedBox(height: 15),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requests')
                .where('ownerId',
                    isEqualTo: uid)
                .where('status',
                    isEqualTo: 'open')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final requests =
                  snapshot.data!.docs;

              if (requests.isEmpty) {
                return const Text(
                  "No open jobs available",
                  style:
                      TextStyle(color: Colors.grey),
                );
              }

              return SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,
                  itemCount: requests.length,
                  itemBuilder:
                      (context, index) {
                    final data =
                        requests[index].data()
                            as Map<String,
                                dynamic>;

                    final selected =
                        selectedRequestId ==
                            requests[index].id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRequestId =
                              requests[index].id;
                          selectedService =
                              data['serviceType'];
                        });
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(
                                right: 12),
                        padding:
                            const EdgeInsets.all(
                                16),
                        decoration:
                            BoxDecoration(
                          color: selected
                              ? AppTheme
                                  .primaryOrange
                              : Colors.grey
                                  .shade200,
                          borderRadius:
                              BorderRadius
                                  .circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            Text(
                              data['serviceType'] ??
                                  'Service',
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['time'] ?? '',
                              style: TextStyle(
                                color: selected
                                    ? Colors.white70
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  selectedRequestId == null
                      ? null
                      : _assignCaregiver,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppTheme.primaryOrange,
                padding:
                    const EdgeInsets
                        .symmetric(
                            vertical: 16),
              ),
              child: const Text(
                  "Send Booking Request"),
            ),
          )
        ],
      ),
    );
  }
}