import 'package:eat_fit/views/home_screen/components/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_fit/views/home_screen/home_screen.dart';
import 'package:eat_fit/views/home_screen/diary/diary_screen.dart';
import 'package:eat_fit/views/report/report_screen.dart';
import 'package:eat_fit/views/auth%20screen/login_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const DiaryScreen(),
    const ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // User is logged in
            return Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
              bottomNavigationBar: BottomNavBar(
                currentIndex: _currentIndex,
                onTabSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            );
          } else {
            // User is not logged in
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
