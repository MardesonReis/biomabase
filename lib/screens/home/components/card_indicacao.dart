import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class cardIndicacao extends StatefulWidget {
  cardIndicacao({Key? key}) : super(key: key);

  @override
  State<cardIndicacao> createState() => _cardIndicacaoState();
}

class _cardIndicacaoState extends State<cardIndicacao> {
  bool _isLoading = false;
  String? _selectedAnimal;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  List<Usuario> mockResults = <Usuario>[];
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    @override
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    bool _isIndicacao = auth.filtrosativos.usuarios.isEmpty;

    UsuariosList paciente = Provider.of(context);

    // mockResults = auth.filtrosativos.pacientes;

    Future<void> buscarpaciente(String query) async {
      var lowercaseQuery = query;
      mockResults
          .where((profile) {
            return true;
            //return profile.cpf.contains(query) || profile.cpf.contains(query);
          })
          .toList(growable: false)
          .sort((a, b) => a.nome
              .indexOf(lowercaseQuery)
              .compareTo(b.nome.indexOf(lowercaseQuery)));
    }

    ;
    Future<void> buscarQuery(String cpf) async {
      mockResults.clear();

      cpf = cpf.toString().replaceAll('.', '').replaceAll('-', '');

      if (cpf.length <= 0) {
        setState(() {
          debugPrint(cpf.length.toString());
          mockResults.clear();
          _isLoading = false;
        });
      } else {
        setState(() {
          Usuario user = Usuario();

          mockResults.add(user);
        });
        _isLoading = false;
      }
      ;
      if (cpf.length == 11) {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<UsuariosList>(
          context,
          listen: false,
        ).loadPacientes(cpf).then((value) {
          if (paciente.items.length > 0) {
            mockResults.clear();
            setState(() {
              paciente.items
                  .map((e) => {
                        mockResults.add(e),
                      })
                  .toList();
              _isLoading = false;
            });
          } else {
            setState(() {
              Usuario user = Usuario();
              mockResults.add(user);
            });
            _isLoading = false;
          }
        });
      }
      ;
    }

    // _isLoading = false;

    filtros.usuarios.isNotEmpty
        ? () {
            txtQuery.text =
                UtilBrasilFields.obterCpf(filtros.usuarios.first.cpf);
            //    buscarQuery.call(filtros.usuarios.first.cpf);
            mockResults.add(filtros.usuarios.first);
            //  _isLoading = false;
          }.call()
        : true;

    return Container(
      // height: 500,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Text(
                    'Para quem você quer indicar um serviço ? ',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('Busque um contato por CPF ou Cadastre um novo usuário ',
                      style: Theme.of(context).textTheme.caption),
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              TextFormField(
                                inputFormatters: [
                                  // obrigatório
                                  FilteringTextInputFormatter.digitsOnly,
                                  CpfOuCnpjFormatter(),
                                ],
                                keyboardType: TextInputType.number,
                                controller: txtQuery,
                                // initialValue: filtros.usuarios.isNotEmpty
                                //     ? filtros.usuarios.first.cpf
                                //     : '',

                                onChanged: buscarQuery,
                                decoration: InputDecoration(
                                  hintText: "Cpf",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      setState(() {
                                        buscarQuery(txtQuery.text);
                                      });
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      txtQuery.text = '';
                                      setState(() {
                                        mockResults.clear();
                                        filtros.LimparUsuarios();
                                        //buscarQuery(txtQuery.text);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              mockResults.isEmpty
                                  ? Text('')
                                  : _isLoading
                                      ? Center(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(),
                                              ]),
                                        )
                                      : _listView(mockResults, context)
                            ],
                          ),
                        ),
                        // Text(mockResults.length.toString()),
                      ]),
                  // TextFormField(
                  //   inputFormatters: [
                  //     // obrigatório
                  //     FilteringTextInputFormatter.digitsOnly,
                  //     CpfInputFormatter(),
                  //   ],
                  //   decoration: InputDecoration(labelText: 'CPF'),
                  //   keyboardType: TextInputType.number,
                  //   obscureText: false,
                  //   //    onSaved: (cpf) => cpf ?? '',
                  //   validator: (_cpf) {
                  //     final cpf = _cpf ?? '';
                  //     if (cpf.trim().isEmpty || cpf.length < 11) {
                  //       return 'Informe um CPF válido. Apenas números!';
                  //     }
                  //     return null;
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _listView(List<Usuario> mockResults, BuildContext context) {
  Auth auth = Provider.of(context);
  Paginas pages = auth.paginas;

  filtrosAtivos filtros = auth.filtrosativos;
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.08,
    child: Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: mockResults.length,
              itemBuilder: (context, index) {
                var person = mockResults[index];

                if (person.cpf == '1') {
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.all(1),
                            child: SingleChildScrollView(
                              child: ListTile(
                                  leading: const Icon(Icons.contacts),
                                  title: Text(
                                    'Para Mim',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(''),
                                  onTap: () async {
                                    await pages
                                        .selecionarPaginaHome('Especialistas');
                                    await filtros.LimparUsuarios();
                                    Usuario user = Usuario();
                                    user.cpf = auth.fidelimax.cpf.toString();
                                    await filtros.addUsuarios(user);
                                    Navigator.of(context).pushReplacementNamed(
                                      AppRoutes.AUTH_OR_HOME,
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.all(1),
                            child: SingleChildScrollView(
                              child: ListTile(
                                  leading: const Icon(Icons.person_add_sharp),
                                  title: Text(
                                    'Novo Amigo',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(''),
                                  onTap: () => Navigator.of(context)
                                          .pushReplacementNamed(
                                        AppRoutes.AddUser,
                                      )),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                } else {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(person.nome[0]),
                    ),
                    title: Text(person.nome),
                    subtitle: Text("" + person.cpf),
                    onTap: () async {
                      await pages.selecionarPaginaHome('Especialistas');
                      await filtros.LimparUsuarios();
                      await filtros.addUsuarios(person);
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutes.AUTH_OR_HOME,
                      );
                    },
                  );
                }

                // ListTile(
                //   leading: CircleAvatar(
                //     child: Text(person.nomepaciente[0]),
                //   ),
                //   title: Text(person.nomepaciente),
                //   subtitle: Text("CPF: " + person.cpf),
                //   onTap: () {
                //     print(mockResults[index].nomepaciente);
                //   },
                // );
              }),
        ),
      ],
    ),
  );
}
