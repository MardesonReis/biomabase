import 'dart:async';
import 'dart:collection';

import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
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
import 'package:biomaapp/models/listaDatasMedicos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
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
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarioScren extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

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

  late final ValueNotifier<List<LDatas>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
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

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var list = Provider.of<agendaMedicoList>(
      context,
      listen: false,
    );
    list.listarDatas('0', 'N').then((value) {
      setState(() {
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
    RegrasList dt = Provider.of(context, listen: false);
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
    List<Data> m = [];

    var aFiltros = [];
    List<Medicos> med = [];
    List<Especialidade> especialidades = [];

    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

    List<Medicos> medicos = dt.returnMedicos('');

    List<LDatas> _getEventsForDay(DateTime d) {
      List<LDatas> result = [];

      var a = agenda.itemsDatas
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

    List<LDatas> _getEventsForRange(DateTime start, DateTime end) {
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

    ListarMedicos() {
      setState(() {
        aFiltros = agenda.itemsDatas
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
      });
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return med.isEmpty
              ? Text('Não há especialista para termo ou dia buscado')
              : StatefulBuilder(
                  builder: (BuildContext context, StateSetter mystate) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Médicos que dispoível para ' +
                              _selectedDay!.day.toString() +
                              '/' +
                              _selectedDay!.month.toString() +
                              '/' +
                              _selectedDay!.year.toString()),
                        ),
                        Container(
                          height: tela(context).height * 0.6,
                          child: IncrementallyLoadingListView(
                            //  controller: scroll_controller,
                            hasMore: () => !dt.limit,
                            loadMore: () async {
                              await dt.loadMore(context).then((value) {
                                mystate(() async {});
                              });
                            },
                            itemBuilder: (context, index) {
                              return DoctorInfor(
                                doctor: med[index],
                                press: () async {
                                  mystate(() {
                                    widget.press.call();
                                  });
                                },
                              );
                            },
                            itemCount: () {
                              // setState(() {});
                              return med.length;
                            },
                            onLoadMore: () {
                              mystate(() {
                                dt.seemore = true;
                              });
                            },
                            onLoadMoreFinished: () {
                              mystate(() {
                                dt.seemore = false;
                              });
                            },
                            separatorBuilder: (_, __) => Divider(),
                            loadMoreOffsetFromBottom: 2,
                          ),
                        ),
                        if (dt.seemore == true)
                          Padding(
                              padding: EdgeInsets.all(10),
                              child:
                                  Container(child: ProgressIndicatorBioma())),
                      ],
                    ),
                  );
                });
        },
      ).then((value) {
        setState(() {});
      });
    }

    var busca = _isLoadingAgenda == false && dt.returnMedicos('').isEmpty;
    var a;
    a = dt.seemore == true
        ? a = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('')),
          )
        : dt.like.trim().isNotEmpty
            ? a = Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Informe termos de busca válido')),
              )
            : a = Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Informe termos de busca')),
              );

    return _isLoadingAgenda
        ? Column(
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          )
        : dt.returnMedicos('').isEmpty
            ? a
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar<LDatas>(
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
                        outsideDaysVisible: false,
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _onDaySelected(selectedDay, focusedDay);
                        });

                        ListarMedicos();
                      },
                      onRangeSelected: _onRangeSelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
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
