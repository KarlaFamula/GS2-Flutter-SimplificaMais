import 'package:flutter_test/flutter_test.dart';
import 'package:simplifica_mais_universal/models/conta.dart';
import 'package:simplifica_mais_universal/strategy/conta_strategy.dart';

void main() {
  group('ContaAguaStrategy', () {
    test('não cobra taxa', () {
      const strategy = ContaAguaStrategy();
      expect(strategy.calcularTaxa(100), 0);
      expect(strategy.calcularTotal(100), 100);
    });
  });

  group('ContaLuzStrategy', () {
    test('cobra 5% de taxa', () {
      const strategy = ContaLuzStrategy();
      expect(strategy.calcularTaxa(200), closeTo(10, 0.001));
      expect(strategy.calcularTotal(200), closeTo(210, 0.001));
    });
  });

  group('BoletoBancarioStrategy', () {
    test('cobra tarifa fixa de R\$ 2,50', () {
      const strategy = BoletoBancarioStrategy();
      expect(strategy.calcularTaxa(10), 2.50);
      expect(strategy.calcularTotal(10), closeTo(12.50, 0.001));
      expect(strategy.calcularTotal(1000), closeTo(1002.50, 0.001));
    });
  });

  group('ContaStrategyFactory', () {
    test('devolve a strategy certa para cada tipo', () {
      expect(ContaStrategyFactory.porTipo(TipoConta.agua), isA<ContaAguaStrategy>());
      expect(ContaStrategyFactory.porTipo(TipoConta.luz), isA<ContaLuzStrategy>());
      expect(ContaStrategyFactory.porTipo(TipoConta.boleto), isA<BoletoBancarioStrategy>());
    });
  });
}
