import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:biomaapp/components/agendamentos.dart';
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
import 'package:biomaapp/screens/atendimento/atendimentoScreen.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timelines/timelines.dart';

class AgendaMedicoScreen extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;
  List<Agendamentos> agenda = [];

  AgendaMedicoScreen({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<AgendaMedicoScreen> createState() => _AgendaMedicoScreenState();
}

class _AgendaMedicoScreenState extends State<AgendaMedicoScreen> {
  bool _isLoadingAgendamento = true;
  bool _isLoadingAgenda = true;
  bool _isLoadingUnidade = true;
  bool _isLoading = false;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final PageController _pageController = PageController();
  final StreamController _stream = StreamController.broadcast();

  late final ValueNotifier<List<Agendamentos>> _selectedEvents =
      ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void initState() {
    super.initState();

    var list = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    //13978829304
    String cfp = auth.fidelimax.cpf;
    list
        .loadAgendamentos(
            '0', '0', '0', Master.contains(cfp) ? MarterDoctor : cfp)
        .then((value) {
      setState(() {
        _selectedDay = _focusedDay;
        //_selectedEvents = ValueNotifier([]);

        _isLoadingAgenda = false;
        _isLoading = false;
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
    AgendamentosList agenda = Provider.of(context);

    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();
    Set<String> UltimosMedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();
    List<AgendaMedico> result;
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
    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    // dados.retainWhere((element) {
    //   return filtrarUnidade
    //       ? filtros.unidades.contains(Unidade(
    //           cod_unidade: element.cod_unidade,
    //           des_unidade: element.des_unidade))
    //       : true;
    // });

    List<Agendamentos> _getEventsForDay(DateTime d) {
      List<Agendamentos> result = [];
      Set<String> EventosInclusos = Set();
      var datas = agenda.items
          .where((element) =>
              verificadata(DateTime.parse(element.data_movimento), d) &&
              element.des_paciente
                  .toUpperCase()
                  .contains(txtQuery.text.toUpperCase()))
          .toList()
          .map((e) {
        var str = e.data_movimento + ' - ' + e.cod_paciente;
        if (!EventosInclusos.contains(str)) {
          EventosInclusos.add(str);
          result.add(e);
        }
      }).toList();

      result.sort((a, b) {
        var a1 = DateFormat('HH:mm')
            .format(DateTime.parse(a.data_movimento + ' ' + a.hora_marcacao));
        var b1 = DateFormat('HH:mm')
            .format(DateTime.parse(b.data_movimento + ' ' + b.hora_marcacao));
        return a1.compareTo(b1);
      });

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

    List<Agendamentos> _getEventsForRange(DateTime start, DateTime end) {
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

          _selectedEvents.value = _getEventsForDay(selectedDay);
        });
      }
    }

    void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
      setState(() {
        _selectedDay = DateTime.now();

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

    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay);
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('', 'Atendimento', () {}, [])),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 80, bottom: 1, left: 1, right: 1),
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Column(
                  children: [
                    TableCalendar<Agendamentos>(
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
                                //  buscarQuery(txtQuery.text);
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: DateFormat(" d 'de' MMMM 'de' y", "pt_BR")
                            .format(DateTime.parse(_selectedDay.toString())),
                        pressOnSeeAll: () {},
                        OnSeeAll: false,
                      ),
                    ),
                    // if (_selectedEvents.value.isNotEmpty)
                  ],
                ),
                _selectedEvents.value.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: timeline(_selectedEvents.value, context))
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  verificadata(DateTime d1, DateTime d2) {
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

Widget timeline(List<Agendamentos> f, BuildContext context) {
  var kTileHeight = MediaQuery.of(context).size.height * 0.10;

  return Timeline.tileBuilder(
    theme: TimelineThemeData(
      nodePosition: 0.15,
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
          return Card(
            elevation: 8,
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                DateFormat('HH:mm').format(
                  DateTime.parse(
                      f[index].data_movimento + ' ' + f[index].hora_marcacao),
                ),
                style: TextStyle(fontSize: 10),
              ),
            ),
          );
        },
        contentsBuilder: (_, index) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: _EmptyContents(f[index], () {}),
            ),
        connectorBuilder: (_, index, __) {
          switch (f[index].des_status_agenda) {
            case 'P': //RESERVADO
              return SolidLineConnector(
                color: Colors.green,
              );

            case 'V': // CONFIRMADO
              return SolidLineConnector(
                color: Colors.green[800],
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
                color: Colors.green[800],
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
            child: CircularProgressIndicator(),
          )
        : Card(
            child: ListTile(
              horizontalTitleGap: 0,

              // isThreeLine: true,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AtendimentoScreen(
                      agendamento: widget.agendamento,
                    );
                  }),
                ).then((value) => {
                      setState(() {
                        widget.press.call();
                      }),
                    });
              },
              title: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                strutStyle: StrutStyle(fontSize: 10.0),
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  text: widget.agendamento.des_paciente.capitalize(),
                ),
              ),

              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    strutStyle: StrutStyle(fontSize: 10.0),
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 10),
                      text: widget.agendamento.des_procedimento.capitalize(),
                    ),
                  ),
                  Container(
                    color: destColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(widget.agendamento.des_convenio.capitalize(),
                          style: TextStyle(fontSize: 8, color: Colors.black)),
                    ),
                  ),
                ],
              ),
              isThreeLine: true,

              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () async {},
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
