import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Especialidade with ChangeNotifier {
  String codespecialidade;
  String descricao;
  String ativo;

  Especialidade(
      {required this.codespecialidade,
      required this.descricao,
      required this.ativo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Especialidade &&
          runtimeType == other.runtimeType &&
          descricao == other.descricao;

  @override
  int get hashCode => descricao.hashCode;

  @override
  String toString() {
    return descricao;
  }

  Map<String, dynamic> toJson() {
    return {
      'codespecialidade': codespecialidade,
      'descricao': descricao,
      'ativo': ativo,
    };
  }

  factory Especialidade.fromJson(Map<String, dynamic> json) {
    return Especialidade(
      codespecialidade: json['codespecialidade'],
      descricao: json['descricao'],
      ativo: json['ativo'],
    );
  }
  static Future<Especialidade> fromId(String id) async {
    // Aqui você deve implementar a lógica para obter os dados da especialidade
    // com base no código fornecido, por meio de uma API ou de qualquer outra fonte de dados.

    // Exemplo de implementação utilizando a biblioteca http para fazer a requisição à API:

    final url =
        Constants.ESPECIALIDADES_BASE_URL + id + '/' + Constants.AUT_BASE;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final especialidadeData = jsonResponse['data'];

      return Especialidade.fromJson(especialidadeData);
    } else {
      throw Exception('Falha ao obter os dados da especialidade.');
    }
  }
}
