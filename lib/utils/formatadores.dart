/// Formata um valor em reais. Ex.: 1234.5 -> "R$ 1.234,50"
String formatarMoeda(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final inteiro = partes[0];
  final buffer = StringBuffer();

  for (var i = 0; i < inteiro.length; i++) {
    final faltam = inteiro.length - i;
    if (i > 0 && faltam % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(inteiro[i]);
  }

  return 'R\$ ${buffer.toString()},${partes[1]}';
}

/// Formata uma data no padrão brasileiro. Ex.: 05/11/2026
String formatarData(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  return '$dia/$mes/${data.year}';
}
