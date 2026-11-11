import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplifica_mais_universal/components/card_conta.dart';
import 'package:simplifica_mais_universal/main.dart';
import 'package:simplifica_mais_universal/models/conta.dart';

void main() {
  testWidgets('Splash mostra o nome e depois abre o onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SimplificaApp());
    expect(find.text('Simplifica+'), findsOneWidget);

    // Avança o tempo do Splash e da animação de troca de tela.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(find.text('Bem-vindo ao Simplifica+'), findsOneWidget);
    expect(find.text('Não mostrar novamente'), findsOneWidget);
  });

  testWidgets('Tocar no CardConta chama o onTap', (tester) async {
    var tocou = false;
    final conta = Conta(
      id: '1',
      descricao: 'Luz de Teste',
      empresa: 'Empresa',
      tipo: TipoConta.luz,
      valor: 100,
      vencimento: DateTime(2026, 11, 15),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardConta(conta: conta, onTap: () => tocou = true),
        ),
      ),
    );

    expect(find.text('Luz de Teste'), findsOneWidget);
    expect(find.text('R\$ 105,00'), findsOneWidget);

    await tester.tap(find.byType(CardConta));
    expect(tocou, isTrue);
  });
}
