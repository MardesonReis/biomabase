import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';

class ProcedimentosInfor extends StatefulWidget {
  final Procedimento procedimento;
  final VoidCallback press;
  final VoidCallback update;
  Widget widget;

  ProcedimentosInfor(
      {Key? key,
      required this.procedimento,
      required this.press,
      required this.update,
      this.widget = const SizedBox()})
      : super(key: key);

  @override
  State<ProcedimentosInfor> createState() => _ProcedimentosInforState();
}

class _ProcedimentosInforState extends State<ProcedimentosInfor> {
  bool isError = false;
  String detalhe = '';
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              onTap: () {
                setState(() {
                  widget.press.call();
                });
              },
              // leading: CircleAvatar(
              //     //   backgroundColor: primaryColor,
              //     //   foregroundColor: Colors.black,
              //     radius: 25.0,
              //     child: Text(widget.procedimento.des_procedimentos[0])),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textResp(widget.procedimento.des_procedimento),
                  textResp(widget.procedimento.convenio.desc_convenio),
                  textResp(widget.procedimento.especialidade.des_especialidade),
                  if (widget.procedimento.orientacoes.trim().isNotEmpty)
                    Text(
                      widget.procedimento.orientacoes.capitalize(),
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      maxLines: null,
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (widget.procedimento.especialidade.cod_especialidade ==
                      '1')
                    monoBino(widget.procedimento, () {
                      setState(() {
                        widget.update.call();
                      });
                    }),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              trailing: Column(children: [
                Text('R\$' +
                    widget.procedimento.valorCalculado().toStringAsFixed(1)),
              ]),
            ),
            widget.widget
          ],
        ),
      ),
    );
  }
}
