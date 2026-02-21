import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Requests & Invites',
          style: TextStyle(
            color: AppTheme.primaryGray,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: AppTheme.background,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: AppTheme.primaryGray,
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryGray,
          unselectedLabelColor: AppTheme.tertiaryGray,
          indicatorColor: AppTheme.primaryOrange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Sent'),
            Tab(text: 'Invites (2)'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSentRequestsTab(),
          _buildInvitesTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green.shade50;
      case 'rejected':
        return Colors.red.shade50;
      case 'pending':
        return Colors.orange.shade50;
      case 'applied':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      case 'applied':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSentRequestsTab() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('ownerId', isEqualTo: uid)
          .where('caregiverId', isNotEqualTo: null)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No sent requests"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final caregiverId = data['caregiverId'];

            if (caregiverId == null) {
              return const SizedBox();
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(caregiverId)
                  .get(),
              builder: (context, caregiverSnapshot) {
                if (!caregiverSnapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final caregiverData =
                    caregiverSnapshot.data!.data() as Map<String, dynamic>?;

                final caregiverName = caregiverData?['name'] ?? 'Caregiver';
                final caregiverImage = caregiverData?['imageUrl'] ?? '';

                return _buildSentRequestCard(
                  docId: doc.id,
                  caregiverName: caregiverName,
                  caregiverImage: caregiverImage,
                  service: data['serviceType'] ?? '',
                  time: data['time'] ?? '',
                  status: data['status'] ?? '',
                  statusColor: _statusColor(data['status']),
                  statusTextColor: _statusTextColor(data['status']),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInvitesTab() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('ownerId', isEqualTo: uid)
          .where('status', isEqualTo: 'open')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = snapshot.data!.docs;

        List<Widget> inviteWidgets = [];

        for (var jobDoc in jobs) {
          final data = jobDoc.data() as Map<String, dynamic>;
          final List<dynamic> appliedCaregivers =
              data['appliedCaregivers'] ?? [];

          if (appliedCaregivers.isEmpty) continue;

          for (var caregiverId in appliedCaregivers) {
            inviteWidgets.add(
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(caregiverId)
                    .get(),
                builder: (context, caregiverSnapshot) {
                  if (!caregiverSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final caregiverData =
                      caregiverSnapshot.data!.data() as Map<String, dynamic>?;

                  final caregiverName = caregiverData?['name'] ?? 'Caregiver';
                  final caregiverImage = caregiverData?['imageUrl'] ?? '';

                  return Column(
                    children: [
                      _buildInviteCard(
                        name: caregiverName,
                        ownerName: "Applied for your job",
                        image: caregiverImage,
                        service: data['serviceType'] ?? '',
                        time: data['time'] ?? '',
                        price: data['price']?.toString() ?? '',
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(jobDoc.id)
                                  .update({
                                    'appliedCaregivers': FieldValue.arrayRemove(
                                      [caregiverId],
                                    ),
                                  });
                            },
                            child: const Text("Reject"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(jobDoc.id)
                                  .update({
                                    'caregiverId': caregiverId,
                                    'status': 'pending',
                                    'appliedCaregivers': [],
                                  });
                            },
                            child: const Text("Accept"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            );
          }
        }

        if (inviteWidgets.isEmpty) {
          return const Center(child: Text("No invites"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: inviteWidgets,
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('ownerId', isEqualTo: uid)
          .where('status', whereIn: ['accepted', 'rejected', 'completed'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No history yet"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final dynamic rawDate = data['date'];

            String formattedDate = '';

            if (rawDate is Timestamp) {
              final date = rawDate.toDate();
              formattedDate =
                  "${date.day.toString().padLeft(2, '0')}/"
                  "${date.month.toString().padLeft(2, '0')}/"
                  "${date.year}";
            } else if (rawDate is String) {
              // If older jobs stored date as string
              formattedDate = rawDate;
            }

            return _buildHistoryItem(
              name: data['petName'] ?? '',
              price: data['price'].toString(),
              service: data['serviceType'] ?? '',
              isLast: true,
              date: formattedDate,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSentRequestCard({
    required String docId,
    required String caregiverName,
    required String caregiverImage,
    required String service,
    required String time,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: caregiverImage.isNotEmpty
                    ? NetworkImage(caregiverImage)
                    : null,
                child: caregiverImage.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caregiverName,
                      style: const TextStyle(
                        color: AppTheme.primaryGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'Caregiver',
                      style: TextStyle(
                        color: AppTheme.secondaryGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 14,
                            color: AppTheme.tertiaryGray,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'SERVICE',
                            style: TextStyle(
                              color: AppTheme.tertiaryGray,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service,
                        style: const TextStyle(
                          color: AppTheme.primaryGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppTheme.tertiaryGray,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'TIME',
                            style: TextStyle(
                              color: AppTheme.tertiaryGray,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppTheme.primaryGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Withdraw button if still open
          if (status.toLowerCase() == 'open')
            TextButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection('requests')
                    .doc(docId)
                    .update({
                      'appliedCaregivers': FieldValue.arrayRemove([uid]),
                    });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Application withdrawn")),
                );
              },
              child: const Text(
                "Withdraw",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInviteCard({
    required String name,
    required String ownerName,
    required String image,
    required String service,
    required String time,
    required String price,
    bool isPrivate = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                child: image.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: AppTheme.primaryGray,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 14,
                        ),
                      ],
                    ),
                    Text(
                      'From $ownerName',
                      style: const TextStyle(
                        color: AppTheme.secondaryGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPrivate)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'PRIVATE',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.secondaryGray,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppTheme.primaryGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$$price',
                  style: const TextStyle(
                    color: AppTheme.primaryOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.background,
                    foregroundColor: AppTheme.secondaryGray,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Accept Invite',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String name,
    required String service,
    required String price,
    required bool isLast,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              style: const TextStyle(
                color: AppTheme.secondaryGray,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.primaryGray,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service,
                  style: const TextStyle(
                    color: AppTheme.secondaryGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$$price',
            style: const TextStyle(
              color: AppTheme.primaryGray,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
