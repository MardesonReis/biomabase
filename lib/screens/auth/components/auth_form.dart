import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/exceptions/auth_exception.dart';
import 'package:biomaapp/models/auth.dart';

enum AuthMode { Signup, Login, Recuver }

class AuthForm extends StatefulWidget {
  VoidCallback func;
  AuthForm({Key? key, required this.func}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //final _passwordController = TextEditingController(text: '12101993');
  //final _EmailController = TextEditingController(text: 'mardeson18@gmail.com');
  final _passwordController = TextEditingController();
  final _EmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyRecuver = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'cpf': '',
  };
  Map<String, String> _authDataRecuver = {
    'email': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;
  bool _isReceuver() => _authMode == AuthMode.Recuver;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um Erro ID 2'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  recuperaSenha() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Recuperar Sneha'),
        content: Column(
          children: [
            Title(color: Colors.blue, child: Text('Informe um email')),
            Form(
              key: _formKeyRecuver,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) => _authDataRecuver['email'] = email ?? '',
                    controller: _EmailController,
                    validator: (_email) {
                      final email = _email ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um e-mail válido.';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Auth auth = Provider.of(context, listen: false);
              final isValid = _formKeyRecuver.currentState?.validate() ?? false;

              if (!isValid) {
                return;
              }

              _formKeyRecuver.currentState?.save();

              var body =
                  await auth.recoverEmail(_authDataRecuver['email'].toString());

              if (body['email'] != null) {
                Navigator.of(context).pop(true);
                AlertShowDialog(
                    'Sucesso',
                    Text('Um email de redefinição de senha foi enviado para ' +
                        body['email'].toString() +
                        '\nVerifique o SPAN'),
                    context);
              } else {
                Navigator.of(context).pop(true);
                AlertShowDialog('Erro', Text('Email não encontrado'), context);
              }
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
        //  setState(() => _isLoading = false);
      } else {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      RegrasList regrasList = Provider.of(context, listen: false);

      await auth.fidelimax
          .ListCpfFidelimax(auth.userId ?? '', auth.token ?? '');

      await auth.fidelimax
          .ConsultaConsumidor(auth.fidelimax.cpf)
          .then((value) async {
        await auth.fidelimax
            .RetornaDadosCliente(auth.fidelimax.cpf)
            .then((value) async {
          var regraList = await Provider.of<RegrasList>(
            context,
            listen: false,
          ).limparDados();
          var dados = await Provider.of<RegrasList>(
            context,
            listen: false,
          ).limparDados();

          auth.atualizaAcesso(context, () async {
            setState(() {
              _isLoading = false;
              widget.func.call();
            });
          });
        });
      });

      //if (auth.isAuth)

      //     setState(() => _isLoading = false);
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
      setState(() => _isLoading = false);
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado! ${error}');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Auth auth = Provider.of(context, listen: false);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        // height: _isLogin() ? deviceSize.height * 0.5 : deviceSize.height * 0.5,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                controller: _EmailController,
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas informadas não conferem.';
                          }
                          return null;
                        },
                ),
              if (_isSignup())
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'CPF'),
                //   keyboardType: TextInputType.number,
                //   obscureText: false,
                //   onSaved: (cpf) => _authData['cpf'] = cpf ?? '',
                //   validator: (_cpf) {
                //     final cpf = _cpf ?? '';
                //     if (cpf.trim().isEmpty || cpf.length < 11) {
                //       return 'Informe um CPF válido. Apenas números!';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(
                  height: 50,
                ),
              if (_isLoading)
                ProgressIndicatorBioma()
              else
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      _isLogin() ? 'Registar?' : 'Já possui Conta?',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      recuperaSenha();
                    },
                    child: Text(
                      'Recuperar Senha?',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
