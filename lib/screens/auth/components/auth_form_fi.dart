import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/exceptions/auth_exception.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:intl/intl.dart';

enum AuthMode { Signup, Login }

class AuthFormFi extends StatefulWidget {
  const AuthFormFi({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthFormFi> {
  final _passwordController = TextEditingController();
  final _datadeNascimentoController = TextEditingController();
  final _sexoController = TextEditingController();
  final _telefone = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? sexoSelecionado;
  DateTime? _selectedDate;

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'nome': '',
    'cpf': '',
    'sexo': '',
    'email': '',
    'dataNascimento': '',
    'telefone': ''
  };

  bool _isLogin() => _authMode == AuthMode.Login;

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um Erro ID '),
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

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    var cpf = _authData['cpf']
        .toString()
        .replaceAll('.', '')
        .replaceAll('-', '')
        .replaceAll('/', '');
    var telefone = _authData['telefone']
        .toString()
        .toString()
        .replaceAll('(', '')
        .replaceAll(' ', '')
        .replaceAll(')', '')
        .replaceAll('-', '');
    auth.fidelimax.nome = _authData['nome'] ?? '';
    auth.fidelimax.cpf = cpf;
    auth.fidelimax.sexo = _authData['sexo'] ?? '';
    auth.fidelimax.email = auth.email ?? '';
    auth.fidelimax.dataNascimento = _authData['dataNascimento'] ?? '';
    auth.fidelimax.telefone = telefone;

    try {
      auth.fidelimax.createFidelimax().then((value) async {
        auth.fidelimax = value;
        await auth.addCpfFidelimax();
        await auth.ParceiroExisteOuCria();
        setState(() {});
      });
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado! ${error}');
    }

    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
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
        height: deviceSize.height * 0.90,
        width: deviceSize.width * 0.90,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                keyboardType: TextInputType.text,
                onSaved: (nome) => _authData['nome'] = nome ?? '',
                validator: (_nome) {
                  final nome = _nome ?? '';
                  if (nome.trim().isEmpty) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  CpfOuCnpjFormatter(),
                ],
                decoration: InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                obscureText: false,
                onSaved: (cpf) => _authData['cpf'] = cpf ?? '',
                validator: (_cpf) {
                  final cpf = _cpf ?? '';

                  if (cpf.trim().isEmpty || !cpfOuCnpjValido(cpf)) {
                    return 'Informe um CPF/CNPJ válido!';
                  }
                  return null;
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                    value: sexoSelecionado,
                    icon: Icon(Icons.arrow_downward),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text('Masculino'),
                                flex: 9,
                              ),
                              Expanded(
                                child: Icon(Icons.male),
                                flex: 1,
                              )
                            ],
                          ),
                          value: "Masculino"),
                      DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text('Feminino'),
                                flex: 9,
                              ),
                              Expanded(
                                child: Icon(Icons.female),
                                flex: 1,
                              )
                            ],
                          ),
                          value: "Feminino"),
                      DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text('Outro'),
                                flex: 9,
                              ),
                              Expanded(
                                child: Icon(Icons.all_out_rounded),
                                flex: 1,
                              )
                            ],
                          ),
                          value: "O")
                    ],
                    onChanged: (value) {
                      setState(() {
                        sexoSelecionado = value;
                        _authData['sexo'] = sexoSelecionado ?? '';
                        print(_authData['sexo']);
                      });
                    },
                    validator: (_sexo) {
                      final sexo = _sexo ?? '';
                      if (sexo.trim().isEmpty || sexo == '') {
                        return 'Por Gentileza informe um genero!';
                      }
                      return null;
                    },
                    onSaved: (sexo) => setState(() {
                      _authData['sexo'] = sexo ?? '';
                    }),
                    hint: const Text('Gênero'),
                  ),
                ],
              ),
              TextFormField(
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                keyboardType: TextInputType.text,
                obscureText: false,
                controller: _datadeNascimentoController,
                onSaved: (dataNascimento) => setState(() {
                  _authData['dataNascimento'] = dataNascimento ?? '';
                }),
                validator: (_dataNascimento) {
                  final dataNascimento = _dataNascimento ?? '';

                  if (dataNascimento.isEmpty || dataNascimento.length < 10) {
                    return 'Formato Correto: ##/##/####';
                  }
                  return null;
                },
              ),
              TextFormField(
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.number,
                obscureText: false,
                controller: _telefone,
                onSaved: (telefone) => setState(() {
                  _authData['telefone'] = telefone ?? '';
                }),
                validator: (_telefone) {
                  final telefone = _telefone ?? '';

                  if (telefone.isEmpty || telefone.length < 11) {
                    return 'Formato Correto: DD#########';
                  }
                  return null;
                },
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('REGISTRAR'

                    //       _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    auth.logout();
                  });
                },
                child: Text('Cancelar'

                    //       _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
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
              Spacer(),
              Text("Último passo, seu cadastro está quase acabando."),
            ],
          ),
        ),
      ),
    );
  }
}
