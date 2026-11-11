import 'package:flutter_test/flutter_test.dart';
import 'package:simplifica_mais_universal/utils/formatadores.dart';

void main() {
  test('formata moeda no padrão brasileiro', () {
    expect(formatarMoeda(0), 'R\$ 0,00');
    expect(formatarMoeda(12.5), 'R\$ 12,50');
    expect(formatarMoeda(1234.56), 'R\$ 1.234,56');
    expect(formatarMoeda(1000000), 'R\$ 1.000.000,00');
  });

  test('formata data como dd/mm/aaaa', () {
    expect(formatarData(DateTime(2026, 11, 5)), '05/11/2026');
  });
}
