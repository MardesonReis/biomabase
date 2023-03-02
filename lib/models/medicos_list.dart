import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class MedicosList with ChangeNotifier {
  final String _token;
  final String _userId;

  List<Medicos> _items = [];
  List<Medicos> get items => [..._items];

  List<Medicos> medicos = [];

  List<Unidade> unidades = [];

  List<Convenios> convenios = [];

  // print(result.toList());
  MedicosList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return items.length;
  }

  Future<void> loadMedicosId(String medico) async {
    //debugPrint(cpf);

    _items.clear();

    final response = await http.get(
      Uri.parse(
          '${Constants.MEDICOS_BASE_URL}/0/' + medico + Constants.AUT_BASE),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    List listmedicos = jsonDecode(response.body)['dados'];
    Set<String> medicosInclusoIncluso = Set();
    Set<String> unidadesInclusoIncluso = Set();
    Set<String> conveniosInclusoIncluso = Set();
    Set<String> procedimentosInclusoIncluso = Set();

    listmedicos.map(
      (item) {
        _items.add(Medicos()
            .BuscarMedicoPorId(item['cod_profissional'].toString()) as Medicos);
      },
    ).toList();

    // debugPrint(unidades.length.toString());
    // debugPrint(convenios.length.toString());

    notifyListeners();
  }

  Future<void> loadMedicosCPF(String cpf) async {
    //debugPrint(cpf);

    _items.clear();

    final response = await http.get(
      Uri.parse(
          '${Constants.MEDICOS_BASE_URL}/0/0/' + cpf + Constants.AUT_BASE),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    List listmedicos = jsonDecode(response.body)['dados'];
    Set<String> medicosInclusoIncluso = Set();
    Set<String> unidadesInclusoIncluso = Set();
    Set<String> conveniosInclusoIncluso = Set();
    Set<String> procedimentosInclusoIncluso = Set();

    listmedicos.map(
      (item) {
        _items.add(Medicos()
            .BuscarMedicoPorId(item['cod_profissional'].toString()) as Medicos);
      },
    ).toList();

    // debugPrint(unidades.length.toString());
    // debugPrint(convenios.length.toString());

    notifyListeners();
  }
}
