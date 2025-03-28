// import 'package:eat_fit/consts/consts.dart';
// import 'package:eat_fit/views/splash_screen/second_splash_screen.dart';
// import 'package:get/get.dart';
// import '../../common_widgets/custom_button.dart';
// import '../auth screen/login_screen.dart';

// class FirstSplashScreen extends StatefulWidget {
//   const FirstSplashScreen({super.key});

//   @override
//   State<FirstSplashScreen> createState() => _FirstSplashScreenState();
// }

// class _FirstSplashScreenState extends State<FirstSplashScreen> {
//   bool _hasNavigated = false; // Flag to track navigation

//   // Method to navigate to the next screen after a delay
//   void changeScreen() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!_hasNavigated) {
//         // Check if navigation hasn't already occurred
//         _hasNavigated = true;
//         Get.to(() => const SecondSplashScreen());
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     changeScreen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, // Transparent to show gradient
//         elevation: 0, // Remove shadow for a cleaner look
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.to(() => const SecondSplashScreen());
//             },
//             child: const Text(
//               "Skip",
//               style: TextStyle(fontSize: 17, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       extendBodyBehindAppBar: true, // Extend the body to behind the app bar
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF6BAD59), // Light green
//               Color(0xFF48962A), // Medium green
//               Color(0xFF378B12), // Dark green
//             ],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   RichText(
//                     text: const TextSpan(
//                       text: 'Eat',
//                       style: TextStyle(
//                         fontSize: 35,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: 'Fit',
//                           style: TextStyle(
//                             fontSize: 50,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Simplified Food Tracking',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.normal,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Place the button at the bottom
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 60,
//                 child: customButton(
//                   color: Colors.white,
//                   onPress: () {
//                     Get.to(() => LoginScreen());
//                   },
//                   textcolor: const Color(0xFF378B12),
//                   title: "Get Started",
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:eat_fit/consts/consts.dart';
import 'package:eat_fit/views/auth%20screen/login_screen.dart';
import 'package:eat_fit/views/splash_screen/second_splash_screen.dart';
import 'package:get/get.dart';
import '../../common_widgets/custom_button.dart';

class FirstSplashScreen extends StatefulWidget {
  const FirstSplashScreen({super.key});

  @override
  State<FirstSplashScreen> createState() => _FirstSplashScreenState();
}

class _FirstSplashScreenState extends State<FirstSplashScreen> {
  Timer? _timer;

  // Method to navigate to the next screen after a delay
  void changeScreen() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Get.to(() => const SecondSplashScreen(isManualNavigation: false));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  void dispose() {
    // Cancel the timer to prevent navigation when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0, // Remove shadow for a cleaner look
        actions: [
          TextButton(
            onPressed: () {
              _timer?.cancel(); // Cancel the delayed navigation
              Get.to(() => const LoginScreen());
            },
            child: const Text(
              "Skip",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Extend the body to behind the app bar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6BAD59), // Light green
              Color(0xFF48962A), // Medium green
              Color(0xFF378B12), // Dark green
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Eat',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Fit',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Simplified Food Tracking',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Place the button at the bottom
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: customButton(
                  color: Colors.white,
                  onPress: () {
                    _timer?.cancel(); // Cancel the delayed navigation
                    Get.to(() =>
                        const SecondSplashScreen(isManualNavigation: true));
                  },
                  textcolor: const Color(0xFF378B12),
                  title: "Get Started",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
