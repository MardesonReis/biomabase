import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Especialidade with ChangeNotifier {
  String cod_especialidade;
  String des_especialidade;
  String ativo;

  Especialidade(
      {required this.cod_especialidade,
      required this.des_especialidade,
      required this.ativo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Especialidade &&
          runtimeType == other.runtimeType &&
          des_especialidade == other.des_especialidade;

  @override
  int get hashCode => des_especialidade.hashCode;

  @override
  String toString() {
    return des_especialidade;
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_especialidade': cod_especialidade,
      'des_especialidade': des_especialidade,
      'ativo': ativo,
    };
  }

  factory Especialidade.fromJson(Map<String, dynamic> json) {
    return Especialidade(
      cod_especialidade: json['cod_especialidade'].toString(),
      des_especialidade: json['des_especialidade'].toString(),
      ativo: json['ativo'].toString(),
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
