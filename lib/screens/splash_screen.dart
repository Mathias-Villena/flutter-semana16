import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    // Fade in suave
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _opacity = 1);
    });

    // Redirige después de 3 segundos
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: _opacity,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade700,
                Colors.blue.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),

              const Text(
                "Bienvenido a",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),

              const Text(
                "BookVerse 📚",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
