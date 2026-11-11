import 'package:flutter/material.dart';

class LinhaValor extends StatelessWidget {
  final String rotulo;
  final String valor;
  final bool destaque;

  const LinhaValor({
    super.key,
    required this.rotulo,
    required this.valor,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    final tamanho = destaque ? 26.0 : 20.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              rotulo,
              style: TextStyle(
                fontSize: tamanho,
                fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(valor, style: TextStyle(fontSize: tamanho, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
