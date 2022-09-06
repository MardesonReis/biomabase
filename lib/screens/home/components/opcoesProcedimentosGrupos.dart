import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/screens/procedimentos/filtroProcedimentos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/procedimento_list.dart';
import '../../../utils/app_routes.dart';

class OpcoesProcedimentosGrupos extends StatefulWidget {
  OpcoesProcedimentosGrupos({this.title = ''});

  final String title;

  @override
  _OpcoesProcedimentosGrupos createState() => _OpcoesProcedimentosGrupos();
}

class _OpcoesProcedimentosGrupos extends State<OpcoesProcedimentosGrupos> {
  //List<String> programmingList = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ProcedimentoList procedimentos = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    List<String> selectedProgrammingList = [];

    _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            //Here we will build the content of the dialog
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                child: Expanded(
                  child: AlertDialog(
                    title: Text("Selecione:"),
                    content: Column(
                      children: [
                        FiltrosProcedimentos(),
                        //  MultiSelectChip(
                        //     grupos,
                        //     onSelectionChanged: (selectedList) {
                        //        setState(() {
                        //          //  filtros.SubstituirGrupos(selectedList);
                        //        });
                        //       },
                        //     ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text("Voltar"),
                          onPressed: () => {
                                setState(() {
                                  Navigator.of(context).pop();
                                  //  filtros.SubstituirGrupos(selectedList);
                                })
                              })
                    ],
                  ),
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
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Grupos de Procedimentos",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    //     Navigator.of(context).pushReplacementNamed(
                    //        AppRoutes.MenuBarGrupos,
                    //        );

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FiltrosProcedimentos();
                    })).then((value) => setState(() {}));
                    //  _showDialog();
                  },
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 5.0, // gap between adjacent chips
                    runSpacing: 5.0, // gap between lines
                    direction: Axis.horizontal,
                    children: [
                      ...List.generate(
                        filtros.procedimentos.length,
                        (index) => InputChip(
                          key: ObjectKey(filtros.procedimentos[index]),
                          label: Text(filtros
                              .procedimentos[index].des_procedimentos
                              .capitalize()),
                          avatar: CircleAvatar(
                            child: Text(
                              filtros.procedimentos[index].des_procedimentos,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          onDeleted: () => {
                            setState(() {
                              filtros.removerProcedimento(
                                  filtros.procedimentos[index]);
                            }),
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<Procedimento> reportList;
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
          label: Text(item.des_procedimentos.capitalize()),
          selected: filtros.procedimentos.contains(item),
          onSelected: (selected) {
            setState(() {
              filtros.procedimentos.contains(item)
                  ? filtros.removerProcedimento(item)
                  : filtros.AddProcedimentos(item);
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
