import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/minhasaude_list.dart';
import 'package:biomaapp/models/ms_registro.dart';
import 'package:biomaapp/screens/saude/minhasaudePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class RegistrarMinhaSaude extends StatefulWidget {
  VoidCallback press;
  List<MinhaSaude> grupo;
  final String? restorationId;
  RegistrarMinhaSaude(
      {required this.grupo,
      required this.restorationId,
      required this.press,
      Key? key})
      : super(key: key);

  @override
  State<RegistrarMinhaSaude> createState() => _NovoRegistroState();
}

class _NovoRegistroState extends State<RegistrarMinhaSaude>
    with RestorationMixin {
  @override
  bool _isLoading = false;

  Set<String> subgrupos = Set();
  List<MinhaSaude> sublist = [];
  Map<String, String> save = {};
  final _orientacao_controller = TextEditingController();

  String _time = IncluirZero(DateTime.now().hour.toString()) +
      ':' +
      IncluirZero(DateTime.now().minute.toString());

  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  Future displayTimePicker(BuildContext context) async {
    var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        _time =
            "${IncluirZero(time.hour.toString())}:${IncluirZero(time.minute.toString())}";
      });
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    MinhaSaudeList minhasaude = Provider.of(context);

    var tipo;

    return Scaffold(
        appBar: AppBar(title: Text(widget.grupo.first.subgrupo)),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  children: widget.grupo
                      .map(
                        (e) => Column(
                          children: [
                            TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: e.medida,
                                  suffixIcon: IconButton(
                                    icon: Icon(IconMinhaSaude[e.grupo.trim()]),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                onChanged: ((value) {
                                  save.addAll({e.id: value});
                                })),
                            Text(e.medida),
                          ],
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: Icon(Icons.textsms_rounded),
                  title: Column(
                    children: [
                      TextField(
                        controller: _orientacao_controller,
                        //  autofocus: true,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Observações '),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (orietacao) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Text('Data'),
                  trailing: Text(
                      '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
                  onTap: () {
                    _restorableDatePickerRouteFuture.present();
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: Text('Hora'),
                  trailing: Text(_time),
                  onTap: () {
                    displayTimePicker(context);
                  },
                ),
                ListTile(
                  tileColor: primaryColor,
                  leading: Icon(Icons.save_as),
                  title: Text('Salvar'),
                  onTap: () async {
                    if (save.values.join('').isEmpty) {
                      showSnackBar(
                          Text('Entre com uma informação válida'), context);
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    await save.keys.map((e) async {
                      var campo = widget.grupo
                          .where((element) => element.id == e)
                          .toList()
                          .first;
                      var ms = new Ms_registro(
                          id: '',
                          ms_id: e,
                          ms_value: save[e]!,
                          ms_value_agrupado: save.values.join(' / '),
                          cpf_paciente: auth.fidelimax.cpf,
                          cpf_responsavel: auth.fidelimax.cpf,
                          obs: _orientacao_controller.text,
                          data_registro: DateTime.parse(
                              _selectedDate.value.toString().split(' ')[0] +
                                  ' ' +
                                  _time.toString() +
                                  ":00"),
                          hora_registro: _time.toString());

                      await minhasaude.add(ms).then((value) {
                        if (value.isNotEmpty) {
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              _isLoading = false;
                              widget.press.call();
                            });
                          });
                        } else {
                          AlertShowDialog(
                              'Erro',
                              Text(
                                  'Registro não pode ser feito, verifique as informações'),
                              context);
                        }
                      });
                    }).toList();

                    ///widget.press.call();
                  },
                ),
                if (_isLoading)
                  Column(
                    children: [ProgressIndicatorBioma()],
                  )
              ],
            ),
          ),
        ));
  }
}
