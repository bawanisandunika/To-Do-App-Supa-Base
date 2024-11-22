import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importing flutter_svg package
import 'auth_screen.dart'; // Importing the authentication screen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.center, // Center all elements vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SVG Image in the middle
              SvgPicture.asset(
                'assets/images/welcome_img.svg', // Path to your SVG image
                width: 200, // You can adjust the width as needed
                height: 200, // You can adjust the height as needed
              ),
              const SizedBox(height: 40),

              const Text(
                'Welcome to\n  To-Do App!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB88FF1), // Light purple text color
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Get organized and stay productive.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFB88FF1), // Light purple text color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  // Navigate to the Authentication Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 212, 217, 221),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
