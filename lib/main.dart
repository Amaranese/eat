import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:eat_fit/views/splash_screen/first_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eat Fit',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        fontFamily: 'Inter',
      ),
      home: FirstSplashScreen(),
    );
  }
}
