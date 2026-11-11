import 'package:flutter/material.dart';

class BotaoGigante extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final String? imagem;
  final VoidCallback onPressed;
  final Color cor;

  const BotaoGigante({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icone,
    this.imagem,
    this.cor = const Color(0xFF006C4C),
  });

  @override
  Widget build(BuildContext context) {
    final caminhoImagem = imagem;

    return SizedBox(
      width: double.infinity,
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: cor.withAlpha(120),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (caminhoImagem != null)
              Image.asset(caminhoImagem, width: 64, height: 64)
            else
              Icon(icone ?? Icons.touch_app, size: 60),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
