import 'package:flutter/material.dart';

/// Limita a largura do conteúdo para o app não ficar esticado
/// em telas grandes (tablet, navegador e Windows).
class AreaConteudo extends StatelessWidget {
  final Widget child;
  final double larguraMaxima;

  const AreaConteudo({super.key, required this.child, this.larguraMaxima = 640});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: larguraMaxima),
        child: child,
      ),
    );
  }
}
