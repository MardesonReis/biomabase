import 'package:biomaapp/components/filtros_ativos_agendamento.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/formaPG_list.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biomaapp/models/order.dart';
import 'package:provider/provider.dart';

class FilaAgendamentos extends StatefulWidget {
  final Fila fila;
  final VoidCallback press;
  const FilaAgendamentos({
    Key? key,
    required this.fila,
    required this.press,
  }) : super(key: key);

  @override
  _FilaAgendamentosState createState() => _FilaAgendamentosState();
}

class _FilaAgendamentosState extends State<FilaAgendamentos> {
  bool _expanded = false;
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    FormaPgList FPGListe = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;
    var isError;
    return _isloading
        ? CircularProgressIndicator()
        : Column(
            children: [
              Card(
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.2,
                          child: CircleAvatar(
                            radius: 15,
                            onBackgroundImageError: (_, __) {
                              setState(() {
                                isError = true;
                              });
                            },
                            child: isError == true
                                ? Text(widget.fila.medico.des_profissional[0])
                                : SizedBox(),
                            backgroundImage: NetworkImage(
                              Constants.IMG_USUARIO +
                                  widget.fila.medico.cpf +
                                  '.jpg',
                            ),
                            foregroundImage: NetworkImage(
                              Constants.IMG_BASE_URL +
                                  'medicos/' +
                                  widget.fila.medico.crm +
                                  '.png',
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.2,
                          child: CircleAvatar(
                            radius: 15,
                            onBackgroundImageError: (_, __) {
                              setState(() {
                                isError = true;
                              });
                            },
                            child: isError == true
                                ? Text(widget
                                    .fila.indicado.pacientes_nomepaciente[0])
                                : SizedBox(),
                            backgroundImage: NetworkImage(
                              Constants.IMG_USUARIO +
                                  widget.fila.indicado.pacientes_cpf +
                                  '.jpg',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  title: Text(
                      widget.fila.procedimento.des_procedimentos.capitalize(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat("dd/MM/yyyy\nhh:mm ' Horas ' ").format(
                              DateTime.parse(widget.fila.data +
                                  ' ' +
                                  widget.fila.horario)),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(
                          widget.fila.procedimento.quantidade == '2' &&
                                  widget.fila.procedimento.olho == 'A'
                              ? ' 2x R\$ ${widget.fila.procedimento.valor}'
                              : ' R\$ ${widget.fila.procedimento.valor}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                  trailing: CircleAvatar(
                    radius: 20,
                    backgroundColor: secudaryColor,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      icon: Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              if (_expanded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              olhoDescritivo[widget.fila.procedimento.olho]
                                  as String,
                              style: TextStyle(fontSize: 12),
                            ),
                            Spacer(),
                            Text('Dr(a) ' + widget.fila.medico.des_profissional,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Spacer(),
                            Text(widget.fila.convenios.desc_convenio,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        // FiltrosAtivosAgendamento(doctor: widget.fila.medico, procedimentos: widget.fila.procedimento, press: (){})
                        InforUnidade(widget.fila.unidade, () {}),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.press.call();
                                  });
                                },
                                icon: Icon(Icons.delete),
                                color: redColor),
                          ],
                        ),
                      ]),
                ),
            ],
          );
  }
}
