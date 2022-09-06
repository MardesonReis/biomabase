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

class CalendarioView extends StatefulWidget {
  VoidCallback press;
  CalendarioView({Key? key, required this.press}) : super(key: key);

  @override
  _CalendarioViewState createState() => _CalendarioViewState();
}

class _CalendarioViewState extends State<CalendarioView> {
  bool _isLoadingAgenda = true;
  bool _isLoadUnidades = true;
  List<Clips> horarios = [];
  List<Clips> meses = [];
  List<Clips> dias = [];
  List<Clips> escolherOlho = [];
  @override
  void initState() {
    super.initState();

    filtrosAtivos filtro = Provider.of<Auth>(
      context,
      listen: false,
    ).filtrosativos;

    Provider.of<agendaMedicoList>(
      context,
      listen: false,
    )
        .loadAgendaMedico(filtro.medicos.first.cod_profissional, 'N')
        .then((value) {
      setState(() {
        _isLoadingAgenda = false;
      });
    });
  }

  int selectedSloats = 0;

  @override
  Widget build(BuildContext context) {
    Set<String> MesIncluso = Set();
    Set<String> DiasIncluso = Set();
    Set<String> HorasIncluso = Set();
    Set<String> UnidadesIncluso = Set();

    DataList Data = Provider.of(context);
    UnidadesList BaseUnidades = Provider.of(context);

    Auth auth = Provider.of(context);

    DateTime data = DateTime.now();
    List<AgendaMedico> agenda = Provider.of<agendaMedicoList>(
      context,
      listen: false,
    ).items;
    filtrosAtivos filtros = auth.filtrosativos;

    final dados = Data.items;

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

        if (e.medico == auth.filtrosativos.medicos.first.cod_profissional &&
            e.unidade == auth.filtrosativos.unidades.first.cod_unidade) {
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
                  ed.medico ==
                      auth.filtrosativos.medicos.first.cod_profissional &&
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
                  ed.medico ==
                      auth.filtrosativos.medicos.first.cod_profissional &&
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

    auth.filtrosativos.meses.isEmpty
        ? setState(() {
            //     meses.isNotEmpty ? auth.filtrosativos.addMes(meses[0]) : true;
          })
        : setState(() {});

    auth.filtrosativos.dias.isEmpty
        ? dias.isNotEmpty
            ? setState(() {
                //         auth.filtrosativos.addDias(dias[0]);
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

    if (auth.filtrosativos.procedimentos.first.quantidade == '2') {
      escolherOlho.clear();
      escolherOlho = [
        Clips(titulo: olhoDescritivo['A'] as String, subtitulo: '', keyId: 'A'),
        Clips(titulo: olhoDescritivo['D'] as String, subtitulo: '', keyId: 'D'),
        Clips(titulo: olhoDescritivo['E'] as String, subtitulo: '', keyId: 'E'),
      ];
    } else {
      auth.filtrosativos.procedimentos.first.EscolherOlho('A');
      escolherOlho.clear();
      escolherOlho = [
        Clips(titulo: '2 Olhos', subtitulo: '', keyId: 'A'),
      ];
    }
    var qtd = auth.filtrosativos.procedimentos.first.des_procedimentos
        .capitalize()
        .length;
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
                  meses.isNotEmpty
                      ? MenuBarMeses(meses, () {
                          setState(() {
                            widget.press.call();
                          });
                        })
                      : Card(
                          color: redColor,
                          child: Text(
                              'Não há Mês disponível para o(s) filtro(s) selecionado(s)'),
                        ),
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
                  dias.isNotEmpty
                      ? MenuBarDias(dias, () {
                          setState(() {
                            widget.press.call();
                          });
                        })
                      : Card(
                          color: redColor,
                          child: Text(
                              'Não há dias disponível para o(s) filtro(s) selecionado(s)'),
                        ),
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
                  dias.isNotEmpty
                      ? MenuBarHorarios(horarios, () {
                          setState(() {
                            widget.press.call();
                          });
                        })
                      : Card(
                          color: redColor,
                          child: Text(
                              'Não há horários disponível para o(s) filtro(s) selecionado(s)'),
                        ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
  }
}
