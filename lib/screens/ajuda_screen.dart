import 'package:flutter/material.dart';
import '../components/area_conteudo.dart';
import '../components/botao_voltar.dart';
import '../components/cabecalho_ilustrado.dart';
import '../models/item_ajuda.dart';

class AjudaScreen extends StatelessWidget {
  /// Quando a Ajuda está na barra de abas, o botão volta para o Início.
  final VoidCallback? onVoltarInicio;

  const AjudaScreen({super.key, this.onVoltarInicio});

  static const List<ItemAjuda> _itens = [
    ItemAjuda(
      icone: Icons.qr_code_scanner,
      pergunta: 'Como pago uma conta?',
      resposta: 'Na tela inicial, toque no botão verde "PAGAR CONTA" e aponte a '
          'câmera para o código de barras. Depois confira o valor e toque em '
          '"CONFIRMAR PAGAMENTO".',
    ),
    ItemAjuda(
      icone: Icons.receipt_long,
      pergunta: 'Onde vejo as contas que já paguei?',
      resposta: 'Na tela inicial, toque no filtro "Pagas". Toque em qualquer '
          'conta para ver os detalhes.',
    ),
    ItemAjuda(
      icone: Icons.percent,
      pergunta: 'Por que o valor tem taxa?',
      resposta: 'Cada tipo de conta tem uma regra: água não tem taxa, luz tem '
          '5% de serviço e boleto tem tarifa fixa de R\$ 2,50. Tudo aparece '
          'separado antes de você confirmar.',
    ),
    ItemAjuda(
      icone: Icons.home,
      pergunta: 'Como mudo meu endereço?',
      resposta: 'Toque no ícone de pessoa no topo da tela inicial e depois em '
          '"Alterar endereço".',
    ),
    ItemAjuda(
      icone: Icons.family_restroom,
      pergunta: 'Ainda estou com dúvida. E agora?',
      resposta: 'Peça ajuda a um familiar ou a alguém de confiança. Nunca passe '
          'suas senhas para desconhecidos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: AreaConteudo(
        child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _itens.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CabecalhoIlustrado(
                imagem: 'assets/images/ajuda.png',
                titulo: 'Como podemos ajudar?',
                subtitulo: 'Toque numa pergunta para ver a resposta.',
              ),
            );
          }
          if (index == _itens.length + 1) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: BotaoVoltar(
                texto: onVoltarInicio == null ? 'Voltar' : 'Voltar ao início',
                onPressed: onVoltarInicio,
              ),
            );
          }
          final item = _itens[index - 1];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(item.icone, size: 36, color: const Color(0xFF006C4C)),
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                item.pergunta,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(item.resposta, style: const TextStyle(fontSize: 20)),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}
