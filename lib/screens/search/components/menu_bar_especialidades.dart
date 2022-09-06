import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarEspecialidades extends StatefulWidget {
  List<Especialidade> especialidades;
  VoidCallback press;
  MenuBarEspecialidades(this.especialidades, this.press);
  @override
  State<MenuBarEspecialidades> createState() => _MenuBarEspecialidadesState();
}

class _MenuBarEspecialidadesState extends State<MenuBarEspecialidades> {
  final AutoScrollController controllerConvenios = AutoScrollController();
  int _selectedConvenios = 0;
  double _height = 50;

  void _scrollToIndexEspecialidades(int index) {
    controllerConvenios.animateTo(_height * index,
        duration: const Duration(seconds: 1), curve: Curves.slowMiddle);
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Container(
      margin: EdgeInsets.all(1),
      padding: EdgeInsets.all(1),
      alignment: Alignment.topCenter,
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.all(1),
        controller: controllerConvenios,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: InkWell(
              onTap: () {
                _scrollToIndexEspecialidades(i);
                setState(() {
                  //   filtros.LimparEspecialidades();
                  filtros.especialidades.contains(widget.especialidades[i])
                      ? filtros.removerEspacialidades(widget.especialidades[i])
                      : filtros.addEspacialidades(widget.especialidades[i]);
                  widget.press.call();
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      filtros.especialidades.contains(widget.especialidades[i])
                          ? primaryColor
                          : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                          widget.especialidades[i].descricao.capitalize(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: widget.especialidades.length,
      ),
    );
  }
}
