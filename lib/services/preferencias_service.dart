import 'package:shared_preferences/shared_preferences.dart';
import '../models/endereco.dart';

/// Centraliza tudo que é salvo no aparelho com SharedPreferences.
class PreferenciasService {
  static const String _chaveNaoMostrarOnboarding = 'nao_mostrar_onboarding';
  static const String _chaveCep = 'perfil_cep';
  static const String _chaveLogradouro = 'perfil_logradouro';
  static const String _chaveBairro = 'perfil_bairro';
  static const String _chaveCidade = 'perfil_cidade';
  static const String _chaveUf = 'perfil_uf';

  Future<bool> deveMostrarOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final naoMostrar = prefs.getBool(_chaveNaoMostrarOnboarding) ?? false;
    return !naoMostrar;
  }

  Future<void> salvarPreferenciaOnboarding(bool naoMostrarNovamente) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveNaoMostrarOnboarding, naoMostrarNovamente);
  }

  Future<void> salvarEndereco(Endereco endereco) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveCep, endereco.cep);
    await prefs.setString(_chaveLogradouro, endereco.logradouro);
    await prefs.setString(_chaveBairro, endereco.bairro);
    await prefs.setString(_chaveCidade, endereco.localidade);
    await prefs.setString(_chaveUf, endereco.uf);
  }

  Future<Endereco?> carregarEndereco() async {
    final prefs = await SharedPreferences.getInstance();
    final cep = prefs.getString(_chaveCep);
    if (cep == null) {
      return null;
    }
    return Endereco(
      cep: cep,
      logradouro: prefs.getString(_chaveLogradouro) ?? '',
      bairro: prefs.getString(_chaveBairro) ?? '',
      localidade: prefs.getString(_chaveCidade) ?? '',
      uf: prefs.getString(_chaveUf) ?? '',
    );
  }

  Future<void> limparEndereco() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveCep);
    await prefs.remove(_chaveLogradouro);
    await prefs.remove(_chaveBairro);
    await prefs.remove(_chaveCidade);
    await prefs.remove(_chaveUf);
  }
}
