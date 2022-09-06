import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

//void main() => runApp(MaterialApp(home: LinkGestor()));

class LinkGestor extends StatefulWidget {
  @override
  _LinkGestorState createState() => _LinkGestorState();
}

class _LinkGestorState extends State<LinkGestor>
    with SingleTickerProviderStateMixin {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  StreamSubscription? _sub;

  final _scaffoldKey = GlobalKey();
  final _cmds = getCmds();
  final _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);

  @override
  void initState() {
    super.initState();
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
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // Ele lidará com links de aplicativos enquanto o aplicativo já estiver iniciado - seja em
      // o primeiro plano ou em segundo plano.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
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
      _showSnackBar('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // As mensagens da plataforma podem falhar, mas ignoramos a exceção
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final queryParams = _latestUri?.queryParametersAll.entries.toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('uni_links example app'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          if (_err != null)
            ListTile(
              title: const Text('Error', style: TextStyle(color: Colors.red)),
              subtitle: Text('$_err'),
            ),
          ListTile(
            title: const Text('Initial Uri'),
            subtitle: Text('$_initialUri'),
          ),
          if (!kIsWeb) ...[
            ListTile(
              title: const Text('Latest Uri'),
              subtitle: Text('$_latestUri'),
            ),
            ListTile(
              title: const Text('Latest Uri (path)'),
              subtitle: Text('${_latestUri?.path}'),
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Latest Uri (query parameters)'),
              children: queryParams == null
                  ? const [ListTile(dense: true, title: Text('null'))]
                  : [
                      for (final item in queryParams)
                        ListTile(
                          title: Text(item.key),
                          trailing: Text(item.value.join(', ')),
                        )
                    ],
            ),
          ],
          _cmdsCard(_cmds),
          const Divider(),
          if (!kIsWeb)
            ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: const Text(
                'Force quit this example app',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // AVISO: NÃO USE isso em produção !!!
                // Seu aplicativo será (provavelmente) rejeitado !!!
                if (Platform.isIOS) {
                  exit(0);
                } else {
                  SystemNavigator.pop();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _cmdsCard(List<String>? commands) {
    Widget platformCmds;

    if (commands == null) {
      platformCmds = const Center(child: Text('Plataforma não compatível'));
    } else {
      platformCmds = Column(
        children: [
          const [
            if (kIsWeb)
              Text(
                  'Anexe este caminho ao URL do aplicativo Web, substituindo `#/`:\n')
            else
              Text(
                  'Para preencher os campos acima, abra um shell de terminal e execute:\n'),
          ],
          intersperse(
              commands.map<Widget>((cmd) => InkWell(
                    onTap: () => _printAndCopy(cmd),
                    child: Text('\n$cmd\n', style: _cmdStyle),
                  )),
              const Text('or')),
          [
            Text(
              '(toque em qualquer um dos comandos acima para imprimi-lo'
              ' o console/logger e copie para a área de transferência do dispositivo.)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ]
        ].expand((el) => el).toList(),
      );
    }

    return Card(
      margin: const EdgeInsets.only(top: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: platformCmds,
      ),
    );
  }

  Future<void> _printAndCopy(String cmd) async {
    print(cmd);

    await Clipboard.setData(ClipboardData(text: cmd));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copiar para área de transferência')),
    );
  }

  void _showSnackBar(String msg) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _scaffoldKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
        ));
      }
    });
  }
}

List<String>? getCmds() {
  late final String cmd;
  var cmdSuffix = '';

  const plainPath = 'path/subpath';
  const args = 'path/portion/?uid=123&token=abc';
  const emojiArgs =
      '?arr%5b%5d=123&arr%5b%5d=abc&addr=1%20Nowhere%20Rd&addr=Rand%20City%F0%9F%98%82';

  if (kIsWeb) {
    return [
      plainPath,
      args,
      emojiArgs,

// Não é possível criar url malformado, pois o navegador garantirá que seja válido
    ];
  }

  if (Platform.isIOS) {
    cmd = '/usr/bin/xcrun simctl openurl booted';
  } else if (Platform.isAndroid) {
    cmd = '\$ANDROID_HOME/platform-tools/adb shell \'am start'
        ' -a android.intent.action.VIEW'
        ' -c android.intent.category.BROWSABLE -d';
    cmdSuffix = "'";
  } else {
    return null;
  }

  // https://orchid-forgery.glitch.me/mobile/redirect/
  return [
    '$cmd "unilinks://host/$plainPath"$cmdSuffix',
    '$cmd "unilinks://example.com/$args"$cmdSuffix',
    '$cmd "unilinks://example.com/$emojiArgs"$cmdSuffix',
    '$cmd "unilinks://@@malformed.invalid.url/path?"$cmdSuffix',
  ];
}

List<Widget> intersperse(Iterable<Widget> list, Widget item) {
  final initialValue = <Widget>[];
  return list.fold(initialValue, (all, el) {
    if (all.isNotEmpty) all.add(item);
    all.add(el);
    return all;
  });
}
