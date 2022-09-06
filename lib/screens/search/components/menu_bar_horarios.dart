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

class MenuBarHorarios extends StatefulWidget {
  List<Clips> horarios;
  VoidCallback press;
  MenuBarHorarios(this.horarios, this.press);
  @override
  State<MenuBarHorarios> createState() => _MenuBarHorariosState();
}

class _MenuBarHorariosState extends State<MenuBarHorarios> {
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(1),
            alignment: Alignment.topCenter,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: widget.horarios.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation.name == 'portrait'
                        ? 4
                        : 8,
                childAspectRatio: 2,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, i) => Card(
                elevation: 8,
                color: filtros.horarios.contains(widget.horarios[i])
                    ? primaryColor
                    : Colors.white,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      filtros.LimparHorario();
                      filtros.horarios.contains(widget.horarios[i])
                          ? filtros.removerHorario(widget.horarios[i])
                          : filtros.addHorario(widget.horarios[i]);

                      filtros.addHorario(widget.horarios[i]);
                      widget.press.call();
                    });
                  },
                  child: Center(
                    child: Text(
                      widget.horarios[i].subtitulo,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: filtros.horarios.contains(widget.horarios[i])
                              ? Colors.white
                              : textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
