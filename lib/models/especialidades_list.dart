import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/especialidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class EspecialidadesList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Especialidade> _items = [];
  List<Especialidade> get items => [..._items];

  // print(result.toList());
  EspecialidadesList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadEspecialidade(String cod_especialidade) async {
    //debugPrint(cpf);

    _items.clear();
    // debugPrint('${Constants.ESPECIALIDADES_BASE_URL}/' +
    //    cod_especialidade +
    //    Constants.AUT_BASE);
    final response = await http.get(
      Uri.parse('${Constants.ESPECIALIDADES_BASE_URL}/' +
          cod_especialidade +
          Constants.AUT_BASE),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    final data = jsonDecode(response.body);
    List ESPECIALIDADE = jsonDecode(response.body)['dados'];

    ESPECIALIDADE.map(
      (item) {
        //    debugPrint('Carregando especialidade: ${item['especialidade']}');
        _items.add(Especialidade(
          cod_especialidade: item['cod_especialidade'].toString(),
          des_especialidade: item['des_especialidade'].toString(),
          ativo: '1',
        ));
      },
    ).toList();

    notifyListeners();
    return;
  }
}
