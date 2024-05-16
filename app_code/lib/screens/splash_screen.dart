import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splash_screen/screens/home_screen.dart';
import 'package:splash_screen/screens/signin_screen.dart';
import 'package:splash_screen/utils/color_utils.dart';
import 'package:workmanager/workmanager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));

    super.initState();
    // Register the periodic task
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
            // hexStringToColor("0D8142"),
          ], begin: Alignment.topRight, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/White.png",
                  height: 200,
                  width: 200,
                ),
                const Text(
                  "Green Guard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Column(
              children: [
                Text("Devoloped By", style: TextStyle(color: Colors.white)),
                Text(
                  "Rinnovators",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text("Powered By", style: TextStyle(color: Colors.white)),
                Text(
                  "HEERA COLLEGE OF ENGINEERING AND TECHNOLOGY",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
