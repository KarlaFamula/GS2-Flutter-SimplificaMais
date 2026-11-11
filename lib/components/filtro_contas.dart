import 'package:flutter/material.dart';
import '../models/filtro_conta.dart';

class FiltroContas extends StatelessWidget {
  final FiltroConta selecionado;
  final ValueChanged<FiltroConta> onSelecionar;

  const FiltroContas({
    super.key,
    required this.selecionado,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: FiltroConta.values.map((filtro) {
        final ativo = filtro == selecionado;
        return ChoiceChip(
          label: Text(
            filtro.rotulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: ativo ? FontWeight.bold : FontWeight.normal,
              color: ativo ? Colors.white : const Color(0xFF006C4C),
            ),
          ),
          selected: ativo,
          selectedColor: const Color(0xFF006C4C),
          backgroundColor: Colors.white,
          checkmarkColor: Colors.white,
          side: const BorderSide(color: Color(0xFF006C4C), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          onSelected: (_) => onSelecionar(filtro),
        );
      }).toList(),
    );
  }
}
