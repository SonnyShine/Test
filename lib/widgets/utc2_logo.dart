import 'package:flutter/material.dart';

class UTC2Logo extends StatelessWidget {
  final String welcomeTitle;
  final String welcomeSubtitle;

  const UTC2Logo({
    Key? key,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // Background image cố định
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo cố định
          SizedBox(height: 50),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png', // Thay URL này bằng link ảnh thật
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Welcome text - có thể thay đổi
          Text(
            welcomeTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8),
          Text(
            welcomeSubtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
