import 'package:flutter/material.dart';
import 'package:inacap_login_app/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores institucionales INACAP
    const Color colorPrincipal = Color(0xFFB71C1C);
    const Color colorFondo = Color(0xFFF5F5F5);

    return MaterialApp(
      title: 'INACAP Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorPrincipal,
        scaffoldBackgroundColor: colorFondo,
        useMaterial3: true,

        // AppBar coherente
        appBarTheme: const AppBarTheme(
          backgroundColor: colorPrincipal,
          foregroundColor: Colors.white,
          elevation: 3,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrincipal,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 3,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Campos de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black87),
          prefixIconColor: colorPrincipal,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorPrincipal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorPrincipal, width: 2),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
