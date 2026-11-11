import 'package:flutter/material.dart';
import '../components/botao_voltar.dart';
import '../data/conta_repository.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  final ContaRepository _repositorio = ContaRepository.instancia;
  late final AnimationController _animacao;
  bool _lendo = true;

  @override
  void initState() {
    super.initState();
    _animacao = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _simularLeitura();
  }

  @override
  void dispose() {
    _animacao.dispose();
    super.dispose();
  }

  /// Simula a leitura do código de barras pela câmera.
  Future<void> _simularLeitura() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final conta = _repositorio.proximaPendente();
    if (conta == null) {
      _animacao.stop();
      setState(() => _lendo = false);
      return;
    }

    final resultado = await Navigator.pushNamed(context, '/detalhes', arguments: conta);
    if (!mounted) return;
    Navigator.pop(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aponte a Câmera'),
        backgroundColor: const Color(0xFF0B1F18),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1F18), Color(0xFF000000)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _lendo ? _construirLeitura() : _construirSemContas(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirLeitura() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF4ADE80), width: 4),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            width: 300,
            height: 160,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/boleto_scanner.png',
                  width: 300,
                  height: 160,
                  semanticLabel: 'Boleto sendo lido',
                ),
                AnimatedBuilder(
                  animation: _animacao,
                  builder: (context, child) => Positioned(
                    top: 8 + _animacao.value * 140,
                    left: 0,
                    right: 0,
                    child: child!,
                  ),
                  child: Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      boxShadow: [BoxShadow(color: Color(0xAAFF3B30), blurRadius: 12)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(color: Color(0xFF4ADE80)),
        const SizedBox(height: 16),
        const Text(
          'Lendo código...',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        const SizedBox(height: 8),
        const Text(
          'Segure o celular parado em cima do código de barras.',
          style: TextStyle(color: Colors.white70, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Theme(
          data: ThemeData.dark(),
          child: const BotaoVoltar(texto: 'Cancelar'),
        ),
      ],
    );
  }

  Widget _construirSemContas() {
    return Column(
      children: [
        Image.asset('assets/images/sucesso.png', height: 180, excludeFromSemantics: true),
        const SizedBox(height: 16),
        const Text(
          'Você não tem contas para pagar!',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Theme(
          data: ThemeData.dark(),
          child: const BotaoVoltar(),
        ),
      ],
    );
  }
}
