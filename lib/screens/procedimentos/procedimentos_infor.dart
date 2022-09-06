import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';

class ProcedimentosInfor extends StatefulWidget {
  final Procedimento procedimento;
  final VoidCallback press;

  ProcedimentosInfor(
      {Key? key, required this.procedimento, required this.press})
      : super(key: key);

  @override
  State<ProcedimentosInfor> createState() => _ProcedimentosInforState();
}

class _ProcedimentosInforState extends State<ProcedimentosInfor> {
  bool isError = false;
  String detalhe = '';
  @override
  Widget build(BuildContext context) {
    if (widget.procedimento.especialidade.codespecialidade == '1') {
      if (widget.procedimento.olho.isNotEmpty) {
        detalhe = ' ' + olhoDescritivo[widget.procedimento.olho].toString();
      } else {
        detalhe = ' ' + ManoBino[widget.procedimento.quantidade].toString();
      }
      ;
    } else {
      detalhe = '';
    }

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            setState(() {
              widget.press.call();
            });
          },
          leading: CircleAvatar(
              //   backgroundColor: primaryColor,
              //   foregroundColor: Colors.black,
              radius: 25.0,
              child: Text(widget.procedimento.des_procedimentos[0])),
          title: Text(
            widget.procedimento.des_procedimentos.capitalize(),
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.procedimento.especialidade.descricao.capitalize(),
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              Text(
                detalhe,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
          trailing: Column(children: [
            Text('R\$' + widget.procedimento.valor.toString()),
          ]),
        ),
      ),
    );
  }
}
