import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ajuda_screen.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';

/// Tela principal com a barra de abas: Início, Ajuda e Perfil.
/// As três abas ficam sempre visíveis embaixo.
class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _abaAtual = 0;

  void _irParaInicio() => setState(() => _abaAtual = 0);

  /// Botão voltar do celular: em Ajuda/Perfil volta para o Início;
  /// no Início pergunta se a pessoa quer sair do app.
  Future<void> _tratarVoltar() async {
    if (_abaAtual != 0) {
      _irParaInicio();
      return;
    }

    final sair = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair do Simplifica+?', style: TextStyle(fontSize: 24)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Ficar', style: TextStyle(fontSize: 20)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (sair == true) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _tratarVoltar();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _abaAtual,
          children: [
            const HomeScreen(),
            AjudaScreen(onVoltarInicio: _irParaInicio),
            PerfilScreen(onVoltarInicio: _irParaInicio),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _abaAtual,
          onDestinationSelected: (indice) => setState(() => _abaAtual = indice),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.help_outline),
              selectedIcon: Icon(Icons.help),
              label: 'Ajuda',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
