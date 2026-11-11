import 'package:flutter/material.dart';
import '../models/conta.dart';

/// Selo com ícone + texto (não depende só da cor, pensando em daltônicos).
class SeloStatus extends StatelessWidget {
  final StatusConta status;

  const SeloStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final paga = status == StatusConta.paga;
    final cor = paga ? Colors.green.shade800 : Colors.orange.shade900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: paga ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(paga ? Icons.check_circle : Icons.schedule, color: cor, size: 22),
          const SizedBox(width: 6),
          Text(
            paga ? 'Paga' : 'Pendente',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cor),
          ),
        ],
      ),
    );
  }
}
