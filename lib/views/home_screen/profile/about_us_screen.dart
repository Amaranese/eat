import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "About App",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "EatFit is a mobile application to help you achieve your fitness goal...",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "We provide features such as:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            BulletPointText("Diary to log your meals and water intake"),
            BulletPointText(
                "Reports to get a visual representation and keep track of your weight"),
          ],
        ),
      ),
    );
  }
}

class BulletPointText extends StatelessWidget {
  final String text;

  const BulletPointText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(fontSize: 16),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ],
    );
  }
}
