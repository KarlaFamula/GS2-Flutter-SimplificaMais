import 'package:flutter/material.dart';
import '../models/endereco.dart';

class CardEndereco extends StatelessWidget {
  final Endereco endereco;

  const CardEndereco({super.key, required this.endereco});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.home, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CEP: ${endereco.cep}', style: const TextStyle(fontSize: 20)),
                  Text('Rua: ${endereco.logradouro}', style: const TextStyle(fontSize: 20)),
                  Text('Bairro: ${endereco.bairro}', style: const TextStyle(fontSize: 20)),
                  Text(
                    'Cidade: ${endereco.localidade} - ${endereco.uf}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
