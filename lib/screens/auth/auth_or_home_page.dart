import 'dart:async';

import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/screens/auth/auth_page_fi.dart';
import 'package:biomaapp/screens/pedidos/navaIndicacao.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';

//import 'package:biomaapp/pages/products_overview_page.dart';
//import 'package:biomaapp/pages/procedimentos_overview_page';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class AuthOrHomePage extends StatefulWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  Uri? _latestUri;
  Object? _err;
  bool _isLogin = true;
  bool _isLoadingRegras = true;

  StreamSubscription? _sub;

  final _scaffoldKey = GlobalKey();

  final _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    var regraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    //13978829304
    auth.atualizaAcesso(context, () {
      setState(() {
        _isLogin = false;
      });
    });

    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Manipula os links de entrada - aqueles que o aplicativo receberá do SO
  /// /// enquanto já iniciado.
  void _handleIncomingLinks() async {
    if (!kIsWeb) {
      // Ele lidará com links de aplicativos enquanto o aplicativo já estiver iniciado - seja em
      // o primeiro plano ou em segundo plano.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          if (uri != null) {
            _latestUri = uri;
          }
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  /// Manipula o Uri inicial - aquele com o qual o aplicativo foi iniciado
  ///
  /// **ATENÇÃO**: `getInitialLink`/`getInitialUri` deve ser tratado
  /// SOMENTE UMA VEZ durante a vida útil do seu aplicativo, pois ele não deve ser alterado
  /// ao longo da vida do seu aplicativo.
  ///
  /// Tratamos todas as exceções, pois é chamado de initState.
  Future<void> _handleInitialUri() async {
// Neste aplicativo de exemplo, este é um guarda quase inútil, mas está aqui para
    // mostra que não vamos chamar getInitialUri várias vezes, mesmo que isso
    // foi um weidget que será descartado (por exemplo, uma mudança de rota de navegação).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      //     showSnackBar('_handleInitialUri called', context);
      try {
        await getInitialUri().then((uri) {
          if (!mounted) return;
          if (uri == null) {
            //   print('no initial uri');
          } else {
            //  print('got initial uri: $uri');
            if (!mounted) return;
            setState(() => _latestUri = uri);
          }
        });
      } on PlatformException {
        // As mensagens da plataforma podem falhar, mas ignoramos a exceção
        //  print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        // print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    @override
    Auth auth = Provider.of(context);
    var body;
    var acaos = [];
    if (_latestUri != null && _latestUri.toString().contains('?')) {
      acaos = _latestUri.toString().split('?')[1].split('=');
      auth.acoes.addAll({acaos[0]: acaos[1]});
      if (acaos[0] == 'id_indicacao') {
        body = NovaIndicacao(IdIndicacao: acaos[1]);
      }
      // } else if (auth.isAuth && auth.fidelimax.cpf == '') {
      //    body = auth.isAuth ? AuthPageFi() : AuthPage();
    } else {
      //   body = auth.isAuth && auth.fidelimax.cpf != ''
      //UtilBrasilFields.isCPFValido(auth.fidelimax.cpf) ||
      //      UtilBrasilFields.isCPFValido(auth.fidelimax.cpf)

      body = MainScreen();
      //  ? MainScreen()
      //   : AuthPage();
    }
    if (auth.isAuth && auth.fidelimax.cpf.isEmpty) {
      body = AuthPageFi();
    }

    return _isLogin
        ? Scaffold(body: Center(child: ProgressIndicatorBioma()))
        : body;
  }
}
