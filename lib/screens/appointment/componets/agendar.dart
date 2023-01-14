import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/filtros_ativos_agendamento.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/agedaMedicoList.dart';
import 'package:biomaapp/models/AgendaMedico.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:biomaapp/screens/pedidos/orders_page.dart';
import 'package:biomaapp/screens/procedimentos/procedimentosCircle.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/search/components/menu_bar_convenios.dart';
import 'package:biomaapp/screens/search/components/menu_bar_dias.dart';
import 'package:biomaapp/screens/search/components/menu_bar_horarios.dart';
import 'package:biomaapp/screens/search/components/menu_bar_meses.dart';
import 'package:biomaapp/screens/search/components/menu_bar_unidades.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Agendar extends StatefulWidget {
  Medicos doctor;
  Procedimento procedimentos;
  VoidCallback press;
  Agendar(
      {Key? key,
      required this.doctor,
      required this.procedimentos,
      required this.press})
      : super(key: key);

  @override
  _AgendarState createState() => _AgendarState();
}

class _AgendarState extends State<Agendar> {
  bool _isLoadingAgenda = true;
  bool _isLoadUnidades = true;
  List<Clips> horarios = [];
  List<Clips> meses = [];
  List<Clips> dias = [];
  List<Clips> escolherOlho = [];
  @override
  void initState() {
    super.initState();
    Provider.of<Auth>(
      context,
      listen: false,
    ).filtrosativos.LimparTodosFiltros();
    Provider.of<agendaMedicoList>(
      context,
      listen: false,
    ).loadAgendaMedico(widget.doctor.cod_profissional, 'N').then((value) {
      setState(() {
        _isLoadingAgenda = false;
      });
    });

    var unlist = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    unlist.items.isEmpty
        ? unlist.loadUnidades('').then((value) {
            setState(() {
              _isLoadingAgenda = false;
            });
          })
        : setState(() {
            _isLoadingAgenda = false;
          });
  }

  int selectedSloats = 0;

