import 'package:flutter/material.dart';
import '../components/area_conteudo.dart';
import '../components/linha_valor.dart';
import '../components/selo_status.dart';
import '../data/conta_repository.dart';
import '../models/conta.dart';
import '../strategy/conta_strategy.dart';
import '../utils/formatadores.dart';

class DetalhesScreen extends StatefulWidget {
  final Conta conta;

  const DetalhesScreen({super.key, required this.conta});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  Conta get conta => widget.conta;

  Future<void> _confirmarPagamento(double valorTotal) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar pagamento?', style: TextStyle(fontSize: 24)),
        content: Text(
          'Você vai pagar ${formatarMoeda(valorTotal)}.',
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Não', style: TextStyle(fontSize: 20)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sim, pagar'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;
    if (!mounted) return;

    ContaRepository.instancia.pagar(conta.id);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/sucesso.png', height: 160, excludeFromSemantics: true),
            const SizedBox(height: 12),
            const Text(
              'Pagamento realizado!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${conta.descricao} foi paga.',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK, entendi'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final strategy = ContaStrategyFactory.porTipo(conta.tipo);
    final taxa = strategy.calcularTaxa(conta.valor);
    final valorTotal = strategy.calcularTotal(conta.valor);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Conta')),
      body: AreaConteudo(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset(strategy.imagem, height: 110, semanticLabel: strategy.titulo),
                      const SizedBox(height: 16),
                      Text(
                        strategy.titulo,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${conta.descricao} • ${conta.empresa}',
                        style: const TextStyle(fontSize: 20, color: Color(0xFF546E7A)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      SeloStatus(status: conta.status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFFE3F4EC),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      LinhaValor(rotulo: 'Valor da conta', valor: formatarMoeda(conta.valor)),
                      LinhaValor(rotulo: strategy.descricaoTaxa, valor: formatarMoeda(taxa)),
                      const Divider(thickness: 2),
                      LinhaValor(
                        rotulo: conta.estaPaga ? 'Valor pago' : 'Valor a pagar',
                        valor: formatarMoeda(valorTotal),
                        destaque: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.event, size: 32, color: Color(0xFF006C4C)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      conta.estaPaga
                          ? 'Paga em ${formatarData(conta.dataPagamento ?? conta.vencimento)}'
                          : 'Vence em ${formatarData(conta.vencimento)}',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (!conta.estaPaga) ...[
                SizedBox(
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _confirmarPagamento(valorTotal),
                    child: const Text(
                      'CONFIRMAR PAGAMENTO',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                height: 72,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    conta.estaPaga ? 'VOLTAR' : 'CANCELAR',
                    style: TextStyle(
                      fontSize: 24,
                      color: conta.estaPaga ? null : Colors.red.shade800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
