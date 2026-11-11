import 'package:flutter/material.dart';
import '../components/area_conteudo.dart';
import '../components/conteudo_onboarding.dart';
import '../models/pagina_onboarding.dart';
import '../services/preferencias_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final PreferenciasService _preferencias = PreferenciasService();
  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  static const List<PaginaOnboarding> _paginas = [
    PaginaOnboarding(
      imagem: 'assets/images/onboarding_1.png',
      titulo: 'Bem-vindo ao Simplifica+',
      descricao: 'Tudo grande, claro e feito para todos.',
    ),
    PaginaOnboarding(
      imagem: 'assets/images/onboarding_2.png',
      titulo: 'Sem Complicação',
      descricao: 'Sem menus confusos. Aponte a câmera e pague.',
    ),
    PaginaOnboarding(
      imagem: 'assets/images/onboarding_3.png',
      titulo: 'Apoio quando precisar',
      descricao: 'Veja suas contas pagas e encontre ajuda com um toque.',
    ),
  ];

  bool get _ultimaPagina => _paginaAtual == _paginas.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _avancar() {
    if (_ultimaPagina) {
      _concluir();
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _voltar() {
    if (_paginaAtual == 0) {
      Navigator.pop(context); // só acontece quando a introdução foi aberta pelo Perfil
    } else {
      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future<void> _concluir() async {
    await _preferencias.salvarPreferenciaOnboarding(_naoMostrarNovamente);
    final endereco = await _preferencias.carregarEndereco();
    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacementNamed(context, endereco == null ? '/login' : '/home');
  }

  @override
  Widget build(BuildContext context) {
    final podeVoltar = _paginaAtual > 0 || Navigator.canPop(context);

    return Scaffold(
      body: SafeArea(
        child: AreaConteudo(
          child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _concluir,
                child: const Text('Pular', style: TextStyle(fontSize: 20)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _paginas.length,
                onPageChanged: (index) => setState(() => _paginaAtual = index),
                itemBuilder: (context, index) => ConteudoOnboarding(pagina: _paginas[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_paginas.length, (index) {
                final ativo = index == _paginaAtual;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: ativo ? 28 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ativo ? const Color(0xFF006C4C) : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _naoMostrarNovamente,
              onChanged: (valor) => setState(() => _naoMostrarNovamente = valor ?? false),
              title: const Text('Não mostrar novamente', style: TextStyle(fontSize: 20)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: podeVoltar ? _voltar : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar', style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton.icon(
                    onPressed: _avancar,
                    icon: Icon(_ultimaPagina ? Icons.check : Icons.arrow_forward),
                    label: Text(
                      _ultimaPagina ? 'Começar' : 'Avançar',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
