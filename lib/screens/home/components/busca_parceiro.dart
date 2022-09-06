import 'dart:convert';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class BuscaParceiro extends StatefulWidget {
  BuscaParceiroState createState() => BuscaParceiroState();
}

class BuscaParceiroState extends State<BuscaParceiro> {
  List persons = [];
  List original = [];
  List<Usuario> mockResults = <Usuario>[];
  TextEditingController txtQuery = new TextEditingController();
  bool _isLoading = true;
  String? _selectedAnimal;
  final textEditingController = TextEditingController();
  void loadData() async {
    String jsonStr = "await rootBundle.loadString('assets/persons.json')";
    var json = jsonDecode(jsonStr);
    persons = json;
    original = json;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      persons = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List result = [];
    persons.forEach((p) {
      var name = p["name"].toString().toLowerCase();
      if (name.contains(query)) {
        result.add(p);
      }
    });

    persons = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    @override
    Auth auth = Provider.of(context);
    bool _isIndicacao = auth.filtrosativos.usuarios.isEmpty;

    UsuariosList paciente = Provider.of(context);

    // mockResults = auth.filtrosativos.pacientes;

    filtrosAtivos filtros = auth.filtrosativos;

    Future<void> buscarpaciente(String query) async {
      var lowercaseQuery = query;
      mockResults.where((profile) {
        return true;
        //return profile.cpf.contains(query) || profile.cpf.contains(query);
      }).toList(growable: false)
        ..sort((a, b) => a.pacientes_nomepaciente
            .indexOf(lowercaseQuery)
            .compareTo(b.pacientes_nomepaciente.indexOf(lowercaseQuery)));
    }

    ;
    Future<void> buscarQuery(String cpf) async {
      //  print('paciente.items.toList()');
      cpf = cpf.toString().replaceAll('.', '').replaceAll('-', '');
      mockResults.clear();

      await Provider.of<UsuariosList>(
        context,
        listen: false,
      ).loadPacientes(cpf).then((value) {
        if (paciente.items.length > 0) {
          paciente.items
              .map((e) => {
                    mockResults.add(e),
                  })
              .toList();
          //  mockResults = Query;
          //  buscarQuery(cpf);
          _isLoading = false;
        } else {
          mockResults.add(Usuario());
        }
      });
      debugPrint(paciente.items.length.toString());
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Parceiros"),
      ),
      drawer: AppDrawer(),
      body: Column(
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
                  Text("List view search",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    controller: txtQuery,
                    onChanged: buscarQuery,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          txtQuery.text = '';
                          setState(() {
                            //   debugPrint(txtQuery.text);
                            //   buscarQuery(txtQuery.text);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(mockResults.length.toString()),
            _listView(mockResults)
          ]),
    );
  }
}

Widget _listView(List<Usuario> mockResults) {
  return Expanded(
    child: ListView.builder(
        itemCount: mockResults.length,
        itemBuilder: (context, index) {
          var person = mockResults[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(person.pacientes_nomepaciente[0]),
            ),
            title: Text(person.pacientes_nomepaciente),
            subtitle: Text("CPF: " + person.pacientes_cpf),
            onTap: () {
              print(mockResults[index].pacientes_cpf);
            },
          );
        }),
  );
}
