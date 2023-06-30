import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/fidelimax.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class UsuariosList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Usuario> _items = [];
  List<Usuario> get items => [..._items];

  // print(result.toList());
  UsuariosList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadPacientes(String query) async {
    //debugPrint(cpf);
    _items.clear();
    String like = '';
    String offset = '';
    String cpf = UtilBrasilFields.isCPFValido(query) ||
            UtilBrasilFields.isCNPJValido(query)
        ? query
        : '0';
    if (cpf == '0') {
      like = '&like=' + query;
    }
    offset = '&offset=' + this._items.length.toString();

    var url = '${Constants.PACIENTE_BASE_URL}' +
        cpf +
        '/' +
        '0/' +
        Constants.AUT_BASE +
        like +
        offset;

    var link = Uri.parse(url);
    // debugPrint(link.toString());

    final response = await http.get(link);
    if (response.body == 'null') return;
    final data = jsonDecode(response.body);
    List paciente = jsonDecode(response.body)['dados'];

    paciente.map((e) => null);
    List<void> list2 = paciente.map(
      (item) {
        // debugPrint('Carregando nomepaciente: ${item['nomepaciente']}');
        Usuario user = Usuario();
        user.pacientes_id = item['pacientes_id'].toString();
        user.pacientes_cpf = item['pacientes_cpf'].toString();
        user.pacientes_nomepaciente = item['pacientes_nomepaciente'].toString();
        user.pacientes_datanascimento =
            item['pacientes_datanascimento'].toString();
        user.pacientes_sexo = item['pacientes_sexo'].toString();
        user.pacientes_codendereco = item['pacientes_codendereco'].toString();
        user.pacientes_nr = item['pacientes_nr'].toString();
        user.pacientes_tel_whatsapp = item['pacientes_tel_whatsapp'].toString();
        user.pacientes_celular = item['pacientes_celular'].toString();
        user.pacientes_telefone = item['pacientes_telefone'].toString();
        user.pacientes_email = item['pacientes_email'].toString();
        user.pacientes_ocupacao = item['pacientes_ocupacao'].toString();
        user.tabcep_logradouro = item['tabcep_logradouro'].toString();
        user.tabcep_municipio = item['tabcep_municipio'].toString();
        user.tabcep_bairro = item['tabcep_bairro'].toString();
        user.tabcep_cep = item['tabcep_cep'].toString();
        user.tabcep_uf = item['tabcep_uf'].toString();
        user.tabcep_tplogradouro = item['tabcep_tplogradouro'].toString();
        user.tabcep_regional = item['tabcep_regional'].toString();
        user.tabcep_numerocep = item['tabcep_numerocep'].toString();
        user.tabcep_codlogradouro = item['tabcep_codlogradouro'].toString();
        //   user.primeiroatendimento = item['primeiroatendimento'].toString();
        //   user.ultimoatendimento = item['ultimoatendimento'].toString();
        //  user.ultimoatendimentoemanos =
        //    item['ultimoatendimentoemanos'].toString();
        // user.primeiroatendimentoemanos =
        item['primeiroatendimentoemanos'].toString();
        user.datanascimentopaciente = item['datanascimentopaciente'].toString();
        user.idade = item['idade'].toString();

        _items.add(user);
      },
    ).toList();

    notifyListeners();
  }

  Future<String> IndicacaoAmigosBioma(Usuario user, Fidelimax fidelimax) async {
    //debugPrint(cpf);
    var idnuagendado = '';

    _items.clear();

    Map<String, String> param = {
      'cpf': fidelimax.cpf,
      'cpf_amigo': user.pacientes_cpf,
      'nome_amigo': user.pacientes_nomepaciente,
      'telefone_amigo': user.pacientes_tel_whatsapp,
      'email_amigo': user.pacientes_email,
      'nova_indicacao': user.pacientes_id,
    };

    var link = Constants.INDICAR_AMIGO_BIOMA + '' + Constants.AUT_BASE;

    //print(link.toString());
    final response = await http.post(Uri.parse(link),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Charset': 'utf-8'
        },
        body: param,
        encoding: Encoding.getByName("utf-8"));

    if (response.body == 'null') return '';
    //print(response.body);
    var agendamentolist = await jsonDecode(response.body)['dados'];

    await agendamentolist.map(
      (item) {
        idnuagendado = item['id'].toString();
        //  _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();
    //Set<String> medicosInclusoIncluso = Set();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //  notifyListeners();
    return idnuagendado;

    notifyListeners();
  }

  Future<Usuario> VerificaOuCriaPaciente(
      Usuario user, Fidelimax fidelimax) async {
    //debugPrint(cpf);
    var pacientes_id = '';

    //  _items.clear();

    Map<String, String> param = {
      'cpf': fidelimax.cpf,
      'cpf_amigo': user.pacientes_cpf,
      'nome_amigo': user.pacientes_nomepaciente,
      'telefone_amigo': user.pacientes_tel_whatsapp,
      'email_amigo': user.pacientes_email,
    };

    var link = Constants.VerificaOuCriaPaciente + '' + Constants.AUT_BASE;
    //print(link);

    final response = await http.post(Uri.parse(link),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Charset': 'utf-8'
        },
        body: param,
        encoding: Encoding.getByName("utf-8"));

    if (response.body == 'null') return Usuario();
    List agendamentolist = await jsonDecode(response.body)['dados'];
    Usuario NewUser = Usuario();
    await agendamentolist.map(
      (item) {
        NewUser.pacientes_id = item['pacientes_id'].toString();
        NewUser.pacientes_cpf = item['pacientes_cpf'].toString();
        NewUser.pacientes_nomepaciente =
            item['pacientes_nomepaciente'].toString();
        NewUser.pacientes_datanascimento =
            item['pacientes_datanascimento'].toString();
        NewUser.pacientes_sexo = item['pacientes_sexo'].toString();
        NewUser.pacientes_codendereco =
            item['pacientes_codendereco'].toString();
        NewUser.pacientes_nr = item['pacientes_nr'].toString();
        NewUser.pacientes_tel_whatsapp =
            item['pacientes_tel_whatsapp'].toString();
        NewUser.pacientes_celular = item['pacientes_celular'].toString();
        NewUser.pacientes_telefone = item['pacientes_telefone'].toString();
        NewUser.pacientes_email = item['pacientes_email'].toString();
        NewUser.pacientes_ocupacao = item['pacientes_ocupacao'].toString();
        NewUser.tabcep_logradouro = item['tabcep_logradouro'].toString();
        NewUser.tabcep_municipio = item['tabcep_municipio'].toString();
        NewUser.tabcep_bairro = item['tabcep_bairro'].toString();
        NewUser.tabcep_cep = item['tabcep_cep'].toString();
        NewUser.tabcep_uf = item['tabcep_uf'].toString();
        NewUser.tabcep_tplogradouro = item['tabcep_tplogradouro'].toString();
        NewUser.tabcep_regional = item['tabcep_regional'].toString();
        NewUser.tabcep_numerocep = item['tabcep_numerocep'].toString();
        NewUser.tabcep_codlogradouro = item['tabcep_codlogradouro'].toString();
        //   user.primeiroatendimento = item['primeiroatendimento'].toString();
        //   user.ultimoatendimento = item['ultimoatendimento'].toString();
        //  user.ultimoatendimentoemanos =
        //    item['ultimoatendimentoemanos'].toString();
        // user.primeiroatendimentoemanos =
        //  item['primeiroatendimentoemanos'].toString();
        NewUser.datanascimentopaciente =
            item['datanascimentopaciente'].toString();
        NewUser.idade = item['idade'].toString();
        //  _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();
    //Set<String> medicosInclusoIncluso = Set();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //  notifyListeners();
    return NewUser;

    notifyListeners();
  }
}
