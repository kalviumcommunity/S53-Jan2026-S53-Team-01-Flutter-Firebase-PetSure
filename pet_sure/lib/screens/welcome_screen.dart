import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isClicked ? 'Flutter is Awesome 🚀' : 'Welcome to Flutter',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.pets,
              size: 80,
              color: isClicked ? Colors.orange[400] : Colors.grey,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isClicked = !isClicked;
                });
              },
              child: Text('Click Me', style: isClicked ? TextStyle(color: Colors.orange) : TextStyle(color: Colors.grey),),
            ),
          ],
        ),
      ),
    );
  }
}
