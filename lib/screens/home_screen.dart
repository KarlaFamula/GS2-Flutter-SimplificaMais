import 'package:flutter/material.dart';
import '../components/area_conteudo.dart';
import '../components/botao_gigante.dart';
import '../components/card_conta.dart';
import '../components/filtro_contas.dart';
import '../data/conta_repository.dart';
import '../models/conta.dart';
import '../models/filtro_conta.dart';
import '../services/preferencias_service.dart';
import '../utils/formatadores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContaRepository _repositorio = ContaRepository.instancia;
  final PreferenciasService _preferencias = PreferenciasService();
  FiltroConta _filtro = FiltroConta.todas;
  String? _cidade;

  @override
  void initState() {
    super.initState();
    _carregarCidade();
  }

  Future<void> _carregarCidade() async {
    final endereco = await _preferencias.carregarEndereco();
    if (!mounted || endereco == null) return;
    setState(() => _cidade = '${endereco.localidade} - ${endereco.uf}');
  }

  Future<void> _abrirDetalhes(Conta conta) async {
    await Navigator.pushNamed(context, '/detalhes', arguments: conta);
    if (!mounted) return;
    setState(() {}); // atualiza a lista caso a conta tenha sido paga
  }

  Future<void> _abrirScanner() async {
    await Navigator.pushNamed(context, '/scanner');
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final contas = _repositorio.listar(_filtro);

    return Scaffold(
        appBar: AppBar(title: const Text('Simplifica+')),
        body: AreaConteudo(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _construirSaudacao(),
              const SizedBox(height: 16),
              BotaoGigante(
                texto: 'PAGAR CONTA',
                imagem: 'assets/images/botao_pagar.png',
                onPressed: _abrirScanner,
              ),
              const SizedBox(height: 16),
              _construirResumo(),
              const SizedBox(height: 24),
              const Text(
                'Minhas Contas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              FiltroContas(
                selecionado: _filtro,
                onSelecionar: (filtro) => setState(() => _filtro = filtro),
              ),
              const SizedBox(height: 16),
              if (contas.isEmpty)
                _construirListaVazia()
              else
                ...contas.map(
                  (conta) => CardConta(conta: conta, onTap: () => _abrirDetalhes(conta)),
                ),
            ],
          ),
        ),
    );
  }

  Widget _construirSaudacao() {
    final cidade = _cidade;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F4EC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Olá! 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D36),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Que bom ter você aqui.',
                  style: TextStyle(fontSize: 20, color: Color(0xFF37474F)),
                ),
                if (cidade != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 22, color: Color(0xFF006C4C)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cidade,
                          style: const TextStyle(fontSize: 18, color: Color(0xFF006C4C)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset('assets/images/perfil.png', width: 88, height: 88, excludeFromSemantics: true),
        ],
      ),
    );
  }

  Widget _construirResumo() {
    final quantidade = _repositorio.quantidadePendentes();
    final tudoPago = quantidade == 0;

    return Card(
      color: tudoPago ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              tudoPago ? 'assets/images/sucesso.png' : 'assets/images/alerta.png',
              width: 64,
              height: 64,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: tudoPago
                  ? const Text(
                      'Parabéns! Todas as contas estão pagas.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quantidade == 1
                              ? '1 conta para pagar'
                              : '$quantidade contas para pagar',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Total: ${formatarMoeda(_repositorio.totalPendente())}',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirListaVazia() {
    final mensagem = _filtro == FiltroConta.pagas
        ? 'Você ainda não pagou nenhuma conta.'
        : 'Nenhuma conta para pagar. Tudo em dia!';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset('assets/images/sucesso.png', height: 150, excludeFromSemantics: true),
          const SizedBox(height: 12),
          Text(mensagem, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
