import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/SearchDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/home/components/EspecialidadesCard.dart';
import 'package:biomaapp/screens/fidelimax/card_fidelimax.dart';
import 'package:biomaapp/screens/home/components/dialogUnidades.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/procedimento_list.dart';

class opcoesEspecialidades extends StatefulWidget {
  opcoesEspecialidades({this.title = ''});

  final String title;

  @override
  _opcoesEspecialidades createState() => _opcoesEspecialidades();
}

class _opcoesEspecialidades extends State<opcoesEspecialidades> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<EspecialidadesList>(
      context,
      listen: false,
    ).loadEspecialidade('').then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //List<String> programmingList = [];

  @override
  Widget build(BuildContext context) {
    EspecialidadesList especialidades = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    List<String> selectedProgrammingList = [];

    _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
            //Here we will build the content of the dialog
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  title: Center(
                    child: Text(
                      "Selecione:",
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  content: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Wrap(
                                spacing: 5.0, // gap between adjacent chips
                                runSpacing: 5.0, // gap between lines
                                direction: Axis.horizontal,
                                children: [
                                  ...List.generate(
                                    especialidades.itemsCount,
                                    (index) => EspecialidadesCard(
                                        esp: especialidades.items[index],
                                        press: () {}),
                                  ),
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.arrow_left),
                              Text("Voltar"),
                            ],
                          ),
                          onPressed: () => {
                            setState(() {
                              Navigator.of(context).pop();
                            }),
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: TextButton(
                  child: Text(
                    "Estecialidades",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => _showDialog(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 5.0, // gap between lines
                  direction: Axis.horizontal,
                  children: [
                    ...List.generate(
                      filtros.especialidades.length,
                      (index) => InputChip(
                        key: ObjectKey(filtros.especialidades[index]),
                        label: Text(filtros.especialidades[index].descricao
                            .capitalize()),
                        avatar: CircleAvatar(
                          child: Text(
                            filtros.especialidades[index].descricao[0],
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        onDeleted: () => {
                          setState(() {
                            filtros.removerEspacialidades(
                                filtros.especialidades[index]);
                          }),
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<Clips> reportList;
  final Function(List<Clips>) onSelectionChanged;

  MultiSelectChip(this.reportList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<Clips> selectedChoices = [];

  _buildChoiceList(filtrosAtivos filtros) {
    // selectedChoices = filtros.grupos;
    List<Widget> choices = [];

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.titulo),
          selected: filtros.especialidades.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;
    return Wrap(
      clipBehavior: Clip.none,
      children: _buildChoiceList(filtros),
    );
  }
}
