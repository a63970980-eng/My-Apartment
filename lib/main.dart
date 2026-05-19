import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_apart/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'منصة الخدمات الحكومية',

      theme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        primaryColor: const Color(0xFF0B1F3A),

        scaffoldBackgroundColor: const Color(0xFF081420),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC9A84C),
          secondary: Color(0xFF1A7A8A),
        ),

        textTheme: GoogleFonts.cairoTextTheme(),
      ),

      home: const SplashScreen(),
    );
  }
}