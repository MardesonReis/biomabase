import 'dart:async';
import 'dart:collection';

import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/AgendaMedico.dart';
import 'package:biomaapp/models/agedaMedicoList.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/home/components/card_especialidades.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarioScren extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;
  List<AgendaMedico> agenda = [];

  CalendarioScren({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<CalendarioScren> createState() => _CalendarioScrenState();
}

class _CalendarioScrenState extends State<CalendarioScren> {
  bool _isLoadingAgendamento = true;
  bool _isLoadingAgenda = true;
  bool _isLoadingUnidade = true;
  bool _isLoading = false;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final PageController _pageController = PageController();
  final StreamController _stream = StreamController.broadcast();

  late final ValueNotifier<List<AgendaMedico>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void initState() {
    super.initState();

    filtrosAtivos filtro = Provider.of<Auth>(
      context,
      listen: false,
    ).filtrosativos;
    var med = filtro.medicos.isNotEmpty
        ? filtro.medicos.first.cod_profissional
        : '001';

    var list = Provider.of<agendaMedicoList>(
      context,
      listen: false,
    );
    list.loadAgendaMedico('0', 'N').then((value) {
      setState(() {
        widget.agenda = list.items;
        _selectedDay = _focusedDay;
        _selectedEvents = ValueNotifier([]);

        _isLoadingAgenda = false;
      });
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);
    agendaMedicoList agenda = Provider.of(context);

    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();
    Set<String> UltimosMedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();
    Set<String> EventosInclusos = Set();
    List<AgendaMedico> result;

    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];
    List<Medicos> medicos = [];
    List<Medicos> medicosPorData = [];
    List<Medicos> ultimosMedicos = [];
    var aFiltros = [];
    var med = [];
    var medhistory = [];
    List<Especialidade> especialidades = [];
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.items;
    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    dados.retainWhere((element) {
      return filtrarUnidade
          ? filtros.unidades.contains(Unidade(
              cod_unidade: element.cod_unidade,
              des_unidade: element.des_unidade))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarConvenio
          ? filtros.convenios.contains(Convenios(
              cod_convenio: element.cod_convenio,
              desc_convenio: element.desc_convenio))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarEspecialidade
          ? filtros.especialidades.contains(Especialidade(
              codespecialidade: element.cod_especialidade,
              descricao: element.des_especialidade,
              ativo: 'S'))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarSubEspecialidade
          ? filtros.subespecialidades
              .contains(SubEspecialidade(descricao: element.sub_especialidade))
          : true;
    });
    dados.retainWhere((element) {
      return element.des_profissional
          .toLowerCase()
          .contains(txtQuery.text.toLowerCase());
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });

    dados.map((e) {
      Medicos med = Medicos();
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;
      med.cod_especialidade = e.cod_especialidade;
      med.crm = e.crm;
      med.cpf = e.cpf;
      med.idademin = e.idade_mim;
      med.idademax = e.idade_max;
      med.ativo = '1';
      med.subespecialidade = e.sub_especialidade;

      historico.items.map((element) {
        if (element.cod_profissional == med.cod_profissional) {
          if (!UltimosMedicosInclusos.contains(e.cod_profissional)) {
            UltimosMedicosInclusos.add(e.cod_profissional);
            ultimosMedicos.add(med);
          }
        }
      }).toList();

      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);

        medicos.add(med);
      }

      if (!EspecialidadesInclusas.contains(e.cod_especialidade)) {
        EspecialidadesInclusas.add(e.cod_especialidade);
        especialidades.add(Especialidade(
            codespecialidade: e.cod_especialidade,
            descricao: e.des_especialidade,
            ativo: 'S'));
      }
    }).toList();

    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    especialidades.sort((a, b) => a.descricao.compareTo(b.descricao));

    setState(() {
      aFiltros = agenda.items
          .where((agenda) => medicos
              .where((element) {
                return element.cod_profissional == agenda.medico;
              })
              .toList()
              .isNotEmpty)
          .toList();
      med = medicos
          .where((medico) => aFiltros
              .where((agenda) =>
                  agenda.medico.contains(medico.cod_profissional) &&
                  varificadata(DateTime.parse(agenda.data),
                      _selectedDay ?? DateTime.now()))
              .toList()
              .isNotEmpty)
          .toList();
      medhistory = ultimosMedicos
          .where((medico) => aFiltros
              .where((agenda) =>
                  agenda.medico.contains(medico.cod_profissional) &&
                  varificadata(DateTime.parse(agenda.data),
                      _selectedDay ?? DateTime.now()))
              .toList()
              .isNotEmpty)
          .toList();
    });

    List<AgendaMedico> _getEventsForDay(DateTime d) {
      List<AgendaMedico> result = [];

      var a = agenda.items
          .where((agenda) => medicos
              .where((element) {
                return element.cod_profissional == agenda.medico;
              })
              .toList()
              .isNotEmpty)
          .toList();

      // Implementation example

      var b = a.where((element) {
        var d1 = DateTime.parse(element.data);

        return varificadata(d1, d);
      }).toList();
      b.map((e) {
        var str = e.data + ' - ' + e.medico;
        if (!EventosInclusos.contains(str)) {
          EventosInclusos.add(str);
          result.add(e);
        }
      }).toList();

      return result;
    }

    /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
    List<DateTime> daysInRange(DateTime first, DateTime last) {
      final dayCount = last.difference(first).inDays + 1;
      return List.generate(
        dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
      );
    }

    List<AgendaMedico> _getEventsForRange(DateTime start, DateTime end) {
      // Implementation example
      final days = daysInRange(start, end);

      return [
        for (final d in days) ..._getEventsForDay(d),
      ];
    }

    void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      if (!isSameDay(_selectedDay, selectedDay)) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _rangeStart = null; // Important to clean those
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
        });

        _selectedEvents.value = _getEventsForDay(selectedDay);
      }
    }

    void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
      setState(() {
        _selectedDay = null;
        _focusedDay = focusedDay;
        _rangeStart = start;
        _rangeEnd = end;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
      });

      // `start` or `end` could be null
      if (start != null && end != null) {
        _selectedEvents.value = _getEventsForRange(start, end);
      } else if (start != null) {
        _selectedEvents.value = _getEventsForDay(start);
      } else if (end != null) {
        _selectedEvents.value = _getEventsForDay(end);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PopMenuConvenios(() {
                    setState(() {});
                  }),
                  PopMenuEspecialidade(() {
                    setState(() {});
                  }),
                  PopMenuSubEspecialidades(() {
                    setState(() {});
                  }),
                  PopMenuGrupo(() {
                    setState(() {});
                  }),
                  PopoMenuUnidades(() {
                    setState(() {});
                  })
                ],
              ),
            ),
          ),

          aFiltros.isNotEmpty
              ? Column(
                  children: [
                    TableCalendar<AgendaMedico>(
                      locale: 'pt_BR',
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Mês',
                        CalendarFormat.twoWeeks: 'Quinzena',
                        CalendarFormat.week: 'Semana'
                      },
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarBuilders: CalendarBuilders(
                          markerBuilder: (BuildContext, DateTime, List) {
                        if (List.isNotEmpty)
                          return CircleAvatar(
                            radius: 10,
                            child: Text(
                              List.length.toString(),
                              style: TextStyle(fontSize: 8),
                            ),
                          );
                      }),
                      calendarStyle: CalendarStyle(
                        // Use `CalendarStyle` to customize the UI
                        outsideDaysVisible: true,
                      ),
                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: txtQuery,
                        onChanged: (String) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Buscar",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              txtQuery.text = '';
                              setState(() {
                                mockResults.clear();
                                //buscarQuery(txtQuery.text);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    FiltroAtivosScren(press: () {
                      setState(() {
                        widget.refreshPage.call();
                      });
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: "Últimos Especialistas",
                        pressOnSeeAll: () {},
                        OnSeeAll: false,
                      ),
                    ),
                    if (medhistory.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: List.generate(
                              medhistory.length,
                              (index) => DoctorInforCicle(
                                  doctor: medhistory[index],
                                  press: () {
                                    setState(() {
                                      filtros.LimparMedicos();
                                      filtros.addMedicos(medhistory[index]);

                                      widget.press.call();
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: "Todos os Especialistas",
                        pressOnSeeAll: () {
                          setState(() {
                            pages.selecionarPaginaHome('Especialistas');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorsScreen(),
                            ),
                          );
                        },
                        OnSeeAll: false,
                      ),
                    ),
                    if (med.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        //  physics: BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(
                            med.length,
                            (index) => DoctorInfor(
                              doctor: med[index],
                              press: () async {
                                setState(() {
                                  filtros.LimparMedicos();
                                  filtros.addMedicos(med[index]);
                                  widget.press.call();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : CircularProgressIndicator(),
          // const SizedBox(height: 8.0),
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>>(
          //     valueListenable: _selectedEvents,
          //     builder: (context, value, _) {
          //       return ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin: const EdgeInsets.symmetric(
          //               horizontal: 12.0,
          //               vertical: 4.0,
          //             ),
          //             decoration: BoxDecoration(
          //               border: Border.all(),
          //               borderRadius: BorderRadius.circular(12.0),
          //             ),
          //             child: ListTile(
          //               onTap: () => print('${value[index]}'),
          //               title: Text('${value[index]}'),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ],
      ),
    );
  }

  varificadata(DateTime d1, DateTime d2) {
    var v1 = d1.day.toString() +
        '-' +
        d1.month.toString() +
        '-' +
        d1.year.toString();
    var v2 = d2.day.toString() +
        '-' +
        d2.month.toString() +
        '-' +
        d2.year.toString();

    return v1 == v2;
  }
}
