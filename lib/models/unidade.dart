import 'dart:convert';

import 'package:biomaapp/models/convenios.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Unidade with ChangeNotifier {
  String cod_unidade;
  String des_unidade;
  String contato = '';
  String logo = '';
  String ativo = '';
  String nomecompleto = '';
  String logradouro = '';
  String numero = '';
  String complemento = '';
  String municipio = '';
  String uf = '';
  String cep = '';
  String codibge = '';
  String cnpj = '';
  String bairro = '';
  String novidades = '';
  String cnes = '';
  double longitude = 0;
  double latitude = 0;
  double distancia = 0;

  Unidade({this.cod_unidade = '', this.des_unidade = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unidade &&
          runtimeType == other.runtimeType &&
          cod_unidade == other.cod_unidade;

  @override
  int get hashCode => cod_unidade.hashCode;

  @override
  String toString() {
    return des_unidade;
  }

  Future<Unidade> loadUnidadeID(String unidade) async {
    String link =
        '${Constants.UNIDADES_BASE_URL}/' + unidade + '/' + Constants.AUT_BASE;
    debugPrint(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return this;

    final data = jsonDecode(response.body);
    List proced = jsonDecode(response.body)['dados'];

    await proced.map(
      (item) {
        Unidade u = Unidade(
            cod_unidade: item['codunidades'].toString(),
            des_unidade: item['unidades'].toString());

        this.contato = item['contato'].toString();
        this.logo = item['logo'].toString();
        this.ativo = item['ativo'].toString();
        this.nomecompleto = item['nomecompleto'].toString();
        this.logradouro = item['logradouro'].toString();
        this.numero = item['numero'].toString();
        this.complemento = item['complemento'].toString();
        this.municipio = item['municipio'].toString();
        this.uf = item['uf'].toString();
        this.cep = item['cep'].toString();
        this.codibge = item['codibge'].toString();
        this.cnpj = item['cnpj'].toString();
        this.bairro = item['bairro'].toString();
        this.novidades = item['novidades'].toString();
        this.cnes = item['cnes'].toString();
      },
    ).toList();
    debugPrint(this.cod_unidade);
    notifyListeners();
    return this;
  }

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      cod_unidade: json['cod_unidade'],
      des_unidade: json['des_unidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_unidade': cod_unidade,
      'des_unidade': des_unidade,
      'contato': contato,
      'logo': logo,
      'ativo': ativo,
      'nomecompleto': nomecompleto,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'municipio': municipio,
      'uf': uf,
      'cep': cep,
      'codibge': codibge,
      'cnpj': cnpj,
      'bairro': bairro,
      'novidades': novidades,
      'cnes': cnes,
      'longitude': longitude,
      'latitude': latitude,
      'distancia': distancia,
    };
  }
}
