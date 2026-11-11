import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simplifica_mais_universal/services/viacep_service.dart';

void main() {
  test('converte o JSON do ViaCEP em Endereco', () async {
    final client = MockClient((request) async {
      return http.Response(
        '{"cep":"01311-000","logradouro":"Avenida Paulista","bairro":"Bela Vista",'
        '"localidade":"São Paulo","uf":"SP"}',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final service = ViaCepService(client: client);

    final endereco = await service.buscarEndereco('01311-000');

    expect(endereco.logradouro, 'Avenida Paulista');
    expect(endereco.localidade, 'São Paulo');
  });

  test('CEP com menos de 8 números gera erro', () async {
    final service = ViaCepService(client: MockClient((_) async => http.Response('', 200)));

    await expectLater(service.buscarEndereco('123'), throwsException);
  });

  test('CEP inexistente gera erro', () async {
    final client = MockClient((_) async => http.Response('{"erro": true}', 200));
    final service = ViaCepService(client: client);

    await expectLater(service.buscarEndereco('99999999'), throwsException);
  });
}
