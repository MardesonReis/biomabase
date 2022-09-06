import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarDias extends StatefulWidget {
  List<Clips> dias;
  VoidCallback press;
  MenuBarDias(this.dias, this.press);
  @override
  State<MenuBarDias> createState() => _MenuBarDiasState();
}

class _MenuBarDiasState extends State<MenuBarDias> {
  final AutoScrollController controllerConvenios = AutoScrollController();
  int _selectedConvenios = 0;
  double _height = 50;
  DateTime selectedDate = DateTime.now();
  String selectedMes = '';

  int currentDateSelectedIndex = 0;
  int currentDateSelectedIMes = 0;
  void _scrollToIndexUnidades(int index) {
    controllerConvenios.animateTo(_height * index,
        duration: const Duration(seconds: 1), curve: Curves.slowMiddle);
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
          margin: EdgeInsets.all(1),
          padding: EdgeInsets.all(1),
          alignment: Alignment.topCenter,
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.all(1),
            controller: controllerConvenios,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, i) {
              return InkWell(
                onTap: () {
                  setState(() {
                    filtros.LimparDias();
                    filtros.dias.contains(widget.dias[i])
                        ? filtros.removerDia(widget.dias[i])
                        : filtros.addDias(widget.dias[i]);
                  });
                  widget.press.call();
                },
                child: Card(
                  elevation: 8,
                  color: filtros.dias.contains(widget.dias[i])
                      ? primaryColor
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateTime.parse(widget.dias[i].keyId).day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: filtros.dias.contains(widget.dias[i])
                                ? Colors.white
                                : textColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          listOfDays[
                                  DateTime.parse(widget.dias[i].keyId).weekday -
                                      1]
                              .toString(),
                          style: TextStyle(
                            color: filtros.dias.contains(widget.dias[i])
                                ? Colors.white
                                : textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.dias.length,
          ),
        ),
      ],
    );
  }
}
