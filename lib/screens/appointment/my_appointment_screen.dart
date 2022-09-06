import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/appointment/agendamentos_page.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class MyAppointmentScreen extends StatefulWidget {
  String menu = '';
  MyAppointmentScreen();
  Set<String> datas = Set();

  static final DateTime _date = DateTime.now();

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  bool _isLoading = true;
  Set<String> AgendamentosInclusos = Set();
  final PageController _pageController = PageController();

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    AgendamentosList dados = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    dados
        .loadAgendamentos(auth.fidelimax.cpf.toString())
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    List<Agendamentos> Filtrados = [];
    filtrosAtivos filtros = auth.filtrosativos;
    AgendamentosList list = Provider.of(context, listen: false);
    List<Agendamentos> dados = list.items;
    var kTileHeight = 60.0;
    widget.datas.clear();
    if (widget.menu == '') {
      setState(() {
        widget.menu = StatusProcedimentosAgendados.keys.first;
      });
    }
    AgendamentosInclusos.clear();
    Filtrados.clear();
    Filtrados =
        dados.where((element) => element.status == widget.menu).toList();

    Filtrados.sort((a, b) => b.data_movimento.compareTo(a.data_movimento));
    Filtrados.sort((a, b) => b.status.compareTo(a.status));

    Widget menu() {
      return Container(
        child: Row(
          children: List.generate(
            StatusProcedimentosAgendados.length,
            (index) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        widget.menu =
                            StatusProcedimentosAgendados.keys.elementAt(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                          StatusProcedimentosAgendados.values
                              .elementAt(index)
                              .toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: StatusProcedimentosAgendados.keys
                                          .elementAt(index) ==
                                      widget.menu
                                  ? primaryColor
                                  : Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Container(
                      color:
                          StatusProcedimentosAgendados.keys.elementAt(index) ==
                                  widget.menu
                              ? primaryColor
                              : Colors.white,
                      width: 50,
                      height: 2,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    ;
    Widget timeline(List<Agendamentos> f) {
      widget.datas.clear();

      return Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0.25,
          nodeItemOverlap: true,
          indicatorPosition: 0,
          connectorTheme: ConnectorThemeData(
            thickness: 3.0,
            color: primaryColor,
          ),
          indicatorTheme: IndicatorThemeData(
            size: 15.0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: defaultPadding),
        builder: TimelineTileBuilder.connected(
            addRepaintBoundaries: true,
            oppositeContentsBuilder: (context, index) {
              widget.datas.clear();
              if (index > 1) {
                if (f[index - 1].data_movimento +
                        '-' +
                        f[index - 1].data_movimento !=
                    f[index].data_movimento + '-' + f[index].data_movimento) {
                  return Card(
                    elevation: 8,
                    color: primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(f[index].data_movimento),
                        ),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                }
              } else if (index <= 1) {
                return Card(
                  elevation: 8,
                  color: primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(f[index].data_movimento),
                      ),
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                );
              }
            },
            contentsBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: _EmptyContents(f[index]),
                ),
            connectorBuilder: (_, index, __) {
              if (f[index].status == 'X') {
                return SolidLineConnector(color: redColor);
              } else if (f[index].status == "R") {
                return SolidLineConnector(color: Colors.green);
              } else {
                return SolidLineConnector();
              }
            },
            indicatorBuilder: (
              _,
              index,
            ) {
              switch (f[index].status) {
                case 'X':
                  return OutlinedDotIndicator(
                    color: redColor,
                    backgroundColor: Colors.white,
                  );

                case 'R':
                  return OutlinedDotIndicator(
                    color: Colors.green,
                    backgroundColor: Colors.white,
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
            itemCount: f.length),
      );
    }

    ;

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Agendamentos"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: menu()),
                SizedBox(
                  height: defaultPadding,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: AspectRatio(
                    aspectRatio: 0.5,
                    child: Container(
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        //   physics: PageScrollPhysics(),
                        controller: _pageController,

                        onPageChanged: (num) async {
                          setState(() {
                            widget.menu = StatusProcedimentosAgendados.keys
                                .elementAt(num);
                          });
                        },
                        //  PageController(viewportFraction: 0.85, initialPage: 0),
                        itemCount: StatusProcedimentosAgendados.length,
                        itemBuilder: (context, index) {
                          //     debugPrint(_pageController.page.toString());
                          return timeline(Filtrados);
                        },
                      ),
                    ),
                  ),
                )
              ],
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
    return Card(
      child: ListTile(
        horizontalTitleGap: 0,

        // isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgendamentosPage(
                    agendamento: widget.agendamento, press: () {})),
          ).then((value) => {
                setState(() {}),
              });
        },
        title: Text(
          widget.agendamento.des_procedimento.capitalize(),
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.agendamento.des_unidade,
                style: TextStyle(
                  fontSize: 10,
                )),
            Text("Dr(a) " + widget.agendamento.des_profissional.capitalize(),
                style: TextStyle(
                  fontSize: 10,
                )),
            Text(
                DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(widget.agendamento.data_movimento)) +
                    ' às ' +
                    widget.agendamento.hora_marcacao,
                style: TextStyle(
                  fontSize: 10,
                )),
          ],
        ),
        isThreeLine: true,

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgendamentosPage(
                            agendamento: widget.agendamento, press: () {})),
                  ).then((value) => {
                        setState(() {}),
                      });
                },
                icon: Icon(
                  Icons.read_more,
                  color: primaryColor,
                )),
          ],
        ),
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
