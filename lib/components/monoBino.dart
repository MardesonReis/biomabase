import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class monoBino extends StatefulWidget {
  Procedimento procedimentos;
  VoidCallback press;
  monoBino(this.procedimentos, this.press);
  @override
  State<monoBino> createState() => _monoBinoState();
}

class _monoBinoState extends State<monoBino> {
  ScrollController OlhoScrollController = ScrollController();
  List<Clips> monoBino = [];
  Clips olhoselecionado = Clips();

  @override
  Widget build(BuildContext context) {
    var verifprocedimento = false;
    String verifolho = '';
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    if (widget.procedimentos.quantidade == '2') {
      monoBino.clear();
      monoBino = [
        Clips(titulo: olhoDescritivo['A'] as String, subtitulo: '', keyId: 'A'),
        Clips(titulo: olhoDescritivo['D'] as String, subtitulo: '', keyId: 'D'),
        Clips(titulo: olhoDescritivo['E'] as String, subtitulo: '', keyId: 'E'),
      ];
    } else {
      setState(() {
        widget.procedimentos.EscolherOlho('A');
      });

      monoBino.clear();
      monoBino = [
        Clips(titulo: '2 Olhos', subtitulo: '', keyId: 'A'),
      ];
    }
    return PopupMenuButton<Clips>(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(1.0),
          child: Card(
            child: Container(
              color: widget.procedimentos.olho.isNotEmpty
                  ? primaryColor
                  : redColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.procedimentos.olho.isNotEmpty
                    ? olhoDescritivo[widget.procedimentos.olho] as String
                    : 'Informe o Olho'),
              ),
            ),
          ),
        ),
      ),
      onSelected: (value) {
        setState(() {
          olhoselecionado = value;
          widget.procedimentos.EscolherOlho(value.keyId);
        });
        widget.press.call();
      },
      itemBuilder: (BuildContext context) {
        return monoBino.map((Clips choice) {
          return PopupMenuItem<Clips>(
            value: choice,
            child: Text(choice.titulo),
          );
        }).toList();
      },
    );
  }
}
