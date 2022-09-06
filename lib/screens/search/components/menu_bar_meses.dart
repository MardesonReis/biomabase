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

class MenuBarMeses extends StatefulWidget {
  List<Clips> meses;
  VoidCallback press;
  MenuBarMeses(this.meses, this.press);
  @override
  State<MenuBarMeses> createState() => _MenuBarMesesState();
}

class _MenuBarMesesState extends State<MenuBarMeses> {
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
          height: 70,
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
                    filtros.LimparMeses();
                    filtros.meses.contains(widget.meses[i])
                        ? filtros.removerMes(widget.meses[i])
                        : filtros.addMes(widget.meses[i]);
                  });
                  widget.press.call();
                },
                child: Card(
                  color: filtros.meses.contains(widget.meses[i])
                      ? primaryColor
                      : Colors.white,
                  elevation: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          listOfMonths[int.parse(widget.meses[i].titulo) - 1],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.meses.length,
          ),
        ),
      ],
    );
  }
}
