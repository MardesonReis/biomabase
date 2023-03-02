import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/medicos.dart';
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

class RegrasList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Regra> _items = [];
  List<Data> _dados = [];
  List<Regra> get items => [..._items];
  List<Data> get dados => [..._dados];

  // print(result.toList());
  RegrasList([
    this._token = '',
    this._userId = '',
    this._items = const [],
    this._dados = const [],
  ]);

  int get itemsCount {
    return items.length;
  }

  limparDados() {
    this._items.clear();
    this._dados.clear();
  }

  Future<List<Regra>> Regras(String cpf) async {
    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};
    _items.clear();
    _dados.clear();

    var link =
        Constants.REGRAS_BASE_URL + 'listar/' + cpf + '//' + Constants.AUT_BASE;

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
        if (agendamentolist.first['id_regra'].toString() == '') return [];
        await agendamentolist.map(
          (item) {
            _items.add(new Regra(
                id_regra: item['id_regra'].toString(),
                valor_sugerido: item['valor_sugerido'].toString(),
                orientacoes: item['orientacoes'].toString(),
                cpf_parceiro: item['cpf_parceiro'].toString(),
                des_parceiro: item['des_parceiro'].toString(),
                cpf_medico: item['cpf_medico'].toString(),
                des_medico: item['des_profissional'].toString(),
                cod_procedimento: item['cod_procedimentos'].toString(),
                des_procedimento: item['des_procedimentos'].toString(),
                cod_convenio: item['cod_convenio'].toString(),
                des_convenio: item['des_convenio'].toString(),
                cod_unidade: item['cod_unidade'].toString(),
                des_unidade: item['des_unidade'].toString(),
                valor_base: item['valor_base'].toString(),
                status: item['status'].toString(),
                data_criacao: item['data_criacao'].toString(),
                hora_criacao: item['hora_criacao'].toString(),
                rateios: []));

            var data = Data(
              id_regra: item['id_regra'].toString(),
              valor_sugerido: item['valor_sugerido'].toString(),
              orientacoes: item['orientacoes'].toString(),
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
            ); //  _items.add(Fila());
            //     item['crm'].toString(),
            this._dados.add(data);
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
    _items.clear();
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

  Future<String> addRegra(Regra regra) async {
    //debugPrint(cpf);
    var idRegra = '';

    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formatterHora = DateFormat('HH:mm');
    final String dataatual = formatterdate.format(now);
    final String horaatual = formatterHora.format(now);

    Map<String, String> param = {
      "id_regra": regra.id_regra,
      "cpf_parceiro": regra.cpf_parceiro,
      "des_parceiro": regra.des_parceiro,
      "cpf_medico": regra.cpf_medico,
      "des_medico": regra.des_medico,
      "cod_procedimento": regra.cod_procedimento,
      "des_procedimento": regra.des_procedimento,
      "cod_convenio": regra.cod_convenio,
      "des_convenio": regra.des_convenio,
      "cod_unidade": regra.cod_unidade,
      "des_unidade": regra.des_unidade,
      "valor_base": regra.valor_base,
      "valor_sugerido": regra.valor_sugerido,
      "orientacoes": regra.orientacoes,
      "status": regra.status,
      "data_criacao": dataatual,
      "hora_criacao": horaatual
    };

    var link = Constants.REGRAS_BASE_URL + 'add/' + Constants.AUT_BASE;
    var response;
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
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];
        if (agendamentolist.first['id_regra'].toString() == '') return '';
        await agendamentolist.map(
          (item) {
            idRegra = item['id_regra'].toString();
            //  _items.add(Fila());
            //     item['crm'].toString(),
          },
        ).toList();
      } catch (e) {
        print(e.toString());
        idRegra = '';
      }
    } catch (e) {
      print(e.toString());
      idRegra = '';
    }

    return idRegra;
  }

  Future<bool> carrgardados(BuildContext context,
      {bool all = false, required VoidCallback Onpress}) async {
    Auth auth = Provider.of(context, listen: false);

    if (this._dados.isEmpty || all == true) {
      this.limparDados();

      //await auth.fidelimax.ConsultaConsumidor(auth.fidelimax.cpf);
      // await auth.fidelimax.RetornaDadosCliente(auth.fidelimax.cpf);

      await this.Regras(auth.fidelimax.cpf).then((value) {
        Onpress.call();
      });
    } else {
      Onpress.call();
    }

    return true;
  }
}
