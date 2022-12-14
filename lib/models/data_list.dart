import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class DataList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Data> _items = [];
  List<Data> get items => [..._items];

  // print(result.toList());
  DataList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return items.length;
  }

  Future<void> loadDados(String medico) async {
    //debugPrint(cpf);

    _items.clear();
    var link = '${Constants.DATA_BASE_URL}/0/' + medico + Constants.AUT_BASE;
    print(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    List listmedicos = jsonDecode(response.body)['dados'];
    //Set<String> medicosInclusoIncluso = Set();

    listmedicos.map(
      (item) {
        _items.add(Data(
          crm: item['crm'].toString(),
          cpf: item['cpf'].toString(),
          cod_profissional: item['cod_profissional'].toString(),
          des_profissional: item['des_profissional'].toString(),
          cod_especialidade: item['cod_especialidade'].toString(),
          des_especialidade: item['des_especialidade'].toString(),
          grupo: item['grupo'].toString(),
          idade_mim: item['idade_mim'].toString(),
          idade_max: item['idade_max'].toString(),
          sub_especialidade: item['sub_especialidade'].toString(),
          cod_unidade: item['cod_unidade'].toString(),
          des_unidade: item['des_unidade'].toString(),
          cod_convenio: item['cod_convenio'].toString(),
          desc_convenio: item['desc_convenio'].toString(),
          cod_procedimentos: item['cod_procedimentos'].toString(),
          des_procedimentos: item['des_procedimentos'].toString(),
          cod_tratamento: item['cod_tratamento'].toString(),
          tipo_tratamento: item['tipo_tratamento'].toString(),
          tabop_quantidade: item['tabop_quantidade'].toString(),
          valor: item['valor'].toString(),
          frequencia: item['frequencia'].toString(),
        ));
      },
    ).toList();

    items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    // notifyListeners();
  }
}
