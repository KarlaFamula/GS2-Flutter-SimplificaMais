import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferenciasService _preferencias = PreferenciasService();

  @override
  void initState() {
    super.initState();
    _decidirProximaTela();
  }

  Future<void> _decidirProximaTela() async {
    await Future.delayed(const Duration(seconds: 2));
    final mostrarOnboarding = await _preferencias.deveMostrarOnboarding();
    final endereco = await _preferencias.carregarEndereco();

    if (!mounted) return;

    if (mostrarOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (endereco == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E9C6E), Color(0xFF004D36)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                boxShadow: const [
                  BoxShadow(color: Color(0x55000000), blurRadius: 24, offset: Offset(0, 10)),
                ],
              ),
              child: Image.asset('assets/images/logo.png', width: 170, height: 170),
            ),
            const SizedBox(height: 24),
            const Text(
              'Simplifica+',
              style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pagar contas ficou simples',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
