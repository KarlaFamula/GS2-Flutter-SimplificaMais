import 'package:flutter/material.dart';

/// Ilustração + título + subtítulo, usado no topo de várias telas.
class CabecalhoIlustrado extends StatelessWidget {
  final String imagem;
  final String titulo;
  final String? subtitulo;
  final double alturaImagem;

  const CabecalhoIlustrado({
    super.key,
    required this.imagem,
    required this.titulo,
    this.subtitulo,
    this.alturaImagem = 180,
  });

  @override
  Widget build(BuildContext context) {
    final textoSubtitulo = subtitulo;

    return Column(
      children: [
        Image.asset(imagem, height: alturaImagem, excludeFromSemantics: true),
        const SizedBox(height: 12),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006C4C),
          ),
          textAlign: TextAlign.center,
        ),
        if (textoSubtitulo != null) ...[
          const SizedBox(height: 6),
          Text(
            textoSubtitulo,
            style: const TextStyle(fontSize: 20, color: Color(0xFF546E7A)),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
