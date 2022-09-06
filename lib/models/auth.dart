import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/paginas.dart';
import 'Clips.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/data/store.dart';
import 'package:biomaapp/exceptions/auth_exception.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/Clips.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  Fidelimax? _fidelimax = new Fidelimax();
  filtrosAtivos? _filtros = new filtrosAtivos();
  Paginas? _pgs = new Paginas();
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  Paginas get paginas {
    return this._pgs ?? Paginas();
  }

  Fidelimax get fidelimax {
    return this._fidelimax ?? Fidelimax();
  }

  set fidelimax(Fidelimax fidelimax) {
    this._fidelimax = fidelimax;
  }

  filtrosAtivos get filtrosativos {
    return this._filtros ?? filtrosAtivos();
  }

  set filtrosativos(filtrosAtivos filtrosativos) {
    this._filtros = filtrosativos;
  }

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  Future<bool> get isAuthFidelimax async {
    var isValid;
    await this.fidelimax.ConsultaConsumidor().then((value) {});
    return this.fidelimax.cpf.isEmpty ? false : true;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBWag_wpHlbf4um3QxdMO9UFLX6i0-Ha0s';
    final response = await http.post(
      Uri.parse(url),
      //   headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      await this.fidelimax.ListCpfFidelimax(this._userId!, this._token!);
      //   await this.ParceiroExisteOuCria();

      if (await this.fidelimax.authenticateFidelimax() != '') {
        await this.fidelimax.ConsultaConsumidor();
        await this.ParceiroExisteOuCria();
      } else {
        this.fidelimax.cpf = '';
      }
      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'cpf': this.fidelimax.cpf.toString(),
        'fidelimax': this.fidelimax.cpf.toString(),
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> recoverEmail(String email, String urlFragment) async {
    Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBWag_wpHlbf4um3QxdMO9UFLX6i0-Ha0s';
    print(url);
    final response = await http.post(
      Uri.parse(url),
      //   headers: headers,
      body: jsonEncode({
        'email': email,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return;
    _token = userData['token'].toString();
    _email = userData['email'].toString();
    _userId = userData['userId'].toString();
    //_fidelimax = userData['fidelimax'];
    _expiryDate = expiryDate;

    await this.fidelimax.ListCpfFidelimax(this._userId!, this._token!);
    if (await this.fidelimax.authenticateFidelimax() != '') {
      await this.fidelimax.ConsultaConsumidor();
      await this.ParceiroExisteOuCria();
      if (this.fidelimax.parceiro.pacientes_id != '') {
        await this.ParceiroExisteOuCria();
      }
    } else {
      this.fidelimax.cpf = '';
    }

    _autoLogout();
    notifyListeners();
    //await this.ParceiroExisteOuCria();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;

    this.fidelimax.cpf = '';
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    //  print(timeToLogout);
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }

  Future<void> addCpfFidelimax() async {
    Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};

    final response = await http.post(
      Uri.parse('${Constants.CPF_BASE_URL}/$_userId.json?auth=$_token'),
      //    headers: headers,
      body: jsonEncode(
        {
          "cpf": this.fidelimax.cpf,
        },
      ),
    );
    debugPrint(response.body);
    final id = jsonDecode(response.body);

    notifyListeners();
  }

  Future<void> ParceiroExisteOuCria() async {
    //   debugPrint(this.fidelimax.cpf);
    var get = '' +
        '&pa_tipo_parceiro=BiomaApp' +
        '&pa_descricao_parceiro=' +
        this.fidelimax.nome +
        '&pa_contato_parceiro=' +
        this.fidelimax.nome +
        '&pa_cnpj_parceiro=' +
        this.fidelimax.cpf +
        '&pa_telefone_parceiro=' +
        this.fidelimax.telefone +
        '&pa_email=' +
        this.fidelimax.email +
        '';

    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};

    var link = Constants.USUARIOS_BASE_URL +
        'VerificaOuCriaParceiro/' +
        Constants.AUT_BASE +
        get;
    // print(link.toString());
    final response = await http.get(
      Uri.parse(link),
    );

    // debugPrint(response.body);
    if (response.body == 'null') return;

    List listmedicos = jsonDecode(response.body)['dados'];
    //Set<String> medicosInclusoIncluso = Set();
    if (listmedicos.isEmpty) return;

    listmedicos.map(
      (item) {
        this.fidelimax.parceiro.pacientes_id = item['id_parceiro'].toString();
        // _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    notifyListeners();
  }
}
