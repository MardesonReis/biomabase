import 'dart:async';
import 'dart:convert';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/BottonMenuMinhaSaudePages.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/data/store.dart';
import 'package:biomaapp/exceptions/auth_exception.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  Map<String, String> acoes = {};

  Fidelimax fidelimax = new Fidelimax();
  filtrosAtivos? _filtros = new filtrosAtivos();
  Paginas? _pgs = new Paginas();
  BottonMenuMinhaSaudePages? BottonMinhaSaude = new BottonMenuMinhaSaudePages();
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  Paginas get paginas {
    return this._pgs ?? Paginas();
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

  bool get isAuthFidelimax {
    return this.fidelimax.cpf.isNotEmpty;
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

  Future<void> atualizaAcesso(BuildContext context, VoidCallback press) async {
    var regraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    if (ListUnidade.items.isEmpty) {
      await ListUnidade.loadUnidades('0').then((value) {});
    }

    await this.tryAutoLogin().then((value) async {
      if (this.isAuth &&
          (this.fidelimax.cpf.trim().isEmpty || this.fidelimax.nome.isEmpty)) {
        await getico('assets/icons/bioma_maps.png', () {}, this.filtrosativos)
            .then((value) {
          this.filtrosativos.markerIcon = value;
          //  press.call();
        });
        this
            .fidelimax
            .ListCpfFidelimax(this.userId ?? '', this.token ?? '')
            .then((value) async {
          this.fidelimax.cpf = value;
          //  press.call();

          await this.fidelimax.ConsultaConsumidor(value).then((value2) async {
            this.fidelimax.cpf = value;

            await this
                .fidelimax
                .RetornaDadosCliente(this.fidelimax.cpf)
                .then((value) async {
              this.fidelimax = value;
              press.call();
            });
          });
        });
      } else {
        press.call();
      }
    });
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

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'cpf':
            await this.fidelimax.ListCpfFidelimax(_userId ?? '', _token ?? ''),
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<dynamic> recoverEmail(String email) async {
    Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=' +
            Constants.KAY;
    final response = await http.post(
      Uri.parse(url),
      //   headers: headers,
      body: jsonEncode({'requestType': 'PASSWORD_RESET', 'email': email}),
    );

    final body = jsonDecode(response.body);
    //  print(response.body);
    return body;
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
    fidelimax.cpf = userData['cpf'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    //await this.ParceiroExisteOuCria();
  }

  Future<void> logout() async {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    fidelimax = Fidelimax();
    //fidelimax.dispose();

    _clearLogoutTimer();
    await Store.remove('userData').then((_) {
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

  Future<String> addCpfFidelimax() async {
    Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};
    var link = '${Constants.CPF_BASE_URL}/$_userId.json?auth=$_token';
    //print(link);
    final response = await http.post(
      Uri.parse(link),
      //    headers: headers,
      body: jsonEncode(
        {
          "cpf": this.fidelimax.cpf,
        },
      ),
    );
    // print(response.body.toString());
    final id = jsonDecode(response.body);

    notifyListeners();

    return id['name'].toString();
  }

  Future<String> ParceiroExisteOuCria() async {
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
    print(link.toString());
    final response = await http.get(
      Uri.parse(link),
    );

    //debugPrint(response.body);
    if (response.body == 'null') return '';

    List listmedicos = jsonDecode(response.body)['dados'];
    //Set<String> medicosInclusoIncluso = Set();
    if (listmedicos.isEmpty) return '';

    listmedicos.map(
      (item) {
        this.fidelimax.parceiro.id = item['id_parceiro'].toString();
        // _items.add(Fila());
        //     item['crm'].toString(),
      },
    ).toList();

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    notifyListeners();

    return this.fidelimax.parceiro.id;
  }
}
