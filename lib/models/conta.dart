enum TipoConta { agua, luz, boleto }

enum StatusConta { pendente, paga }

class Conta {
  final String id;
  final String descricao;
  final String empresa;
  final TipoConta tipo;
  final double valor;
  final DateTime vencimento;
  final StatusConta status;
  final DateTime? dataPagamento;

  const Conta({
    required this.id,
    required this.descricao,
    required this.empresa,
    required this.tipo,
    required this.valor,
    required this.vencimento,
    this.status = StatusConta.pendente,
    this.dataPagamento,
  });

  bool get estaPaga => status == StatusConta.paga;

  Conta copyWith({
    StatusConta? status,
    DateTime? dataPagamento,
  }) {
    return Conta(
      id: id,
      descricao: descricao,
      empresa: empresa,
      tipo: tipo,
      valor: valor,
      vencimento: vencimento,
      status: status ?? this.status,
      dataPagamento: dataPagamento ?? this.dataPagamento,
    );
  }
}
