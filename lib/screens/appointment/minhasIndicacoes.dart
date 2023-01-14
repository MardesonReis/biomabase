import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/screens/appointment/agendamentos_page.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class MinhasIndicacoes extends StatefulWidget {
  String menu = '';
  MinhasIndicacoes();
  Set<String> datas = Set();

  static final DateTime _date = DateTime.now();

  @override
  State<MinhasIndicacoes> createState() => _MinhasIndicacoesState();
}

class _MinhasIndicacoesState extends State<MinhasIndicacoes> {
  bool _isLoading = true;
  Set<String> AgendamentosInclusos = Set();
  Set<String> Status = Set();
  final PageController _pageController = PageController();

  @override
  void initState() {
    isLogin(context, () {
      setState(() {});
    });
    atulizaAgenda();
  }

  atulizaAgenda() async {
    setState(() {
      _isLoading = true;
    });
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    AgendamentosList dados = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    await dados
        .loadAgendamentos('0', auth.fidelimax.cpf.toString(), '0', '0')
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

    widget.datas.clear();

    AgendamentosInclusos.clear();
    Filtrados.clear();
    dados.sort((a, b) => a.des_status_agenda.compareTo(b.des_status_agenda));
    dados.map((e) {
      if (!Status.contains(e.des_status_agenda) &&
          StatusAgenda.keys.contains(e.des_status_agenda)) {
        Status.add(e.des_status_agenda);
      }
    }).toList();

    if (widget.menu == '' && Status.isNotEmpty) {
      setState(() {
        widget.menu = Status.first;
      });
    }
    Filtrados = dados
        .where((element) => element.des_status_agenda == widget.menu)
        .toList();
    Filtrados.sort((a, b) => b.data_movimento.compareTo(a.data_movimento));
    Widget menu() {
      return Container(
        child: Row(
          children: List.generate(
            Status.length,
            (index) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        widget.menu = Status.elementAt(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                          StatusAgenda[Status.elementAt(index)].toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Status.elementAt(index) == widget.menu
                                  ? primaryColor
                                  : Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Container(
                      color: Status.elementAt(index) == widget.menu
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

    Widget timeline(List<Agendamentos> f) {
      var kTileHeight = MediaQuery.of(context).size.height * 0.20;

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
                  child: _EmptyContents(f[index], atulizaAgenda),
                ),
            connectorBuilder: (_, index, __) {
              switch (f[index].des_status_agenda) {
                case 'P': //RESERVADO
                  return SolidLineConnector(
                    color: Colors.green,
                  );

                case 'V': // CONFIRMADO
                  return SolidLineConnector(
                    color: Colors.blue[400],
                  );
                case 'C': //CHEGOU
                  return SolidLineConnector(
                    color: Colors.red,
                  );
                case 'T': // EM ATENDIMENTO
                  return SolidLineConnector(
                    color: Colors.orange,
                  );
                case 'A': // ATENDIDO
                  return SolidLineConnector(
                    color: Colors.blue,
                  );
                case 'D': // DESISTIU
                  return SolidLineConnector(
                    color: Colors.amberAccent,
                  );
                default:
                  return SolidLineConnector(
                    color: primaryColor,
                  );
              }
            },
            indicatorBuilder: (
              _,
              index,
            ) {
              switch (f[index].des_status_agenda) {
                case 'P': //RESERVADO
                  return OutlinedDotIndicator(
                    color: Colors.green,
                    backgroundColor: Colors.white,
                  );

                case 'V': // CONFIRMADO
                  return OutlinedDotIndicator(
                    color: Colors.blue[400],
                    backgroundColor: Colors.white,
                  );
                case 'C': //CHEGOU
                  return OutlinedDotIndicator(
                    color: Colors.red,
                    backgroundColor: Colors.white,
                  );
                case 'T': // EM ATENDIMENTO
                  return OutlinedDotIndicator(
                    color: Colors.orange,
                    backgroundColor: Colors.white,
                  );
                case 'A': // ATENDIDO
                  return OutlinedDotIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                  );
                case 'D': // DESISTIU
                  return OutlinedDotIndicator(
                    color: Colors.amberAccent,
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
        title: Text("Minhas Indicações"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          atulizaAgenda();
        },
        child: _isLoading
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
                              widget.menu = StatusAgenda.keys.elementAt(num);
                            });
                          },
                          //  PageController(viewportFraction: 0.85, initialPage: 0),
                          itemCount: StatusAgenda.length,
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
      ),
    );
  }
}

class _EmptyContents extends StatefulWidget {
  Agendamentos agendamento;
  VoidCallback press;
  _EmptyContents(this.agendamento, this.press);

  @override
  State<_EmptyContents> createState() => _EmptyContentsState();
}

class _EmptyContentsState extends State<_EmptyContents> {
  bool _isLoading = false;
  bool isError0 = false;
  bool isError1 = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    horizontalTitleGap: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Wrap(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.2,
                            child: CircleAvatar(
                              radius: 10,
                              onBackgroundImageError: (_, __) {
                                setState(() {
                                  isError0 = true;
                                });
                              },
                              child: isError0 == true
                                  ? Text(widget.agendamento.des_paciente[0])
                                  : SizedBox(),
                              backgroundImage: NetworkImage(
                                Constants.IMG_USUARIO +
                                    widget.agendamento.cpf_paciente +
                                    '.jpg',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            widthFactor: 0.2,
                            child: CircleAvatar(
                              radius: 10,
                              onBackgroundImageError: (_, __) {
                                setState(() {
                                  isError1 = true;
                                });
                              },
                              child: isError1 == true
                                  ? Text(widget.agendamento.des_procedimento[0])
                                  : SizedBox(),
                              backgroundImage: NetworkImage(
                                Constants.IMG_USUARIO +
                                    widget.agendamento.cpf_parceiro +
                                    '.jpg',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    title: textResp(
                        widget.agendamento.des_procedimento.capitalize()),
                    subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textResp(widget.agendamento.des_convenio),
                          textResp(widget.agendamento.des_unidade),
                          textResp("Dr(a) " +
                              widget.agendamento.des_profissional.capitalize()),
                          textResp(DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(
                                      widget.agendamento.data_movimento)) +
                              ' às ' +
                              widget.agendamento.hora_marcacao)
                        ]),
                    trailing: InkWell(
                      onTap: () {
                        AlertShowDialog('Resgate Indisponível',
                            'Módulo não está ativo', context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Resgate',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                'R\$ ' +
                                    (double.parse(widget.agendamento.valor) *
                                            0.10)
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AgendamentosPage(
                              agendamento: widget.agendamento, press: () {});
                        }),
                      ).then((value) => {
                            setState(() {
                              widget.press.call();
                            }),
                          });
                    },
                  ),
                ),
              ),
            ],
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
