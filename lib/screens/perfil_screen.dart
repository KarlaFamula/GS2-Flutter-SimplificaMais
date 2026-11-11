import 'package:flutter/material.dart';
import '../components/area_conteudo.dart';
import '../components/botao_voltar.dart';
import '../components/cabecalho_ilustrado.dart';
import '../components/card_endereco.dart';
import '../models/endereco.dart';
import '../services/preferencias_service.dart';

class PerfilScreen extends StatefulWidget {
  /// Quando o Perfil está na barra de abas, o botão volta para o Início.
  final VoidCallback? onVoltarInicio;

  const PerfilScreen({super.key, this.onVoltarInicio});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final PreferenciasService _preferencias = PreferenciasService();
  Endereco? _endereco;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final endereco = await _preferencias.carregarEndereco();
    if (!mounted) return;
    setState(() {
      _endereco = endereco;
      _carregando = false;
    });
  }

  void _alterarEndereco() {
    Navigator.pushNamed(context, '/login');
  }

  void _verIntroducao() {
    Navigator.pushNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : AreaConteudo(
              child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const CabecalhoIlustrado(
                  imagem: 'assets/images/perfil.png',
                  titulo: 'Seus dados',
                  alturaImagem: 140,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Meu endereço',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (_endereco != null)
                  CardEndereco(endereco: _endereco!)
                else
                  const Text('Nenhum endereço salvo.', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: _alterarEndereco,
                  icon: const Icon(Icons.edit_location_alt, size: 28),
                  label: const Text('Alterar endereço', style: TextStyle(fontSize: 20)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _verIntroducao,
                  icon: const Icon(Icons.replay, size: 28),
                  label: const Text('Ver a introdução de novo', style: TextStyle(fontSize: 20)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
                const SizedBox(height: 32),
                BotaoVoltar(
                  texto: widget.onVoltarInicio == null ? 'Voltar' : 'Voltar ao início',
                  onPressed: widget.onVoltarInicio,
                ),
              ],
            ),
            ),
    );
  }
}
