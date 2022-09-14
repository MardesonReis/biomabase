import 'dart:async';
import 'dart:convert';

import 'package:biomaapp/models/extrato.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/auth_exception.dart';

class Fidelimax with ChangeNotifier {
  String? _nome;
  String _cpf = '';
  String? _sexo;
  String? _email;
  String? _dataNascimento;
  String? _telefone;
  Usuario usuario = Usuario();
  Usuario parceiro = Usuario();
  double? _saldo;
  double? _pontos_expirar;
  double? _cashback;
  String? _categoria;
  List<Procedimento> _produtos = [];
  List<Extrato> _extrato = [];

  set extrato(List<Extrato> extrato) {
    _extrato = extrato;
  }

  String get nome {
    return _nome ?? '';
  }

  set nome(String nome) {
    _nome = nome;
  }

  set cpf(String cpf) {
    _cpf = cpf;
  }

  set sexo(String sexo) {
    _sexo = sexo;
  }

  set email(String email) {
    _email = email;
  }

  set dataNascimento(String dataNascimento) {
    _dataNascimento = dataNascimento;
  }

  set telefone(String telefone) {
    _telefone = telefone;
  }

  set saldo(double saldo) {
    _saldo = saldo;
  }

  set pontos_expirar(double pontos_expirar) {
    _pontos_expirar = pontos_expirar;
  }

  set cashback(double cashback) {
    _cashback = cashback;
  }

  set categoria(String categoria) {
    _categoria = categoria;
  }

  set produto(List<Procedimento> protudo) {
    _produtos = protudo;
  }

  String get cpf {
    return _cpf;
  }

  String get sexo {
    return _sexo ?? '';
  }

  String get email {
    return _email ?? '';
  }

  String get dataNascimento {
    return _dataNascimento ?? '';
  }

  String get telefone {
    return _telefone ?? '';
  }

  double get saldo {
    return _saldo ?? 0;
  }

  double get pontos_expirar {
    return _pontos_expirar ?? 0;
  }

  double get cashback {
    return _cashback ?? 0;
  }

  String get categoria {
    return _categoria ?? '';
  }

  List<Procedimento> get produtos => [..._produtos];
  List<Extrato> get extrato => [..._extrato];

  Future<String> authenticateFidelimax() async {
    final url = Constants.FIDELIMAX_API +
        'CredenciaisConsumidor/' +
        '' +
        Constants.AUT_BASE;
    print(url);
    Map parans = {
      "cpf": this._cpf,
      "senha": this.cpf.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Charset': 'utf-8'
        },
        body: parans,
      );
      print('Body: ' + response.body.toString());
      final body = jsonDecode(response.body)['dados'];

