import 'dart:convert';

import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Medicos with ChangeNotifier {
  String cod_profissional = '';
  String des_profissional = '';
  String cod_especialidade = '';
  String celular = '';
  String crm = '';
  String data_nascimento = '';
  String cpf = '';
  String nomecompleto = '';
  String ativo = '';
  String emial = '';
  String subespecialidade = '';
  String idademin = '';
  String idademax = '';
  String PacientesAtendidos = '';
  String TotalDeAtendidos = '';

  Medicos();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unidade &&
          runtimeType == other.runtimeType &&
          des_profissional == other.des_unidade;

  @override
  int get hashCode => des_profissional.hashCode;

  @override
  String toString() {
    return des_profissional;
  }

  Future<Medicos> BuscarMedicoPorId(String medico) async {
    String link =
        '${Constants.MEDICOS_BASE_URL}/' + medico + '/' + Constants.AUT_BASE;
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return this;
    debugPrint(link);
    List listmedicos = jsonDecode(response.body)['dados'];
    Medicos loadMed = Medicos();

    await listmedicos.map(
      (item) {
        debugPrint('Carregando Medicos: ${item['cod_profissional']}');

        this.cod_profissional = item['cod_profissional'].toString();
        this.des_profissional = item['des_profissional'].toString();
        this.cod_especialidade = item['cod_especialidade'].toString();
        this.celular = item['celular'].toString();
        this.crm = item['crm'].toString();
        this.data_nascimento = item['data_nascimento'].toString();
        this.cpf = item['cpf'].toString();
        this.nomecompleto = item['nomecompleto'].toString();
        this.ativo = item['ativo'].toString();
        this.emial = item['emial'].toString();
        this.subespecialidade = item['subespecialidade'].toString();
        this.idademin = item['idademin'].toString();
        this.idademax = item['idademax'].toString();

        //  _items.add(med);
      },
    ).toList();
    return this;
  }
}
