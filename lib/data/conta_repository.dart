import '../models/conta.dart';
import '../models/filtro_conta.dart';
import '../strategy/conta_strategy.dart';

/// Guarda as contas do usuário e concentra as regras de negócio
/// (filtrar, pagar, somar), mantendo as telas livres dessa lógica.
class ContaRepository {
  ContaRepository() : _contas = List.of(_contasIniciais);

  /// Instância compartilhada pelas telas do app.
  static final ContaRepository instancia = ContaRepository();

  final List<Conta> _contas;

  static final List<Conta> _contasIniciais = [
    Conta(
      id: '1',
      descricao: 'Luz de Novembro',
      empresa: 'Companhia de Energia',
      tipo: TipoConta.luz,
      valor: 150.80,
      vencimento: DateTime(2026, 11, 15),
    ),
    Conta(
      id: '2',
      descricao: 'Água de Novembro',
      empresa: 'Companhia de Saneamento',
      tipo: TipoConta.agua,
      valor: 89.40,
      vencimento: DateTime(2026, 11, 20),
    ),
    Conta(
      id: '3',
      descricao: 'Internet',
      empresa: 'Provedor de Internet',
      tipo: TipoConta.boleto,
      valor: 99.90,
      vencimento: DateTime(2026, 11, 25),
    ),
    Conta(
      id: '4',
      descricao: 'Luz de Outubro',
      empresa: 'Companhia de Energia',
      tipo: TipoConta.luz,
      valor: 142.30,
      vencimento: DateTime(2026, 10, 15),
      status: StatusConta.paga,
      dataPagamento: DateTime(2026, 10, 10),
    ),
    Conta(
      id: '5',
      descricao: 'Água de Outubro',
      empresa: 'Companhia de Saneamento',
      tipo: TipoConta.agua,
      valor: 85.10,
      vencimento: DateTime(2026, 10, 20),
      status: StatusConta.paga,
      dataPagamento: DateTime(2026, 10, 5),
    ),
  ];

  List<Conta> listar([FiltroConta filtro = FiltroConta.todas]) {
    final lista = switch (filtro) {
      FiltroConta.todas => List.of(_contas),
      FiltroConta.pendentes => _contas.where((conta) => !conta.estaPaga).toList(),
      FiltroConta.pagas => _contas.where((conta) => conta.estaPaga).toList(),
    };
    lista.sort((a, b) => a.vencimento.compareTo(b.vencimento));
    return lista;
  }

  /// Simula a leitura do código de barras: devolve a próxima conta a vencer.
  Conta? proximaPendente() {
    final pendentes = listar(FiltroConta.pendentes);
    return pendentes.isEmpty ? null : pendentes.first;
  }

  int quantidadePendentes() => listar(FiltroConta.pendentes).length;

  double totalPendente() {
    return listar(FiltroConta.pendentes).fold<double>(
      0,
      (soma, conta) =>
          soma + ContaStrategyFactory.porTipo(conta.tipo).calcularTotal(conta.valor),
    );
  }

  Conta pagar(String id) {
    final indice = _contas.indexWhere((conta) => conta.id == id);
    if (indice == -1) {
      throw ArgumentError('Conta não encontrada: $id');
    }
    if (_contas[indice].estaPaga) {
      throw StateError('Esta conta já foi paga.');
    }

    final contaPaga = _contas[indice].copyWith(
      status: StatusConta.paga,
      dataPagamento: DateTime.now(),
    );
    _contas[indice] = contaPaga;
    return contaPaga;
  }
}
