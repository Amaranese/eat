// import 'package:eat_fit/consts/consts.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// import '../auth screen/login_screen.dart';

// class SecondSplashScreen extends StatefulWidget {
//   const SecondSplashScreen({super.key});

//   @override
//   State<SecondSplashScreen> createState() => _SecondSplashScreenState();
// }

// class _SecondSplashScreenState extends State<SecondSplashScreen> {
//   void changeScreen() {
//     Future.delayed(const Duration(seconds: 3), () {
//       Get.to(() => const LoginScreen());
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     changeScreen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get the screen height for responsive design
//     final screenHeight = MediaQuery.of(context).size.height;
//     // Use MediaQuery for responsiveness
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: Stack(
//           children: [
//             // Content Section
//             Positioned(
//               left: size.width * 0.08,
//               top: size.height * 0.55,
//               child: Container(
//                 width: size.width * 0.84,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     const Text(
//                       'Eat Well',
//                       style: TextStyle(
//                         color: Color(0xFF1D1517),
//                         fontSize: 24,
//                         fontWeight: FontWeight.w700,
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Subtitle
//                     const Text(
//                       'Let\'s start a healthy lifestyle with us. We can determine your diet every day. Healthy eating is fun!',
//                       style: TextStyle(
//                         color: Color(0xFF7B6F72),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Circular Button
//             Positioned(
//               right: size.width * 0.08,
//               bottom: size.height * 0.08,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 },
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border:
//                         Border.all(width: 0.5, color: const Color(0xFFF7F8F8)),
//                     color: const Color(0xFF34C759),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_forward,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),

//             // Illustration Section
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: size.height * 0.5,
//                 child: Center(
//                   child: Container(
//                     width: size.width * 0.8,
//                     height: size.height * 0.4,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/onboard.png'), // Replace with your asset
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:eat_fit/consts/consts.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../auth screen/login_screen.dart';

class SecondSplashScreen extends StatefulWidget {
  final bool isManualNavigation; // Add the isManualNavigation parameter

  const SecondSplashScreen(
      {super.key,
      required this.isManualNavigation}); // Ensure it's marked as required

  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen> {
  void changeScreen() {
    if (!widget.isManualNavigation) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Get.to(() => const LoginScreen());
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    // Use MediaQuery for responsiveness
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          children: [
            // Content Section
            Positioned(
              left: size.width * 0.08,
              top: size.height * 0.55,
              child: Container(
                width: size.width * 0.84,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Eat Well',
                      style: TextStyle(
                        color: Color(0xFF1D1517),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    const Text(
                      'Let\'s start a healthy lifestyle with us. We can determine your diet every day. Healthy eating is fun!',
                      style: TextStyle(
                        color: Color(0xFF7B6F72),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Circular Button
            Positioned(
              right: size.width * 0.08,
              bottom: size.height * 0.08,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 0.5, color: const Color(0xFFF7F8F8)),
                    color: const Color(0xFF34C759),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Illustration Section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.5,
                child: Center(
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.4,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/onboard.png'), // Replace with your asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
