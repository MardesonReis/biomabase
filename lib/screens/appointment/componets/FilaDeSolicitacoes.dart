import 'package:badges/badges.dart';
import 'package:biomaapp/components/filtros_ativos_agendamento.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biomaapp/models/order.dart';
import 'package:provider/provider.dart';

class FilaSolicitacaoes extends StatefulWidget {
  final Fila fila;
  final VoidCallback press;
  const FilaSolicitacaoes({
    Key? key,
    required this.fila,
    required this.press,
  }) : super(key: key);

  @override
  _FilaSolicitacaoesState createState() => _FilaSolicitacaoesState();
}

class _FilaSolicitacaoesState extends State<FilaSolicitacaoes> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    var isError;
    return Card(
      elevation: 8,
      child: Column(
        children: [
          ListTile(
            title: ListTile(
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
                            ? Text(
                                widget.fila.indicado.pacientes_nomepaciente[0])
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
              subtitle: Text(
                olhoDescritivo[widget.fila.procedimento.olho].toString(),
              ),
              trailing: Text('R\$ ' + widget.fila.procedimento.valor.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              onTap: () async {},
            ),
            trailing: CircleAvatar(
                radius: 20,
                backgroundColor: secudaryColor,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.press.call();
                      });
                    },
                    icon: Icon(Icons.delete),
                    color: redColor)),
            onTap: () async {},
          ),
        ],
      ),
    );
  }
}
