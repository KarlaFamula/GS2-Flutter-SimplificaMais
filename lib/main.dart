import 'package:flutter/material.dart';
import 'models/conta.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/principal_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/detalhes_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/ajuda_screen.dart';

void main() {
  runApp(const SimplificaApp());
}

class SimplificaApp extends StatelessWidget {
  const SimplificaApp({super.key});

  static const Color verde = Color(0xFF006C4C);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplifica+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: verde, primary: verde),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4FAF7),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: verde,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(size: 32, color: Colors.white),
          actionsIconTheme: IconThemeData(size: 32, color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFDCEBE3)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: verde,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: verde,
            side: const BorderSide(color: verde, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 84,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFCDEBDC),
          labelTextStyle: WidgetStateProperty.resolveWith((estados) {
            final selecionada = estados.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 18,
              fontWeight: selecionada ? FontWeight.bold : FontWeight.w500,
              color: selecionada ? verde : const Color(0xFF455A64),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((estados) {
            final selecionada = estados.contains(WidgetState.selected);
            return IconThemeData(
              size: 32,
              color: selecionada ? verde : const Color(0xFF455A64),
            );
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const PrincipalScreen(),
        '/scanner': (context) => const ScannerScreen(),
        '/detalhes': (context) => DetalhesScreen(
              conta: ModalRoute.of(context)!.settings.arguments as Conta,
            ),
        '/perfil': (context) => const PerfilScreen(),
        '/ajuda': (context) => const AjudaScreen(),
      },
    );
  }
}
