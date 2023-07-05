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
        user.id = item['id'].toString();
        user.cpf = item['cpf'].toString();
        user.nome = item['nome'].toString();
        user.datanascimento = item['datanascimento'].toString();
        user.sexo = item['sexo'].toString();
        user.codendereco = item['codendereco'].toString();
        user.nr = item['nr'].toString();
        user.tel_whatsapp = item['tel_whatsapp'].toString();
        user.celular = item['celular'].toString();
        user.telefone = item['telefone'].toString();
        user.email = item['email'].toString();
        user.ocupacao = item['ocupacao'].toString();
        user.logradouro = item['logradouro'].toString();
        user.municipio = item['municipio'].toString();
        user.bairro = item['bairro'].toString();
        user.cep = item['cep'].toString();
        user.uf = item['uf'].toString();
        user.tplogradouro = item['tplogradouro'].toString();
        user.regional = item['regional'].toString();
        user.numerocep = item['numerocep'].toString();
        user.codlogradouro = item['codlogradouro'].toString();
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
      'cpf_amigo': user.cpf,
      'nome_amigo': user.nome,
      'telefone_amigo': user.tel_whatsapp,
      'email_amigo': user.email,
      'nova_indicacao': user.id,
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
    var id = '';

    //  _items.clear();

    Map<String, String> param = {
      'cpf': fidelimax.cpf,
      'cpf_amigo': user.cpf,
      'nome_amigo': user.nome,
      'telefone_amigo': user.tel_whatsapp,
      'email_amigo': user.email,
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
        NewUser.id = item['id'].toString();
        NewUser.cpf = item['cpf'].toString();
        NewUser.nome = item['nomepaciente'].toString();
        NewUser.datanascimento = item['datanascimento'].toString();
        NewUser.sexo = item['sexo'].toString();
        NewUser.codendereco = item['codendereco'].toString();
        NewUser.nr = item['nr'].toString();
        NewUser.tel_whatsapp = item['tel_whatsapp'].toString();
        NewUser.celular = item['celular'].toString();
        NewUser.telefone = item['telefone'].toString();
        NewUser.email = item['email'].toString();
        NewUser.ocupacao = item['ocupacao'].toString();
        NewUser.logradouro = item['logradouro'].toString();
        NewUser.municipio = item['municipio'].toString();
        NewUser.bairro = item['bairro'].toString();
        NewUser.cep = item['cep'].toString();
        NewUser.uf = item['uf'].toString();
        NewUser.tplogradouro = item['tplogradouro'].toString();
        NewUser.regional = item['regional'].toString();
        NewUser.numerocep = item['numerocep'].toString();
        NewUser.codlogradouro = item['codlogradouro'].toString();
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
