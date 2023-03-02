import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/screens/appointment/agendamentos_page.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class MeusAgendamentos extends StatefulWidget {
  String menu = '';
  MeusAgendamentos();
  Set<String> datas = Set();

  static final DateTime _date = DateTime.now();

  @override
  State<MeusAgendamentos> createState() => _MeusAgendamentosState();
}

class _MeusAgendamentosState extends State<MeusAgendamentos> {
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
        .loadAgendamentos(auth.fidelimax.cpf.toString(), '0', '0', '0')
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

    dados.map((e) {
      if (!Status.contains(e.des_status_agenda) &&
          StatusAgenda.keys.contains(e.des_status_agenda)) {
        Status.add(e.des_status_agenda);
      }
    }).toList();
    Filtrados = dados
        .where((element) => element.des_status_agenda == widget.menu)
        .toList();

    Filtrados.sort((a, b) => b.data_movimento.compareTo(a.data_movimento));

    if (widget.menu == '' && Status.isNotEmpty) {
      setState(() {
        widget.menu = Status.first;
      });
    }

    var kTileHeight = MediaQuery.of(context).size.height * 0.15;

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Agendamentos"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          atulizaAgenda();
        },
        child: _isLoading
            ? Center(child: ProgressIndicatorBioma())
            : Column(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
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
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Text(
                                          StatusAgenda[Status.elementAt(index)]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Status.elementAt(index) ==
                                                      widget.menu
                                                  ? primaryColor
                                                  : Colors.black)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: defaultPadding),
                                    child: Container(
                                      color:
                                          Status.elementAt(index) == widget.menu
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
                      )),
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
                              widget.menu = Status.elementAt(num);
                            });
                          },
                          //  PageController(viewportFraction: 0.85, initialPage: 0),
                          itemCount: Status.length,
                          itemBuilder: (context, index) {
                            //     debugPrint(_pageController.page.toString());
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
                              padding: EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              builder: TimelineTileBuilder.connected(
                                  addRepaintBoundaries: true,
                                  oppositeContentsBuilder: (context, index) {
                                    widget.datas.clear();
                                    if (index > 1) {
                                      if (Filtrados[index - 1].data_movimento +
                                              '-' +
                                              Filtrados[index - 1]
                                                  .data_movimento !=
                                          Filtrados[index].data_movimento +
                                              '-' +
                                              Filtrados[index].data_movimento) {
                                        return Card(
                                          elevation: 8,
                                          color: primaryColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                defaultPadding),
                                            child: Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(Filtrados[index]
                                                    .data_movimento),
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
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          child: Text(
                                            DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(Filtrados[index]
                                                  .data_movimento),
                                            ),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  contentsBuilder: (_, index) => Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: _EmptyContents(
                                            Filtrados[index], atulizaAgenda),
                                      ),
                                  connectorBuilder: (_, index, __) {
                                    switch (
                                        Filtrados[index].des_status_agenda) {
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
                                    switch (
                                        Filtrados[index].des_status_agenda) {
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
                                  itemCount: Filtrados.length),
                            );
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
  bool _expanded = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: ProgressIndicatorBioma(),
          )
        : Card(
            child: ListTile(
              horizontalTitleGap: 0,

              // isThreeLine: true,
              onTap: () async {
                setState(() {
                  _isLoading = false;
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
              title: textResp(widget.agendamento.des_procedimento.capitalize()),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textResp(widget.agendamento.des_convenio),
                  textResp(widget.agendamento.des_unidade),
                  textResp("Dr(a) " +
                      widget.agendamento.des_profissional.capitalize()),
                  textResp(DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(widget.agendamento.data_movimento)) +
                      ' às ' +
                      widget.agendamento.hora_marcacao)
                ],
              ),
              isThreeLine: true,

              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () async {
                        Medicos doctor = await Medicos();
                        doctor.BuscarMedicoPorId(
                            widget.agendamento.cod_profissional);
                        Procedimento procedimento = Procedimento();
                        procedimento
                            .loadProcedimentosID(
                                widget.agendamento.cod_profissional,
                                '0',
                                '0',
                                widget.agendamento.cod_unidade,
                                widget.agendamento.cod_procedimento,
                                widget.agendamento.cod_convenio)
                            .then((value) {
                          return null;
                        });
                        procedimento.especialidade = Especialidade(
                            codespecialidade:
                                widget.agendamento.cod_especialidade,
                            descricao: widget.agendamento.des_especialidade,
                            ativo: 'S');
                        procedimento.EscolherOlho(widget.agendamento.olho);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return AgendamentosPage(
                                agendamento: widget.agendamento, press: () {});
                          }),
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
