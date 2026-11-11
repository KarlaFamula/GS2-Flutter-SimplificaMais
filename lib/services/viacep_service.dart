import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco.dart';

class ViaCepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  /// O client pode ser trocado nos testes por um MockClient.
  ViaCepService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Endereco> buscarEndereco(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) {
      throw Exception('O CEP deve ter 8 números.');
    }

    final uri = Uri.parse('$_baseUrl/$cepLimpo/json/');
    final response = await _requisitar(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Não foi possível consultar o CEP agora (código ${response.statusCode}).',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['erro'] == true || json['erro'] == 'true') {
      throw Exception('CEP não encontrado. Confira os números.');
    }

    return Endereco.fromJson(json);
  }

  Future<http.Response> _requisitar(Uri uri) async {
    try {
      return await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      throw Exception('Sem conexão com a internet. Verifique e tente novamente.');
    }
  }
}