  @override
  Widget build(BuildContext context) {
    Set<String> MesIncluso = Set();
    Set<String> DiasIncluso = Set();
    Set<String> HorasIncluso = Set();
    Set<String> UnidadesIncluso = Set();

    RegrasList dt = Provider.of(context, listen: false);
    UnidadesList BaseUnidades = Provider.of(context);

    Auth auth = Provider.of(context);

    Set<String> UnidadesInclusoIncluso = Set();
    Set<String> ConveniosInclusoIncluso = Set();
    List<Unidade> unidadeslist = [];
    List<Convenios> conveniosslist = [];
    DateTime data = DateTime.now();
    List<AgendaMedico> agenda = Provider.of<agendaMedicoList>(
      context,
      listen: false,
    ).items;
    filtrosAtivos filtros = auth.filtrosativos;

    final dados = dt.dados;
    dados
        .map((e) => BaseUnidades.items.where((element) {
              if (element.cod_unidade.contains(e.cod_unidade)) {
                if (!UnidadesIncluso.contains(element.cod_unidade)) {
                  UnidadesIncluso.add(element.cod_unidade);

                  setState(() {
                    unidadeslist.add(element);
                  });
                }
                return true;
              } else {
                return false;
              }
            }).toList())
        .toList();

    dt.dados.map((e) {
      if (!ConveniosInclusoIncluso.contains(e.cod_convenio) &&
          e.cod_profissional == widget.doctor.cod_profissional) {
        ConveniosInclusoIncluso.add(e.cod_convenio);
        conveniosslist.add(Convenios(
            cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio));
      }
    }).toList();

    meses.clear();
    dias.clear();
    horarios.clear();

    agenda.map(
      (e) {
        var dt = DateTime.parse(e.data);
        var m = Clips(
            titulo: dt.month.toString(),
            subtitulo: dt.month.toString(),
            keyId: e.data);

        if (e.medico == widget.doctor.cod_profissional) {
          if (!MesIncluso.contains(dt.month.toString())) {
            MesIncluso.add(dt.month.toString());
            meses.add(m);
          }
        }
      },
    ).toList();
    meses.sort((a, b) => a.titulo.compareTo(b.titulo));

    if (auth.filtrosativos.unidades.isNotEmpty) {
      auth.filtrosativos.meses.map(
        (em) {
          agenda.map(
            (ed) {
              var dt = DateTime.parse(ed.data);
              var d = Clips(
                  titulo: dt.day.toString(),
                  subtitulo: dt.day.toString(),
                  keyId: ed.data);
              if (em.titulo == dt.month.toString() &&
                  ed.medico == widget.doctor.cod_profissional &&
                  ed.unidade == auth.filtrosativos.unidades[0].cod_unidade) {
                if (!DiasIncluso.contains(dt.day.toString())) {
                  DiasIncluso.add(dt.day.toString());
                  dias.add(d);
                }
              }
            },
          ).toList();
        },
      ).toList();

      auth.filtrosativos.dias.map(
        (dia) {
          agenda.map(
            (ed) {
              var dte = DateTime.parse(ed.data);
              var h = Clips(
                  titulo: ed.sequencial.toString(),
                  subtitulo: ed.horario,
                  keyId: ed.sequencial.toString());
              if (dia.titulo == dte.day.toString() &&
                  dte.month.toString() == auth.filtrosativos.meses[0].titulo &&
                  ed.medico == widget.doctor.cod_profissional &&
                  ed.unidade == auth.filtrosativos.unidades[0].cod_unidade) {
                if (!HorasIncluso.contains(ed.sequencial.toString())) {
                  HorasIncluso.add(ed.sequencial.toString());
                  horarios.add(h);
                }
              }
            },
          ).toList();
        },
      ).toList();
    }

    auth.filtrosativos.fila
        .map((e) => {
              horarios.removeWhere(
                (element) => element.subtitulo == e.horario,
              )
            })
        .toList();

    auth.filtrosativos.unidades.isEmpty
        ? setState(() {
            unidadeslist.isNotEmpty
                ? auth.filtrosativos.addunidades(unidadeslist[0])
                : true;
          })
        : setState(() {});
    auth.filtrosativos.convenios.isEmpty
        ? setState(() {
            unidadeslist.isNotEmpty
                ? auth.filtrosativos.addConvenios(conveniosslist[0])
                : true;
          })
        : setState(() {});
    auth.filtrosativos.meses.isEmpty
        ? setState(() {
            meses.isNotEmpty ? auth.filtrosativos.addMes(meses[0]) : true;
          })
        : setState(() {});

    auth.filtrosativos.dias.isEmpty
        ? dias.isNotEmpty
            ? setState(() {
                auth.filtrosativos.addDias(dias[0]);
              })
            : true
        : setState(() {});
    auth.filtrosativos.horarios.isEmpty
        ? horarios.isNotEmpty
            ? setState(() {
                // auth.filtrosativos.addHorario(horarios[0]);
              })
            : true
        : setState(() {});

    if (widget.procedimentos.quantidade == '2') {
      escolherOlho.clear();
      escolherOlho = [
        Clips(titulo: olhoDescritivo['A'] as String, subtitulo: '', keyId: 'A'),
        Clips(titulo: olhoDescritivo['D'] as String, subtitulo: '', keyId: 'D'),
        Clips(titulo: olhoDescritivo['E'] as String, subtitulo: '', keyId: 'E'),
      ];
    } else {
      widget.procedimentos.EscolherOlho('A');
      escolherOlho.clear();
      escolherOlho = [
        Clips(titulo: '2 Olhos', subtitulo: '', keyId: 'A'),
      ];
    }
    var qtd = widget.procedimentos.des_procedimentos.capitalize().length;
    qtd > 30 ? qtd = 30 : qtd = qtd;

    return _isLoadingAgenda && _isLoadUnidades
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                        widget.procedimentos.des_procedimentos.capitalize(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Text(
                        'R\$ ' + widget.procedimentos.valor.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    onTap: () async {},
                  ),
                  ProcedimentosInfor(
                      procedimento: widget.procedimentos, press: () {}),

                  widget.doctor.cod_especialidade == '1'
                      ? monoBino(widget.procedimentos, () {
                          setState(() {});
                        })
                      : SizedBox(),
                  Divider(),
                  DoctorInfor(
                    doctor: widget.doctor,
                    press: () {},
                  ),
                  Divider(),
                  InforUnidade(
                    filtros.unidades.first,
                    () {
                      setState(() {});
                    },
                  ),
                  Divider(),
                  //  DoctorInfor(doctor: widget.doctor),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Locais de Atendimento",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  MenuBarUnidades(
                    unidadeslist,
                    () {
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Convênios",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  MenuBarConvenios(
                    conveniosslist,
                    () {
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Meses",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  MenuBarMeses(meses, () {
                    setState(() {
                      auth.filtrosativos.LimparDias();
                      auth.filtrosativos.LimparHorario();
                    });
                  }),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Dias",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  MenuBarDias(dias, () {
                    setState(() {});
                  }),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Horários",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  MenuBarHorarios(horarios, () {
                    var data = DateFormat("yyyy-MM-dd", "pt_BR").format(
                        DateTime.parse(auth.filtrosativos.dias.first.keyId));
                    var hora =
                        auth.filtrosativos.horarios.first.subtitulo.toString();
                    var id = auth.filtrosativos.horarios.first.keyId.toString();

