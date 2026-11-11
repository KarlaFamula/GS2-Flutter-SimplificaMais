import 'package:flutter/material.dart';

class MensagemErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;

  const MensagemErro({
    super.key,
    required this.mensagem,
    required this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade800, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mensagem,
                    style: TextStyle(fontSize: 20, color: Colors.red.shade900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onTentarNovamente,
                icon: const Icon(Icons.refresh, size: 28),
                label: const Text('Tentar novamente', style: TextStyle(fontSize: 20)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
