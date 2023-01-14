import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/SearchDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/fidelimax/card_fidelimax.dart';
import 'package:biomaapp/screens/home/components/dialogUnidades.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/procedimento_list.dart';

class opcoesProcedimentos extends StatefulWidget {
  opcoesProcedimentos({this.title = ''});

  final String title;

  @override
  _opcoesProcedimentos createState() => _opcoesProcedimentos();
}

class _opcoesProcedimentos extends State<opcoesProcedimentos> {
  //List<String> programmingList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<UnidadesList>(
      context,
      listen: false,
    ).loadUnidades('').then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UnidadesList unidades = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    //SearchDoctor();
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
              child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Selecione:",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                content: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                            spacing: 1.0, // gap between adjacent chips
                            runSpacing: 1.0, // gap between lines
                            direction: Axis.horizontal,
                            children: [
                              ...List.generate(
                                unidades.itemsCount,
                                (index) => dialogUnidades(
                                  info: unidades.items[index],
                                  press: () => {},
                                ),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Voltar"),
                    onPressed: () => {
                      setState(() {
                        Navigator.of(context).pop();
                      }),
                    },
                  )
                ],
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
                    "Locais de Atendimento",
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
                  spacing: 1.0, // gap between adjacent chips
                  runSpacing: 1.0, // gap between lines
                  direction: Axis.horizontal,
                  children: [
                    ...List.generate(
                      filtros.unidades.length,
                      (index) => InputChip(
                        key: ObjectKey(filtros.unidades[index]),
                        label: Text(filtros.unidades[index].des_unidade),
                        avatar: CircleAvatar(
                          child: Text(
                            filtros.unidades[index].des_unidade[0],
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        onDeleted: () => {
                          setState(() {
                            filtros.removerUnidades(filtros.unidades[index]);
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
          selected: filtros.grupos.contains(item),
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
