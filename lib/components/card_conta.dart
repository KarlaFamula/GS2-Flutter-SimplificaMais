import 'package:flutter/material.dart';
import '../models/conta.dart';
import '../strategy/conta_strategy.dart';
import '../utils/formatadores.dart';
import 'selo_status.dart';

class CardConta extends StatelessWidget {
  final Conta conta;
  final VoidCallback onTap;

  const CardConta({super.key, required this.conta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final strategy = ContaStrategyFactory.porTipo(conta.tipo);
    final valorTotal = formatarMoeda(strategy.calcularTotal(conta.valor));
    final data = conta.estaPaga
        ? 'Paga em ${formatarData(conta.dataPagamento ?? conta.vencimento)}'
        : 'Vence em ${formatarData(conta.vencimento)}';

    return Semantics(
      button: true,
      label: '${conta.descricao}, $valorTotal, $data. Toque para ver detalhes.',
      excludeSemantics: true,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(strategy.imagem, width: 64, height: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conta.descricao,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data,
                        style: const TextStyle(fontSize: 18, color: Color(0xFF546E7A)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        valorTotal,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006C4C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SeloStatus(status: conta.status),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, size: 32, color: Color(0xFF006C4C)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
