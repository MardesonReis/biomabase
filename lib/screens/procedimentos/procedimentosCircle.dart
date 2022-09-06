import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';

class ProcedimentosCircle extends StatefulWidget {
  final Procedimento procedimento;
  final VoidCallback press;
  ProcedimentosCircle(
      {Key? key, required this.procedimento, required this.press})
      : super(key: key);

  @override
  State<ProcedimentosCircle> createState() => _ProcedimentosCircleState();
}

class _ProcedimentosCircleState extends State<ProcedimentosCircle> {
  bool isError = false;
  String detalhe = '';
  @override
  Widget build(BuildContext context) {
    if (widget.procedimento.especialidade.codespecialidade == '1') {
      detalhe = ' ' + ManoBino[widget.procedimento.quantidade].toString();
      ;
    } else {
      detalhe = '';
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.press.call();
          });
        },
        child: Column(
          children: [
            CircleAvatar(
              //   backgroundColor: primaryColor,
              //   foregroundColor: Colors.black,
              backgroundImage: NetworkImage(
                Constants.IMG_BASE_URL +
                    'medicos/' +
                    widget.procedimento.cod_procedimentos +
                    '.png',
              ),
              radius: 25.0,
              onBackgroundImageError: (_, __) {
                setState(() {
                  isError = true;
                });
              },
              child: isError == true
                  ? Text(widget.procedimento.des_procedimentos[0])
                  : SizedBox(),
            ),
            Text(
              widget.procedimento.des_procedimentos.capitalize(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              widget.procedimento.especialidade.descricao.capitalize(),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              detalhe,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            Text(
              'R\$ ' + widget.procedimento.valor.toString(),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
