import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class AgendamentosList with ChangeNotifier {
  final String _token;
  final String _userId;

  List<Agendamentos> _items = [];
  List<Agendamentos> get items => [..._items];

  // print(result.toList());
  AgendamentosList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return items.length;
  }

  Future<void> loadAgendamentos(String cpf_paciente, String cpf_parceiro,
      String movimento, String cpf_medico) async {
    //debugPrint(cpf);

    _items.clear();
    var link = '${Constants.PROCEDIMENTOS}procedimentosAgendados/' +
        cpf_paciente +
        '/' +
        cpf_parceiro +
        '/' +
        movimento +
        '/' +
        cpf_medico +
        '/' +
        Constants.AUT_BASE;
    print(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    if (jsonDecode(response.body)['dados'] == 'null') return;
    List listmedicos = jsonDecode(response.body)['dados'] ?? [];

    if (listmedicos.isEmpty) return;
    await listmedicos.map(
      (item) {
        //   debugPrint('Carregando Medicos: ${item['codprofissional']}');

        Agendamentos agendamentos = Agendamentos();

        agendamentos.data_movimento = item['data_movimento'].toString();
        agendamentos.cod_paciente = item['cod_paciente'].toString();
        agendamentos.cod_procedimento = item['cod_procedimento'].toString();
        agendamentos.des_procedimento = item['des_procedimento'].toString();
        agendamentos.des_paciente = item['des_paciente'].toString();
        agendamentos.des_parceiro = item['des_parceiro'].toString();
        agendamentos.des_uni_procedimentos =
            item['des_uni_procedimentos'].toString();
        agendamentos.des_status_procedimento =
            item['des_status_procedimento'].toString();
        agendamentos.des_status_agenda = item['des_status_agenda'].toString();
        agendamentos.olho = item['olho'].toString();
        agendamentos.dataatendimento = item['dataatendimento'].toString();
        agendamentos.cod_profissional = item['cod_profissional'].toString();
        agendamentos.des_profissional = item['des_profissional'].toString();
        agendamentos.cpf_profissional = item['cpf_profissional'].toString();
        agendamentos.cod_unidade = item['cod_unidade'].toString();
        agendamentos.des_unidade = item['des_unidade'].toString();
        agendamentos.cod_especialidade = item['cod_especialidade'].toString();
        agendamentos.des_especialidade = item['des_especialidade'].toString();
        agendamentos.cod_convenio = item['cod_convenio'].toString();
        agendamentos.des_convenio = item['des_convenio'].toString();
        agendamentos.cod_atendimento = item['cod_atendimento'].toString();
        agendamentos.cod_parceiro = item['cod_parceiro'].toString();
        agendamentos.cpf_paciente = item['cpf_paciente'].toString();
        agendamentos.cpf_parceiro = item['cpf_parceiro'].toString();
        agendamentos.quantidade = item['quantidade'].toString();
        agendamentos.valor = item['valor'].toString();
        agendamentos.hora_marcacao = item['hora_marcacao'].toString();

        _items.add(agendamentos);
      },
    ).toList();

    notifyListeners();
  }

  Future<Agendamentos> AtulizarStatus(String movimento, String Status) async {
    //debugPrint(cpf);
    Agendamentos agendamentos = Agendamentos();

    //_items.clear();
    var link = '${Constants.PROCEDIMENTOS}AtulizarStatus/' +
        movimento +
        '/' +
        Status +
        Constants.AUT_BASE;
    print(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return agendamentos;
    //debugPrint(response.body);
    if (jsonDecode(response.body)['dados'] == 'null') return agendamentos;
    List listmedicos = jsonDecode(response.body)['dados'] ?? [];

    if (listmedicos.isEmpty) return agendamentos;

    await listmedicos.map(
      (item) {
        //   debugPrint('Carregando Medicos: ${item['codprofissional']}');

        agendamentos.data_movimento = item['data_movimento'].toString();
        agendamentos.cod_paciente = item['cod_paciente'].toString();
        agendamentos.cod_procedimento = item['cod_procedimento'].toString();
        agendamentos.des_procedimento = item['des_procedimento'].toString();
        agendamentos.des_uni_procedimentos =
            item['des_uni_procedimentos'].toString();
        agendamentos.des_status_procedimento =
            item['des_status_procedimento'].toString();
        agendamentos.des_status_agenda = item['des_status_agenda'].toString();
        agendamentos.olho = item['olho'].toString();
        agendamentos.dataatendimento = item['dataatendimento'].toString();
        agendamentos.cod_profissional = item['cod_profissional'].toString();
        agendamentos.des_profissional = item['des_profissional'].toString();
        agendamentos.cod_unidade = item['cod_unidade'].toString();
        agendamentos.des_unidade = item['des_unidade'].toString();
        agendamentos.cod_especialidade = item['cod_especialidade'].toString();
        agendamentos.des_especialidade = item['des_especialidade'].toString();
        agendamentos.cod_convenio = item['cod_convenio'].toString();
        agendamentos.des_convenio = item['des_convenio'].toString();
        agendamentos.cod_atendimento = item['cod_atendimento'].toString();
        agendamentos.cod_parceiro = item['cod_parceiro'].toString();
        agendamentos.cpf_paciente = item['cpf_paciente'].toString();
        agendamentos.cpf_parceiro = item['cpf_parceiro'].toString();
        agendamentos.quantidade = item['quantidade'].toString();
        agendamentos.valor = item['valor'].toString();
        agendamentos.hora_marcacao = item['hora_marcacao'].toString();
      },
    ).toList();
    return agendamentos;

    notifyListeners();
  }
}
