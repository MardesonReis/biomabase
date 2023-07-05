import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/Fila.dart';
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
import 'package:intl/intl.dart';

class FilaList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Fila> _items = [];
  List<Fila> get items => [..._items];

  // print(result.toList());
  FilaList([
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

    final response = await http.get(
      Uri.parse('${Constants.DATA_BASE_URL}/0/' + medico + Constants.AUT_BASE),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    List listmedicos = jsonDecode(response.body)['dados'];
    //Set<String> medicosInclusoIncluso = Set();

    listmedicos.map(
      (item) {
        //  _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    notifyListeners();
  }

  Future<String> Agendar(Fila fila) async {
    //debugPrint(cpf);
    var movimento = '';

    _items.clear();
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formatterHora = DateFormat('HH:mm');
    final String dataatual = formatterdate.format(now);
    final String horaatual = formatterHora.format(now);
    Map<String, String> param = {
      "movimento": '',
      "datamovimento": fila.data,
      "paciente": fila.indicado.id,
      "codprofissional": fila.medico.cod_profissional,
      "status": "P",
      "convenio": fila.convenios.cod_convenio,
      "horamarcacao": fila.horario,
      "tratamento": fila.procedimento.cod_tratamento,
      "telefoneagenda": fila.indicado.celular,
      "formapgto": '1',
      "transacao": '',
      "codusuario": "99",
      "observacao": "Agendamento via BiomaApp",
      "unidade": fila.unidade.cod_unidade,
      "dataagendamento": dataatual,
      "horaagendamento": horaatual,
      "usuarioagendamento": '99',
      "nomepaciente": fila.indicado.nome,
      "especialidade": fila.procedimento.especialidade.cod_especialidade,
      "visivel": "S",
      "unidadeagendamento": "1",
      "procedimentos": fila.procedimento.des_procedimento,
      "codparceiro": fila.indicando.id,
      "regime": "N",
      "teleatendimento": "f",
      "confirmadorobo": "f"
    };

    var link = Constants.FILA_BASE_URL + 'agendar/' + Constants.AUT_BASE;
    var response;

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          body: param,
          encoding: Encoding.getByName("utf-8"));
      try {
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];
        if (agendamentolist.first['movimento'].toString() == '') return '';
        await agendamentolist.map(
          (item) {
            movimento = item['movimento'].toString();
            //  _items.add(Fila());
            //     item['crm'].toString(),
          },
        ).toList();
      } catch (e) {
        print(e.toString());
        movimento = '';
      }
    } catch (e) {
      print(e.toString());
      movimento = '';
    }

    print(response.body);

    //  List listmedicos = jsonDecode(response.body)['dados'] ?? [];
    //Set<String> medicosInclusoIncluso = Set();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    // notifyListeners();
    // notifyListeners();

    return movimento;
  }

  Future<String> ProcedimentosAgendados(Fila fila) async {
    //debugPrint(cpf);
    var idnuagendado = '';

    _items.clear();

    Map<String, String> param = {
      'paciente': fila.indicado.id,
      'datamovimento': fila.data,
      'tratamento': fila.procedimento.cod_tratamento,
      'procedimento': fila.procedimento.cod_procedimento,
      'status': 'A',
      'pacientereserva': fila.indicado.nome,
      'olho': fila.procedimento.olho,
      'quantidade': fila.procedimento.quantidade,
      'parecermedico': '',
      'dataatendimento': fila.data,
      'codprofissional': fila.medico.cod_profissional,
      'unidade': fila.unidade.cod_unidade,
      'especialidades': fila.procedimento.especialidade.cod_especialidade,
      'codtabela': fila.convenios.cod_convenio,
      'nratendimento': fila.sequencial,
      'id_codigo': fila.convenios.cod_convenio,
      'id_nragendado': '',
      'encaminhadopor': fila.indicando.cpf,
      'origem': '',
      'biometriaautorizada': '',
      'atendente': '99',
      'codparceiro': fila.indicando.id,
      'usuarioagendamento': '99',
    };
    var link = Constants.FILA_BASE_URL +
        'procedimentosAgendados/' +
        Constants.AUT_BASE;
    //print(link.toString());
    final response = await http.post(Uri.parse(link),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Charset': 'utf-8'
        },
        body: param,
        encoding: Encoding.getByName("utf-8"));

    if (response.body == 'null') return '';
    print(response.body);
    var agendamentolist = await jsonDecode(response.body)['dados'];

    await agendamentolist.map(
      (item) {
        idnuagendado = item['movimento'].toString();
        //  _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();
    //Set<String> medicosInclusoIncluso = Set();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //  notifyListeners();
    return idnuagendado;
  }

  Future<String> GerarFilaIndicacao(Fila fila) async {
    //debugPrint(cpf);
    var movimento = '';

    _items.clear();
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formatterdate2 = DateFormat('dd-MM-yyyy');
    final DateFormat formatterHora = DateFormat('HH:mm');
    final String dataatual = formatterdate.format(now);
    final String horaatual = formatterHora.format(now);
    final String dataatual2 = formatterdate2.format(now);
    Map<String, String> param = {
      "id_indicacao": '',
      "descricao": "Lista de Indicacao " + dataatual2,
      "status": "A",
      "data_criacao": dataatual,
      "hora_criacao": horaatual,
      "autor": fila.indicando.cpf,
      "visivel": "S",
    };

    var link =
        Constants.FILA_BASE_URL + 'GerarFilaIndicacao/' + Constants.AUT_BASE;
    var response;

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          body: param,
          encoding: Encoding.getByName("utf-8"));
      final body = jsonDecode(response.body);
      if (response.body == 'null') return '';
      print(response.body);

      try {
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];
        if (agendamentolist.first['id_indicacao'].toString() == '') return '';
        await agendamentolist.map(
          (item) {
            movimento = item['id_indicacao'].toString();
            //  _items.add(Fila());
            //     item['crm'].toString(),
          },
        ).toList();
      } catch (e) {
        print(e.toString());
        movimento = '';
      }
    } catch (e) {
      print(e.toString());
      movimento = '';
    }

    //  List listmedicos = jsonDecode(response.body)['dados'] ?? [];
    //Set<String> medicosInclusoIncluso = Set();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    // notifyListeners();
    // notifyListeners();

    return movimento;
  }

  Future<String> SalvaIndicacao(Fila fila, String id_indicacao) async {
    //debugPrint(cpf);
    var id_servico = '';

    _items.clear();
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formatterdate2 = DateFormat('dd-MM-yyyy');
    final DateFormat formatterHora = DateFormat('HH:mm');
    final String dataatual = formatterdate.format(now);
    final String horaatual = formatterHora.format(now);
    final String dataatual2 = formatterdate2.format(now);

    Map<String, String> param = {
      'id_servico': '',
      'id_indicacao': id_indicacao,
      'cod_procedimento': fila.procedimento.cod_procedimento,
      'des_procedimento': fila.procedimento.des_procedimento,
      'cod_convenio': fila.convenios.cod_convenio,
      'des_convenio': fila.convenios.desc_convenio,
      'cod_tratamento': fila.procedimento.cod_tratamento,
      'des_tratamento': fila.procedimento.des_tratamento,
      'cod_especialista': fila.medico.cod_profissional,
      'des_especialista': fila.medico.des_profissional,
      'cod_unidade': fila.unidade.cod_unidade,
      'des_unidade': fila.unidade.des_unidade,
      'cod_especialidade': fila.procedimento.especialidade.cod_especialidade,
      'des_especialidade': fila.procedimento.especialidade.des_especialidade,
      'status': 'A',
      'valor': fila.procedimento.valor.toString(),
      'olho': fila.procedimento.olho,
      'quantidade': fila.procedimento.quantidade,
      'obs': fila.obs,
      'data': dataatual,
      'hora': horaatual,
    };
    var link = Constants.FILA_BASE_URL + 'indicar/' + Constants.AUT_BASE;

    final response = await http.post(Uri.parse(link),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Charset': 'utf-8'
        },
        body: param,
        encoding: Encoding.getByName("utf-8"));

    if (response.body == 'null') return '';
    print(response.body);
    var agendamentolist = await jsonDecode(response.body)['dados'];

    await agendamentolist.map(
      (item) {
        id_servico = item['id_servico'].toString();
        //  _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();
    //Set<String> medicosInclusoIncluso = Set();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //  notifyListeners();
    return id_servico;
  }
}
