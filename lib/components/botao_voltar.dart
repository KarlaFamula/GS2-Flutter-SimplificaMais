import 'package:flutter/material.dart';

/// Botão grande e escrito "Voltar", mais fácil de achar do que só a seta.
class BotaoVoltar extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;

  const BotaoVoltar({super.key, this.texto = 'Voltar', this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: OutlinedButton.icon(
        onPressed: onPressed ?? () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back, size: 28),
        label: Text(texto, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
