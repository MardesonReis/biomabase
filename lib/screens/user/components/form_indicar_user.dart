import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/screens/user/user_page.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/exceptions/auth_exception.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:intl/intl.dart';

enum AuthMode { Signup, Login }

class FormIndicaUser extends StatefulWidget {
  const FormIndicaUser({Key? key}) : super(key: key);

  @override
  _FormIndicaUserState createState() => _FormIndicaUserState();
}

class _FormIndicaUserState extends State<FormIndicaUser> {
  final _sexoController = TextEditingController();
  final _telefone = TextEditingController();
  final _EmailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String resposta = '';
  String str = '';
  String? sexoSelecionado;
  DateTime? _selectedDate;

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'nome': '',
    'cpf': '',
    'sexo': '',
    'email': '',
    'telefone': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    filtrosAtivos filtros = auth.filtrosativos;

    UsuariosList userlist = Provider.of(context, listen: false);
    var cpf = _authData['cpf']
        .toString()
        .replaceAll('.', '')
        .replaceAll('-', '')
        .replaceAll('/', '');
    var telefone = _authData['telefone']
        .toString()
        .replaceAll('(', '')
        .replaceAll(' ', '')
        .replaceAll(')', '')
        .replaceAll('-', '');

    Usuario user = Usuario();
    user.pacientes_cpf = cpf;
    user.pacientes_nomepaciente = _authData['nome'].toString();
    user.pacientes_email = _authData['email'].toString();
    user.pacientes_telefone = telefone;
    user.pacientes_tel_whatsapp = telefone;

    user.primeiroatendimento = '';

    if (UtilBrasilFields.isCPFValido(user.pacientes_cpf) ||
        UtilBrasilFields.isCNPJValido(user.pacientes_cpf)) {
      try {
        await userlist.VerificaOuCriaPaciente(user, auth.fidelimax)
            .then((NewUser) async {
          filtros.LimparUsuarios();

          filtros.addUsuarios(NewUser);
          resposta = await auth.fidelimax.IndicarAmigoFidelimax(NewUser);
          if (resposta == 'false') {
            str =
                'O amigo indicado já está cadastrado no programa de fidelidade';
          }
          if (resposta == 'true') {
            str = 'Indicação Realizada com sucesso';
          }
          var indicaAmigo =
              await userlist.IndicacaoAmigosBioma(NewUser, auth.fidelimax);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsersPage(),
            ),
          );
          showSnackBar(
              //     'Sucesso',
              NewUser.pacientes_nomepaciente + " \n" + str,
              context);
        });
      } on AuthException catch (error) {
        AlertShowDialog('Erro', error.toString(), context);
      } catch (error) {
        AlertShowDialog(
            'Ocorreu um erro inesperado!', error.toString(), context);
      }
    } else {
      AlertShowDialog(
          'CPF Inválido', 'Verifique os dados e tente novamente', context);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    Paginas pages = auth.paginas;

    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: deviceSize.height * 0.60,
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
                  if (cpf.trim().isEmpty || cpf.length < 11) {
                    return 'Informe um CPF válido. Apenas números!';
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
              Row(
                children: [
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Indicar'

                        //       _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                        ),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar')

                      //       _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                      ),
                ],
              ),
              str != ''
                  ? Container(
                      color: resposta == '100' ? primaryColor : redColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(str),
                      ),
                    )
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