                    var dtDescritiva = '';
                    auth.filtrosativos.dias.isNotEmpty &&
                            auth.filtrosativos.horarios.isNotEmpty
                        ? dtDescritiva =
                            DateFormat("EEEE', ' d 'de' MMMM 'de' y", "pt_BR")
                                    .format(DateTime.parse(
                                        auth.filtrosativos.dias.first.keyId))
                                    .toString() +
                                ' ás ' +
                                hora
                        : true;
                    widget.procedimentos.olho.isEmpty
                        ? () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Informe o olho' +
                                    widget.procedimentos.olho),
                                duration: Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    setState(() {});
                                  },
                                ),
                              ),
                            );

                            setState(() {
                              filtros.horarios.clear();
                            });
                          }.call()
                        : showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              contentPadding: EdgeInsets.all(1),
                              title: Container(
                                color: primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Confirme as Informações',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Container(
                                  height: MediaQuery.of(context)
                                              .orientation
                                              .name ==
                                          'portrait'
                                      ? MediaQuery.of(context).size.height * 0.7
                                      : MediaQuery.of(context).size.height *
                                          0.6,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      DoctorInfor(
                                        doctor: widget.doctor,
                                        press: () {},
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                                dtDescritiva.capitalize(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                                'Convênio: ' +
                                                    auth.filtrosativos.convenios
                                                        .first.desc_convenio
                                                        .capitalize(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FiltrosAtivosAgendamento(
                                            doctor: widget.doctor,
                                            procedimentos: widget.procedimentos,
                                            press: () {}),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      auth.filtrosativos.fila.add(Fila(
                                          medico: widget.doctor,
                                          data: data,
                                          olho: widget.procedimentos.olho,
                                          horario: hora,
                                          sequencial: id,
                                          status: "A",
                                          procedimento: widget.procedimentos,
                                          unidade:
                                              auth.filtrosativos.unidades.first,
                                          convenios: auth
                                              .filtrosativos.convenios.first,
                                          indicado: Usuario(),
                                          indicando: Usuario()));
                                      auth.filtrosativos.LimparHorario();
                                      filtros.LimparMedicos();
                                      filtros.addMedicos(widget.doctor);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrdersPage(
                                              Clips(
                                                  titulo: 'Agendamentos',
                                                  subtitulo: '',
                                                  keyId: 'A')),
                                        ),
                                      ).then((value) => {
                                            setState(() {}),
                                          });
                                      filtros.horarios.clear();
                                    });
                                  },
                                  child: const Text('Adicionar',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                                ElevatedButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'Cancelar'),
                                    setState(() {
                                      auth.filtrosativos.LimparHorario();
                                    }),
                                  },
                                  child: const Text('Cancelar',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                          );
                    setState(() {});
                  }),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
  }
}
