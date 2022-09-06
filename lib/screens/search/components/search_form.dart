import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/screens/home/components/card_indicacao.dart';
import 'package:biomaapp/screens/home/components/opcoesEspecialidades.dart';
import 'package:biomaapp/screens/home/components/opcoesProcedimentosGrupos.dart';
import 'package:biomaapp/screens/home/components/opcoesUnidades.dart';
import 'package:biomaapp/screens/search/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  @override
  final isExpanded = true;

  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    List<Usuario> pacientes = filtros.usuarios;
    return Form(
      child: Column(
        children: [
          Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Column(
                children: [
                  ListTile(
                    //  leading: Icon(Icons.search),
                    title: Center(
                        child: Text(
                      'Busque um CPF',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.w600),
                    )),
                    subtitle: cardIndicacao(),
                  ),

                  /*           Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Buscar'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ), */
                ],
              )),
          Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Column(
                children: [
                  ListTile(
                      //  leading: Icon(Icons.search),
                      title: Center(
                          child: Text(
                        'Busque Locais de Atendimento',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontWeight: FontWeight.w600),
                      )),
                      subtitle: Text('')),
                  opcoesUnidades(),

                  /*           Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Buscar'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ), */
                ],
              )),
          Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Column(
                children: [
                  ListTile(
                    //  leading: Icon(Icons.search),
                    title: Center(
                        child: Text(
                      'Busque Especialista',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.w600),
                    )),
                    subtitle: cardIndicacao(),
                  ),

                  /*           Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Buscar'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ), */
                ],
              )),
          Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Column(
                children: [
                  ListTile(
                    //  leading: Icon(Icons.search),
                    title: Center(
                        child: Text(
                      'Busque',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.w600),
                    )),
                    subtitle: opcoesEspecialidades(),
                  ),

                  /*           Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Buscar'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ), */
                ],
              )),
          Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Column(
                children: [
                  ListTile(
                    //  leading: Icon(Icons.search),
                    title: Center(
                        child: Text(
                      'Busque Grupos de Procedimentos',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.w600),
                    )),
                    subtitle: Text(''),
                  ),
                  OpcoesProcedimentosGrupos(),

                  /*           Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Buscar'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ), */
                ],
              )),
          MaterialButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
              );
            },
            color: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: defaultPadding * 1.25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date",
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 15,
                  ),
                ),
                SvgPicture.asset("assets/icons/event.svg")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultScreen(),
                ),
              ),
              child: Text("Search"),
            ),
          ),
        ],
      ),
    );
  }
}

var currencies = [
  "Food",
  "Transport",
  "Personal",
  "Shopping",
  "Medical",
  "Rent",
  "Movie",
  "Salary"
];
