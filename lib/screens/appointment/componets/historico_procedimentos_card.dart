import 'package:badges/badges.dart';
import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/models/agedaMedicoList.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/screens/appointment/agendamentos_page.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../../constants.dart';
import '../../../models/historico_procedimentos.dart';

class HistoricoProcedimentosCard extends StatefulWidget {
  HistoricoProcedimentosCard({
    Key? key,
    required this.agendamentos,
  }) : super(key: key);
  List<Agendamentos> agendamentos;

  @override
  State<HistoricoProcedimentosCard> createState() =>
      _HistoricoProcedimentosCardState();
}

class _HistoricoProcedimentosCardState
    extends State<HistoricoProcedimentosCard> {
  int _index = 0;
  var kTileHeight = 60.0;

  @override
  Widget build(BuildContext coagendamentosntext) {
    RegrasList dt = Provider.of(context, listen: false);
    final data = _TimelineStatus.values;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultPadding / 4),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
      child: Card(
        //color: primaryColor,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              connectorTheme: ConnectorThemeData(
                thickness: 3.0,
                color: primaryColor,
              ),
              indicatorTheme: IndicatorThemeData(
                size: 15.0,
              ),
            ),
            //   padding: EdgeInsets.symmetric(vertical: 20.0),
            builder: TimelineTileBuilder.connected(
              contentsBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: _EmptyContents(widget.agendamentos[index]),
              ),
              connectorBuilder: (_, index, __) {
                if (index == 0) {
                  return SolidLineConnector(color: Color(0xff6ad192));
                } else {
                  return SolidLineConnector();
                }
              },
              indicatorBuilder: (
                _,
                index,
              ) {
                switch (widget.agendamentos[index].des_status_agenda) {
                  case 'R':
                    return OutlinedDotIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                    );

                  case 'S':
                    return OutlinedDotIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.orange,
                    );
                  default:
                    return OutlinedDotIndicator(
                      color: primaryColor,
                      backgroundColor: Colors.white,
                    );
                }
              },
              contentsAlign: ContentsAlign.basic,
              itemExtentBuilder: (_, __) => kTileHeight,
              itemCount: widget.agendamentos.length,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyContents extends StatefulWidget {
  Agendamentos agendamento;
  _EmptyContents(this.agendamento);

  @override
  State<_EmptyContents> createState() => _EmptyContentsState();
}

class _EmptyContentsState extends State<_EmptyContents> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      trailing: IconButton(
          onPressed: () async {
            Medicos medico =
                await Medicos.toId(widget.agendamento.cod_profissional);
            Procedimento procedimento = await Procedimento();
            procedimento
                .loadProcedimentosID(
                    widget.agendamento.cod_unidade,
                    '0',
                    '0',
                    widget.agendamento.cod_unidade,
                    widget.agendamento.cod_procedimento,
                    widget.agendamento.cod_convenio)
                .then((procedimento) {
              procedimento.especialidade = Especialidade(
                  cod_especialidade: widget.agendamento.cod_especialidade,
                  des_especialidade: widget.agendamento.des_especialidade,
                  ativo: 'S');
              procedimento.EscolherOlho(widget.agendamento.olho);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AgendamentosPage(
                        agendamento: widget.agendamento, press: () {})),
              ).then((value) => {
                    setState(() {}),
                  });
            });
          },
          icon: Icon(
            Icons.info,
            color: primaryColor,
          )),
      title: Text(
        widget.agendamento.des_procedimento.capitalize(),
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      subtitle: Column(
        children: [
          Row(
            children: [
              Text(widget.agendamento.des_profissional.capitalize(),
                  style: TextStyle(
                    fontSize: 10,
                  )),
            ],
          ),
          Row(
            children: [
              Text(
                  DateFormat('dd/MM/yyyy').format(
                      DateTime.parse(widget.agendamento.data_movimento)),
                  style: TextStyle(
                    fontSize: 10,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}
