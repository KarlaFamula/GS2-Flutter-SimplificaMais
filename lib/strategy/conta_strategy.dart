import '../models/conta.dart';

/// Strategy Pattern: cada tipo de conta tem sua própria regra de taxa,
/// título e imagem, sem precisar de if/else espalhados pelas telas.
abstract class TipoContaStrategy {
  const TipoContaStrategy();

  String get titulo;
  String get imagem;
  String get descricaoTaxa;

  double calcularTaxa(double valorBase);

  double calcularTotal(double valorBase) {
    return valorBase + calcularTaxa(valorBase);
  }
}

class ContaAguaStrategy extends TipoContaStrategy {
  const ContaAguaStrategy();

  @override
  String get titulo => 'Conta de Água';

  @override
  String get imagem => 'assets/images/agua.png';

  @override
  String get descricaoTaxa => 'Sem taxa de serviço';

  @override
  double calcularTaxa(double valorBase) => 0;
}

class ContaLuzStrategy extends TipoContaStrategy {
  const ContaLuzStrategy();

  @override
  String get titulo => 'Conta de Luz';

  @override
  String get imagem => 'assets/images/luz.png';

  @override
  String get descricaoTaxa => 'Taxa de serviço (5%)';

  @override
  double calcularTaxa(double valorBase) => valorBase * 0.05;
}

class BoletoBancarioStrategy extends TipoContaStrategy {
  const BoletoBancarioStrategy();

  @override
  String get titulo => 'Boleto Bancário';

  @override
  String get imagem => 'assets/images/boleto.png';

  @override
  String get descricaoTaxa => 'Tarifa fixa do boleto';

  @override
  double calcularTaxa(double valorBase) => 2.50;
}

/// Devolve a strategy correta para cada tipo de conta.
class ContaStrategyFactory {
  static TipoContaStrategy porTipo(TipoConta tipo) {
    return switch (tipo) {
      TipoConta.agua => const ContaAguaStrategy(),
      TipoConta.luz => const ContaLuzStrategy(),
      TipoConta.boleto => const BoletoBancarioStrategy(),
    };
  }
}
