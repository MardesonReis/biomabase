import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/user/add_user.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class UsersPage extends StatefulWidget {
  final VoidCallback press;
  UsersPage({
    Key? key,
    required this.press,
  }) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  List<Usuario> mockResults = <Usuario>[];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Widget build(BuildContext context) {
    @override
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    Paginas pages = auth.paginas;

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
          .sort((a, b) => a.pacientes_nomepaciente
              .indexOf(lowercaseQuery)
              .compareTo(b.pacientes_nomepaciente.indexOf(lowercaseQuery)));
    }

    ;
    Future<void> buscarQuery(String query) async {
      filtros.LimparUsuarios();

      FocusScope.of(context).unfocus();

      if (query.isNotEmpty) {
        setState(() {
          mockResults.clear();
          _isLoading = true;
        });

        var cpf = false;
        if (UtilBrasilFields.isCPFValido(query)) {
          setState(() {
            txtQuery.text = UtilBrasilFields.obterCpf(query).toString();
            query.toString().replaceAll('.', '').replaceAll('-', '');
          });
        }

        await Provider.of<UsuariosList>(
          context,
          listen: false,
        ).loadPacientes(query).then((value) {
          if (paciente.items.length > 0) {
            mockResults.clear();
            paciente.items
                .map((e) => {
                      mockResults.add(e),
                    })
                .toList();
            _isLoading = false;
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        });
      } else {
        showSnackBar(Text('Informe termos para busca'), context);
      }
    }

    Future<void> ParaMim() async {
      await auth.fidelimax.authenticateFidelimax();
      await buscarQuery(auth.fidelimax.cpf).then((value) {
        filtros.LimparUsuarios();
        filtros.addUsuarios(mockResults.first);
        widget.press.call();
      });
    }

    filtros.usuarios.isNotEmpty
        ? () {
            UtilBrasilFields.isCPFValido(filtros.usuarios.first.pacientes_cpf)
                ? txtQuery.text = UtilBrasilFields.obterCpf(
                    filtros.usuarios.first.pacientes_cpf)
                : txtQuery.text = filtros.usuarios.first.pacientes_nomepaciente;
            //   buscarQuery.call(filtros.usuarios.first.cpf);
            mockResults.clear();
            mockResults.add(filtros.usuarios.first);
            //   _isLoading = false;
          }.call()
        : true;

    return Scaffold(
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  focusColor: redColor,
                  splashColor: redColor,
                  extendedIconLabelSpacing: defaultPadding,
                  label: const Text('Para Mim',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  icon: Icon(Icons.contacts),
                  backgroundColor: primaryColor,
                  elevation: 8,
                  onPressed: () {
                    ParaMim();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: true,
                child: FloatingActionButton.extended(
                  focusColor: redColor,
                  splashColor: redColor,
                  extendedIconLabelSpacing: defaultPadding,
                  label: const Text('Cadastrar',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  icon: const Icon(Icons.person_add_alt),
                  backgroundColor: primaryColor,
                  elevation: 8,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUser(),
                      ),
                    ).whenComplete(() {
                      setState(() {});
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: true,
                child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        buscarQuery(txtQuery.text);
                      });
                    },
                    backgroundColor: primaryColor,
                    child: Icon(Icons.search)),
              ),
            ),
          ],
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: CustomAppBar('Meus\n', 'Amigos', () {}, [])),
        drawer: AppDrawer(),
        // drawer: AppDrawer(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
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
                        Text(
                            'Busque um contato por CPF ou Cadastre um novo usuário ',
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      inputFormatters: [
                                        // obrigatório
                                        //    FilteringTextInputFormatter.digitsOnly,
                                        //    CpfOuCnpjFormatter(),
                                      ],
                                      //    keyboardType: TextInputType.number,
                                      controller: txtQuery,
                                      // initialValue: filtros.usuarios.isNotEmpty
                                      //     ? filtros.usuarios.first.cpf
                                      //     : '',

                                      //     onChanged: buscarQuery,
                                      decoration: InputDecoration(
                                        hintText: "Nome ou por CPF",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            setState(() {
                                              buscarQuery(txtQuery.text);
                                            });
                                          },
                                        ),
                                        prefixIcon: IconButton(
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
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : mockResults.isNotEmpty
                        ? Column(
                            children: List.generate(
                                mockResults.length,
                                (index) => UserCard(
                                    user: mockResults[index],
                                    press: () {
                                      filtros.LimparUsuarios();
                                      filtros.addUsuarios(mockResults[index]);
                                      widget.press.call();
                                    })),
                          )
                        : buildInfoPage(
                            'Busque uma pessoa',
                            'Informe o termos de busca e clique na lupa',
                            Icon(Icons.search)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            ),
          ),
        ));
  }
}
