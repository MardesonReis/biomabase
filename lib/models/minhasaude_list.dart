import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/ms_registro.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MinhaSaudeList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<MinhaSaude> _tipos = [];
  List<MinhaSaude> get tipos => [..._tipos];
  List<Ms_registro> _items = [];
  List<Ms_registro> get items => [..._items];

  // print(result.toList());
  MinhaSaudeList([
    this._token = '',
    this._userId = '',
    this._tipos = const [],
    this._items = const [],
  ]);

  int get itemsCount {
    return items.length;
  }

  limparDados() {
    this._tipos.clear();
  }

  Future<List<MinhaSaude>> ListarTipos() async {
    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};
    _tipos.clear();

    var link = Constants.BIOMA_API + 'minhasaude/tipo/' + Constants.AUT_BASE;

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //notifyListeners();

    var response;
    print(link);

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          // body: param,
          encoding: Encoding.getByName("utf-8"));
      try {
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];

        await agendamentolist.map(
          (item) {
            var ms = new MinhaSaude(
                id: item['id'].toString(),
                grupo: item['grupo'].toString(),
                subgrupo: item['subgrupo'].toString(),
                descricao: item['descricao'].toString(),
                medida: item['medida'].toString(),
                franquencia: item['franquencia'].toString(),
                range_i: item['range_i'].toString(),
                range_f: item['range_f'].toString());
            if (!_tipos.contains(ms)) {
              _tipos.add(ms);
            }
          },
        ).toList();
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }

    return _tipos;
  }

  Future<List<Ms_registro>> listar(
      String cpf_paciente, String data_registro, String ms_id) async {
    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};
    _items.clear();

    var link = Constants.BIOMA_API +
        'minhasaude/listar/' +
        Constants.AUT_BASE +
        '&cpf_paciente=' +
        cpf_paciente;

    if (data_registro.trim().isNotEmpty) {
      link = link + '&data_registro=' + data_registro;
    }
    if (ms_id.trim().isNotEmpty) {
      link = link + '&ms_id=' + data_registro;
    }

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //notifyListeners();

    var response;
    print(link);

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          // body: param,
          encoding: Encoding.getByName("utf-8"));
      try {
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];

        await agendamentolist.map(
          (item) {
            Ms_registro ms = new Ms_registro(
                id: item['id'].toString(),
                ms_id: item['ms_id'].toString(),
                ms_value: item['ms_value'].toString(),
                ms_value_agrupado: item['ms_value_agrupado'].toString(),
                cpf_paciente: item['cpf_paciente'].toString(),
                cpf_responsavel: item['cpf_responsavel'].toString(),
                obs: item['obs'].toString(),
                data_registro: DateTime.parse(item['data_registro'].toString()),
                hora_registro: item['hora_registro'].toString());
            if (!_items.contains(ms)) {
              _items.add(ms);
            }
          },
        ).toList();
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }

    return _items;
  }

  Future<String> Remover(String idRegra) async {
    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};
    _tipos.clear();
    var id = '';
    var link =
        Constants.REGRAS_BASE_URL + 'remover/' + idRegra + Constants.AUT_BASE;

    var response;

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          // body: param,
          encoding: Encoding.getByName("utf-8"));
      print(response.body);
      List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];
      if (agendamentolist.first['id_regra'].toString() == '') return '';
      await agendamentolist.map(
        (item) {
          id = item['id_regra'].toString();
          //  _items.add(Fila());
          //     item['crm'].toString(),
        },
      ).toList();
    } catch (e) {
      print(e.toString());
      id = '';
    }

    return id;

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //notifyListeners();
  }

  Future<String> add(Ms_registro regitro) async {
    //debugPrint(cpf);
    var idRegistro = '';

    Map<String, String> param = {
      'ms_id': regitro.ms_id,
      'ms_value': regitro.ms_value,
      'ms_value_agrupado': regitro.ms_value_agrupado,
      'cpf_paciente': regitro.cpf_paciente,
      'cpf_responsavel': regitro.cpf_responsavel,
      'obs': regitro.obs,
      'data_registro': regitro.data_registro.toString(),
      'hora_registro': regitro.hora_registro,
    };

    var link = Constants.BIOMA_API + 'minhasaude/add/' + Constants.AUT_BASE;
    var response;
    print(link.toString());
    print(param.toString());

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          body: param,
          encoding: Encoding.getByName("utf-8"));
      try {
        print(response.body);
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];

        if (agendamentolist.first['r_id'].toString() == '') return '';
        await agendamentolist.map(
          (item) {
            idRegistro = item['id'].toString();
            //  _items.add(Fila());
            //     item['crm'].toString(),
          },
        ).toList();
      } catch (e) {
        print(e.toString());
        idRegistro = '';
      }
    } catch (e) {
      print(e.toString());
      idRegistro = '';
    }

    return idRegistro;
  }
}
