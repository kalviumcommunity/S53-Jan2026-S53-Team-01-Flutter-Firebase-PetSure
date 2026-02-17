import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  static const Color amberWarm = Color(0xFFFFB347);
  static const Color amberDeep = Color(0xFFE69526);
  static const Color bgLight = Color(0xFFFDFCFB);
  static const Color textDark = Color(0xFF131811);
  static const Color verifiedGreen = Color(0xFF4A7043);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,

      /* ---------------- HEADER ---------------- */
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/dog.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Find care for Buddy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 14, color: amberDeep),
                    SizedBox(width: 2),
                    Text(
                      'Brooklyn, NY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6F8961),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: textDark),
            onPressed: () {},
          ),
        ],
      ),

      /* ---------------- BODY ---------------- */
      body: ListView(
        padding: const EdgeInsets.only(bottom: 140),
        children: [
          _searchBar(),
          _filters(),
          _sectionHeader(),

          _sitterCard(
            imageAsset: 'assets/sitter_1.png',
            name: 'Sarah Jenkins',
            rating: '4.9',
            reviews: '142',
            price: '\$25/hr',
            description: 'Expert in puppy care and high-energy breeds.',
            badges: const ['120+ walks', 'Repeat client'],
          ),

          _sitterCard(
            imageAsset: 'assets/sitter_2.png',
            name: 'Marcus Chen',
            rating: '5.0',
            reviews: '85',
            price: '\$32/hr',
            description:
                'Providing calm, reliable care for senior and large dogs.',
            badges: const ['85+ walks', 'Large dogs'],
          ),
        ],
      ),

      /* ---------------- BOTTOM NAV ---------------- */
      // bottomNavigationBar: _bottomNav(),
    );
  }

  /* ================= WIDGETS ================= */

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            SizedBox(width: 12),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search sitters...',
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(Icons.tune, color: Colors.grey),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _filters() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('Dog Walkers', selected: true),
          _filterChip('House Sitting'),
          _filterChip('Boarding'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? amberWarm : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? Colors.white : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Nearby top-rated',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              color: amberDeep,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sitterCard({
    required String imageAsset,
    required String name,
    required String rating,
    required String reviews,
    required String price,
    required String description,
    required List<String> badges,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: Image.asset(
                    imageAsset,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _verifiedBadge(),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Wrap(
                    spacing: 8,
                    children: badges.map(_darkBadge).toList(),
                  ),
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(Icons.favorite,
                      color: Colors.red, size: 22),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: amberDeep),
                              Text(
                                ' $rating ($reviews reviews)',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: amberWarm,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Book Now'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.chat_bubble_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.verified,
              size: 16, color: verifiedGreen),
          SizedBox(width: 4),
          Text(
            'Verified ID',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: verifiedGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


}
