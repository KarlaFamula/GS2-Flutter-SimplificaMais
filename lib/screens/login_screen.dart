import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/area_conteudo.dart';
import '../components/cabecalho_ilustrado.dart';
import '../components/card_endereco.dart';
import '../components/mensagem_erro.dart';
import '../models/endereco.dart';
import '../models/estado_requisicao.dart';
import '../services/preferencias_service.dart';
import '../services/viacep_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _cepController = TextEditingController();
  final ViaCepService _viaCepService = ViaCepService();
  final PreferenciasService _preferencias = PreferenciasService();

  EstadoRequisicao _estado = EstadoRequisicao.inicial;
  Endereco? _endereco;
  String _mensagemErro = '';

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  Future<void> _buscarCep() async {
    FocusScope.of(context).unfocus();
    setState(() => _estado = EstadoRequisicao.carregando);

    try {
      final endereco = await _viaCepService.buscarEndereco(_cepController.text);
      if (!mounted) return;
      setState(() {
        _endereco = endereco;
        _estado = EstadoRequisicao.sucesso;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = e.toString().replaceFirst('Exception: ', '');
        _estado = EstadoRequisicao.erro;
      });
    }
  }

  Future<void> _entrar() async {
    final endereco = _endereco;
    if (endereco == null) return;
    await _preferencias.salvarEndereco(endereco);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (rota) => false);
  }

  /// Se veio do Perfil, volta para ele. Se é o primeiro acesso, volta para a introdução.
  void _voltar() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final carregando = _estado == EstadoRequisicao.carregando;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Endereço'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: _voltar,
        ),
      ),
      body: AreaConteudo(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CabecalhoIlustrado(
              imagem: 'assets/images/endereco.png',
              titulo: 'Para começar, onde você mora?',
              subtitulo: 'Com o CEP, a gente preenche o resto para você.',
              alturaImagem: 170,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              onSubmitted: (_) => _buscarCep(),
              decoration: const InputDecoration(
                labelText: 'Digite seu CEP',
                hintText: 'Ex.: 01311000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: carregando ? null : _buscarCep,
              icon: const Icon(Icons.search, size: 28),
              label: const Text('Buscar', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
            const SizedBox(height: 24),
            _construirConteudo(),
          ],
        ),
      ),
      ),
    );
  }

  Widget _construirConteudo() {
    return switch (_estado) {
      EstadoRequisicao.inicial => _construirInicial(),
      EstadoRequisicao.carregando => _construirCarregando(),
      EstadoRequisicao.erro => MensagemErro(
          mensagem: _mensagemErro,
          onTentarNovamente: _buscarCep,
        ),
      EstadoRequisicao.sucesso => _construirSucesso(),
    };
  }

  Widget _construirInicial() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 40),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Digite os 8 números do seu CEP e toque em Buscar.',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirCarregando() {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Buscando seu endereço...', style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _construirSucesso() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardEndereco(endereco: _endereco!),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _entrar,
          icon: const Icon(Icons.check, size: 28, color: Colors.white),
          label: const Text(
            'Tudo certo, entrar!',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            padding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }
}
