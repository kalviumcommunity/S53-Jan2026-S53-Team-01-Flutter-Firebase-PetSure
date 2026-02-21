import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
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

  Widget _buildSentRequestsTab() {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('appliedCaregivers', arrayContains: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = snapshot.data!.docs;

        if (jobs.isEmpty) {
          return const Center(child: Text("No applications yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final data = jobs[index].data() as Map<String, dynamic>;

            final status = data['status'];

            Color statusColor;
            Color statusTextColor;

            switch (status) {
              case 'accepted':
                statusColor = Colors.green.shade50;
                statusTextColor = Colors.green;
                break;
              case 'rejected':
                statusColor = Colors.red.shade50;
                statusTextColor = Colors.red;
                break;
              default:
                statusColor = Colors.orange.shade50;
                statusTextColor = Colors.orange;
            }

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

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildSentRequestCard(
                docId: jobs[index].id,
                name: data['petName'] ?? '',
                ownerName: data['ownerName'] ?? '',
                image: data['imageUrl'] ?? '',
                service: data['serviceType'] ?? '',
                time: formattedDate,
                status: status.toString().toUpperCase(),
                statusColor: statusColor,
                statusTextColor: statusTextColor,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInvitesTab() {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('caregiverId', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final invites = snapshot.data!.docs;

        if (invites.isEmpty) {
          return const Center(child: Text("No invites"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: invites.length,
          itemBuilder: (context, index) {
            final doc = invites[index];
            final data = doc.data() as Map<String, dynamic>;

            final dynamic rawDate = data['date'];
            String formattedDate = '';

            if (rawDate is Timestamp) {
              final date = rawDate.toDate();
              formattedDate = "${date.day}/${date.month}/${date.year}";
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInviteCard(
                docId: doc.id,
                name: data['petName'] ?? '',
                ownerName: data['ownerName'] ?? '',
                image: data['petImage'] ?? '',
                service: data['serviceType'] ?? '',
                time: formattedDate,
                price: data['price']?.toString() ?? '',
                isPrivate: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('status', whereIn: ['accepted', 'rejected'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final all = snapshot.data!.docs;

        final history = all.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final List applied = data['appliedCaregivers'] ?? [];

          return data['caregiverId'] == currentUser.uid ||
              applied.contains(currentUser.uid);
        }).toList();

        if (history.isEmpty) {
          return const Center(child: Text("No history yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final data = history[index].data() as Map<String, dynamic>;

            final dynamic rawDate = data['date'];
            String formattedDate = '';

            if (rawDate is Timestamp) {
              final date = rawDate.toDate();
              formattedDate = "${date.day}/${date.month}";
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildHistoryItem(
                date: formattedDate,
                name: data['petName'] ?? '',
                service: data['serviceType'] ?? '',
                price: data['price']?.toString() ?? '',
                isLast: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSentRequestCard({
    required String docId,
    required String name,
    required String ownerName,
    required String image,
    required String service,
    required String time,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
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
              CircleAvatar(radius: 24, backgroundImage: NetworkImage(image)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppTheme.primaryGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Owned by $ownerName',
                      style: const TextStyle(
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
    required String docId,
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
              CircleAvatar(radius: 24, backgroundImage: AssetImage(image)),
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
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('requests')
                        .doc(docId)
                        .update({'status': 'rejected'});
                  },
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
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('requests')
                        .doc(docId)
                        .update({'status': 'accepted'});
                  },
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
