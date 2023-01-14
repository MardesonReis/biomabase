import 'dart:convert';
import 'package:biomaapp/models/listaDatasMedicos.dart';
import 'package:http/http.dart' as http;

import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/AgendaMedico.dart';
import 'package:flutter/material.dart';

class agendaMedicoList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<AgendaMedico> _items = [];
  List<LDatas> _itemsDatas = [];
  List<AgendaMedico> get items => [..._items];
  List<LDatas> get itemsDatas => [..._itemsDatas];

  // print(result.toList());
  agendaMedicoList([
    this._token = '',
    this._userId = '',
    this._items = const [],
    this._itemsDatas = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> listarDatas(String cod_medico, String status) async {
    //debugPrint(cpf);

    _itemsDatas.clear();
    var link = '${Constants.AGENDA_MEDICO_DATAS_BASE_URL}' +
        cod_medico +
        '/' +
        status +
        '/' +
        Constants.AUT_BASE;
    debugPrint(link);

    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    final data = jsonDecode(response.body);
    List agenda = jsonDecode(response.body)['dados'];
    agenda.map(
      (item) {
        _itemsDatas.add(LDatas(
          medico: item['medico'].toString(),
          data: item['data'].toString(),
          unidade: item['unidade'].toString(),
          especialidade: item['especialidade'].toString(),
        ));
      },
    ).toList();
    notifyListeners();
  }

  Future<void> loadAgendaMedico(String cod_medico, String status) async {
    //debugPrint(cpf);

    _items.clear();
    var link = '${Constants.AGENDA_MEDICO_BASE_URL}' +
        cod_medico +
        '/' +
        status +
        '/' +
        Constants.AUT_BASE;
    debugPrint(link);

    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    final data = jsonDecode(response.body);
    List agenda = jsonDecode(response.body)['dados'];
    agenda.map(
      (item) {
        // debugPrint('Carregando especialidade: ${item['especialidade']}');
        _items.add(AgendaMedico(
          medico: item['medico'].toString(),
          data: item['data'].toString(),
          turno: item['turno'].toString(),
          mesano: item['mesano'].toString(),
          observacao: item['observacao'].toString(),
          horario: item['horario'].toString(),
          sequencial: item['sequencial'].toString(),
          status: item['status'].toString(),
          tratamento: item['tratamento'].toString(),
          reservado: item['reservado'].toString(),
          usuario: item['usuario'].toString(),
          unidade: item['unidade'].toString(),
          especialidade: item['especialidade'].toString(),
          motivodesmarcar: item['motivodesmarcar'].toString(),
          tipodeplantao: item['tipodeplantao'].toString(),
          consultorio: item['consultorio'].toString(),
          codconsultorio: item['codconsultorio'].toString(),
          avulso: item['avulso'].toString(),
        ));
      },
    ).toList();
    notifyListeners();
    return;
  }
}
