import 'package:flutter/material.dart';
import '../models/pagina_onboarding.dart';

class ConteudoOnboarding extends StatelessWidget {
  final PaginaOnboarding pagina;

  const ConteudoOnboarding({super.key, required this.pagina});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          Image.asset(pagina.imagem, height: 280, semanticLabel: pagina.titulo),
          const SizedBox(height: 32),
          Text(
            pagina.titulo,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006C4C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            pagina.descricao,
            style: const TextStyle(fontSize: 24, color: Color(0xFF37474F)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
