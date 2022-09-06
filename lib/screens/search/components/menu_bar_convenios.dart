import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarConvenios extends StatefulWidget {
  List<Convenios> convenios;
  VoidCallback press;
  MenuBarConvenios(this.convenios, this.press);
  @override
  State<MenuBarConvenios> createState() => _MenuBarConveniosState();
}

class _MenuBarConveniosState extends State<MenuBarConvenios> {
  final AutoScrollController controllerConvenios = AutoScrollController();
  int _selectedConvenios = 0;
  double _height = 60;

  void _scrollToIndexConvenios(int index) {
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
                _scrollToIndexConvenios(i);
                setState(() {
                  //filtros.LimparConvenios();
                  widget.press.call();
                  filtros.convenios.contains(widget.convenios[i])
                      ? filtros.removerConvenios(widget.convenios[i])
                      : filtros.addConvenios(widget.convenios[i]);
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: filtros.convenios.contains(widget.convenios[i])
                      ? primaryColor
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                          widget.convenios[i].desc_convenio.capitalize(),
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
        itemCount: widget.convenios.length,
      ),
    );
  }
}