      if (body['CodigoResposta'] == 100) {
        //    this._cpf = this._cpf;
        // print("Cadastro Fidelimax Encontrado");
        //this._cpf = await this.ConsultaConsumidor();
        //  await this.ExtratoConsumidor();

      } else {
        this._cpf = '';
        // print("Cadastro Fidelimax não Encontrado");
        // throw AuthException(body['CodigoResposta'].toString());
      }
    } catch (e) {
      print(e.toString());
    }

    //    _autoLogout();

    notifyListeners();
    return this._cpf;
  }

  Future<String> IndicarAmigoFidelimax(Usuario usuario) async {
    Map parans = {
      "cpf": this._cpf,
      "amigo_nome": usuario.pacientes_nomepaciente,
      "amigo_email": usuario.pacientes_email,
      "amigo_celular": usuario.pacientes_telefone,
      "cartao": usuario.pacientes_id
    };

    final response = await http.post(
      Uri.parse(Constants.INDICAR_AMIGO_FIDEMIMAX),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Charset': 'utf-8'
      },
      body: parans,
    );
    final body = jsonDecode(response.body)['dados'];

    notifyListeners();
    return body['amigo_participa_programa'].toString();
  }

  Future<String> ConsultaConsumidor() async {
    print('Teste Cpf: ' + this._cpf);
    final url = Constants.FIDELIMAX_API +
        'ConsultaConsumidor' +
        '' +
        Constants.AUT_BASE;

    Map parans = {
      "cpf": this.cpf,
      "categoria": 'true',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Charset': 'utf-8'
      },
      body: parans,
    );
    final body = jsonDecode(response.body)['dados'];

    //  if (body['CodigoResposta'] == 103) {
    //    throw AuthException(body['CodigoResposta'].toString());
    //    print("CPF Inesexistente");
    //    notifyListeners();
    //    return this;
    //  }

    if (body['CodigoResposta'] == 100) {
      this.saldo = double.parse(body['saldo'].toString());
      this.nome = body['nome'].toString();
      this.pontos_expirar = double.parse(body['pontos_expirar'].toString());
      this.cashback = double.parse(body['cashback'].toString());
      this.categoria = body['categoria'].toString();
    } else {
      this._cpf = '';
      //  print("Cadastro Fidelimax não Encontrado");
      //     throw AuthException(body['CodigoResposta'].toString());

    }

    //    _autoLogout();

    notifyListeners();
    return this._cpf;
  }

  Future<Fidelimax> RetornaDadosCliente() async {
    Constants.AGENDA_MEDICO_BASE_URL;
    final url = Constants.FIDELIMAX_API +
        'RetornaDadosCliente' +
        '' +
        Constants.AUT_BASE;

    Map parans = {
      "cpf": this._cpf,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Charset': 'utf-8'
      },
      body: parans,
    );

    final body = jsonDecode(response.body)['dados'];

    if (body['CodigoResposta'] == 100) {
      this.usuario.pacientes_nomepaciente = body['nome'].toString();
      this.usuario.pacientes_celular = body['telefone'].toString();
      this.usuario.pacientes_cpf = this._cpf;
      this.usuario.pacientes_email = body['email'].toString();

      this.nome = body['nome'].toString();
      this.sexo = body['sexo'].toString();
      this.dataNascimento = body['data_nascimento'].toString();
      this.email = body['email'].toString();
      this.telefone = body['telefone'].toString();

      this.categoria = body['categoria'].toString();
    } else {}

    //    _autoLogout();

    notifyListeners();
    return this;
  }

  Future<Fidelimax> ExtratoConsumidor() async {
    final url =
        Constants.FIDELIMAX_API + 'ExtratoConsumidor' + Constants.AUT_BASE;

    print(url);

    Map parans = {"cpf": this._cpf, "skip": "0", "take": "50"};

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Charset': 'utf-8'
      },
      body: parans,
    );

    final body = jsonDecode(response.body)['dados'];

    //  if (body['CodigoResposta'] == 103) {
    //    throw AuthException(body['CodigoResposta'].toString());
    //    print("CPF Inesexistente");
    //    notifyListeners();
    //    return this;
    //  }

    if (body['CodigoResposta'] == 100) {
      _extrato.clear();
      this.saldo = double.parse(body['saldo'].toString());
      List ex = body['extrato'];

      ex.map((item) {
        // debugPrint(item['credito'].toString());
        _extrato.add(Extrato(
            credito: item['credito'].toString(),
            debito: item['debito'].toString(),
            premio_nome: item['premio_nome'].toString(),
            premio_identificador: item['premio_identificador'].toString(),
            voucher: item['voucher'].toString(),
            voucher_resgatado: item['voucher_resgatado'].toString(),
            data_pontuacao: item['data_pontuacao'],
            data_expiracao: item['data_expiracao'],
            verificador: item['verificador'].toString(),
            tipo_compra: item['tipo_compra'].toString(),
            loja: item['loja'].toString(),
            tipo_pontuacao: item['tipo_pontuacao'].toString()));
      }).toList();

      //this.extrato = body;

    } else {
      this._cpf = '';
      throw AuthException(body['CodigoResposta'].toString());
    }

    //    _autoLogout();

    //   notifyListeners();
    return this;
  }

  Future<Fidelimax> createFidelimax() async {
    final url = Constants.FIDELIMAX_API +
        'CadastrarConsumidor/' +
        '' +
        Constants.AUT_BASE;

    Map parans = {
      "nome": this.nome,
      "cpf": this.cpf,
      "sexo": this.sexo,
      "email": this.email,
      "nascimento": this.dataNascimento,
      "telefone": this.telefone
    };
    //debugPrint(this.email);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Charset': 'utf-8'
      },
      body: parans,
    );
    print('Response: ' + response.body);
    final body = jsonDecode(response.body)['dados'];

    if (body['CodigoResposta'] == 103) {
      // print("CPF Inesexistente");
      //     throw AuthException(body['CodigoResposta'].toString());
    }

    if (body['CodigoResposta'] == 100) {
      this._cpf = this.cpf;

      //  print("Cadastro Fidelimax com sucesso");
    } else {
      this._cpf = '';
      // print("Cadastro Fidelimax deu erro");

      // throw AuthException(body['CodigoResposta'].toString());
    }

    //    _autoLogout();

    //notifyListeners();
    return this;
  }

  Future<String> ListCpfFidelimax(String _userId, String _token) async {
    //debugPrint('${Constants.CPF_BASE_URL}/$_userId.json?auth=$_token');
    var link = '${Constants.CPF_BASE_URL}/$_userId.json?auth=$_token';

    final cpfResponse = await http.get(
      Uri.parse(link),
      //  headers: headers
    );

    Map<String, dynamic> cpfData =
        cpfResponse.body == 'null' ? {} : jsonDecode(cpfResponse.body);

    cpfData.forEach((cpftId, cpf) {
      this._cpf = cpf['cpf'].toString().isNotEmpty ? cpf['cpf'].toString() : '';
    });
    return this._cpf;
  }

  notifyListeners();
}
