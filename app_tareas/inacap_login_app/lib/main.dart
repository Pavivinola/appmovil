import 'package:flutter/material.dart';
import 'package:inacap_login_app/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const rojoInacap = Color(0xFFB71C1C);

    return MaterialApp(
      title: 'Evaluación Flutter INACAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: rojoInacap,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: rojoInacap),
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          backgroundColor: rojoInacap,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: rojoInacap,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
