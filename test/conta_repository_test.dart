import 'package:flutter_test/flutter_test.dart';
import 'package:simplifica_mais_universal/data/conta_repository.dart';
import 'package:simplifica_mais_universal/models/conta.dart';
import 'package:simplifica_mais_universal/models/filtro_conta.dart';

void main() {
  late ContaRepository repositorio;

  setUp(() {
    // Arrange: cada teste começa com uma lista nova
    repositorio = ContaRepository();
  });

  test('filtra contas pendentes e pagas', () {
    final todas = repositorio.listar();
    final pendentes = repositorio.listar(FiltroConta.pendentes);
    final pagas = repositorio.listar(FiltroConta.pagas);

    expect(pendentes.every((conta) => !conta.estaPaga), isTrue);
    expect(pagas.every((conta) => conta.estaPaga), isTrue);
    expect(pendentes.length + pagas.length, todas.length);
  });

  test('pagar muda o status da conta para paga', () {
    final conta = repositorio.proximaPendente()!;

    final contaPaga = repositorio.pagar(conta.id);

    expect(contaPaga.status, StatusConta.paga);
    expect(contaPaga.dataPagamento, isNotNull);
    expect(repositorio.listar(FiltroConta.pagas).any((c) => c.id == conta.id), isTrue);
  });

  test('não deixa pagar a mesma conta duas vezes', () {
    final conta = repositorio.proximaPendente()!;
    repositorio.pagar(conta.id);

    expect(() => repositorio.pagar(conta.id), throwsStateError);
  });

  test('total pendente diminui depois de pagar', () {
    final totalAntes = repositorio.totalPendente();
    final conta = repositorio.proximaPendente()!;

    repositorio.pagar(conta.id);

    expect(repositorio.totalPendente(), lessThan(totalAntes));
  });

  test('sem contas pendentes, proximaPendente devolve null', () {
    for (final conta in repositorio.listar(FiltroConta.pendentes)) {
      repositorio.pagar(conta.id);
    }

    expect(repositorio.proximaPendente(), isNull);
    expect(repositorio.totalPendente(), 0);
  });
}
