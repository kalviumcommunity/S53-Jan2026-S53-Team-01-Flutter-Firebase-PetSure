import 'package:flutter/material.dart';

class CaregiverProfileScreen extends StatelessWidget {
  final String name;
  final String imageAsset;
  final String rating;
  final String reviews;
  final String price;
  final String description;

  const CaregiverProfileScreen({
    super.key,
    required this.name,
    required this.imageAsset,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.description,
  });

  static const Color bg = Color(0xffF4F6F8);
  static const Color green = Color(0xff1F9254);
  static const Color orange = Color(0xffF59E0B);
  static const Color darkButton = Color(0xff0B151F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                _header(context),
                const SizedBox(height: 190),
                _aboutSection(),
                _servicesSection(),
                _reviewsSection(),
              ],
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _header(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Image.asset(
          imageAsset,
          height: 240,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 18,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Row(
                  children: [
                    CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.favorite_border, size: 18)),
                    SizedBox(width: 10),
                    CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.share, size: 18)),
                  ],
                )
              ],
            ),
          ),
        ),

        Positioned(
          top: 140,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 25)
              ],
            ),
            child: Column(
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F7EE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 14, color: green),
                      SizedBox(width: 4),
                      Text("Identity Verified",
                          style: TextStyle(fontSize: 11, color: green)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(child: _stat("$rating ★", "$reviews REVIEWS")),
                    _divider(),
                    Expanded(child: _stat("5+", "YEARS EXP.")),
                    _divider(),
                    Expanded(child: _stat("15m", "REPLY TIME")),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message_rounded),
                    label: const Text("Message"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkButton,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        const Positioned(
          top: 95,
          child: CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- ABOUT ----------------

  Widget _aboutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("About Me",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(description,
              style: const TextStyle(height: 1.5, color: Colors.black54)),
        ],
      ),
    );
  }

  // ---------------- SERVICES ----------------

  Widget _servicesSection() {
    return _section(
      "Services",
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [..
          const Text("STARTING FROM"),
          Text(price,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------------- REVIEWS ----------------

  Widget _reviewsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Reviews",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              Text("View All",
                  style: TextStyle(
                      color: green, fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: 12),
          ReviewTile(
            name: "Michael R.",
            image: "assets/reviewer_1.png",
            time: "2 days ago",
            review:
                "Sarah was amazing with my husky! She sent regular updates and photos.",
          ),
          SizedBox(height: 12),
          ReviewTile(
            name: "Emily W.",
            image: "assets/reviewer_2.png",
            time: "1 week ago",
            review:
                "Very reliable and punctual. My cat was very comfortable with Sarah.",
          ),
        ],
      ),
    );
  }

  // ---------------- BOTTOM BAR ----------------

  Widget _bottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(price,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: orange),
              child: const Text("Book Now"),
            )
          ],
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  static Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  static Widget _divider() {
    return Container(height: 32, width: 1, color: Colors.grey.shade300);
  }

  Widget _section(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            child
          ],
        ),
      ),
    );
  }
}

// ---------------- REVIEW TILE ----------------

class ReviewTile extends StatelessWidget {
  final String name;
  final String image;
  final String review;
  final String time;

  const ReviewTile({
    super.key,
    required this.name,
    required this.image,
    required this.review,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundImage: AssetImage(image)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13.5)),
                      Text("Verified Client • $time",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                    ]),
              ),
              const Row(
                children: [
                  Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                  Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                  Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                  Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                  Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Text("“$review”",
              style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}