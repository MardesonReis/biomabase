import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/AgendaMedico.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class HoraEstra extends StatefulWidget {
  VoidCallback press;
  final String? restorationId;
  HoraEstra({Key? key, required this.press, required this.restorationId})
      : super(key: key);

  @override
  State<HoraEstra> createState() => _HoraEstraState();
}

class _HoraEstraState extends State<HoraEstra> with RestorationMixin {
  String _time =
      DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();

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
          lastDate: DateTime.now().add(Duration(days: 30)),
        );
      },
    );
  }

  Future displayTimePicker(BuildContext context) async {
    var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        _time = "${time.hour}:${time.minute}";
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
    filtrosAtivos filtros = auth.filtrosativos;
    return Column(
      children: [
        ListTile(
          leading: Text('Data'),
          trailing: Text(
              '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
          onTap: () {
            _restorableDatePickerRouteFuture.present();
          },
        ),
        ListTile(
          leading: Text('Hora'),
          trailing: Text(_time),
          onTap: () {
            displayTimePicker(context);
          },
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          tileColor: primaryColor,
          leading: Icon(Icons.save_as),
          title: Text('Salvar'),
          onTap: () async {
            var agen_med = new AgendaMedico(
                medico: filtros.medicos.first.cod_profissional,
                data: _selectedDate.value.toString(),
                turno: 'M',
                mesano:
                    '${_selectedDate.value.month}-${_selectedDate.value.year}',
                observacao: 'observacao',
                horario: _time,
                sequencial: _selectedDate.value.toString(),
                status: 'status',
                tratamento: 'tratamento',
                reservado: 'reservado',
                usuario: 'usuario',
                unidade: filtros.unidades.first.cod_unidade,
                especialidade:
                    filtros.medicos.first.especialidade.cod_especialidade,
                motivodesmarcar: 'motivodesmarcar',
                tipodeplantao: 'tipodeplantao',
                consultorio: 'consultorio',
                codconsultorio: 'codconsultorio',
                avulso: 'avulso');

            setState(() {
              filtros.hora_extra.add(agen_med);
            });
            widget.press.call();

            ///widget.press.call();
          },
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          tileColor: redColor,
          leading: Icon(Icons.arrow_back_ios),
          title: Text('Cancelar'),
          onTap: () async {
            setState(() {
              Navigator.pop(context);
            });

            ///widget.press.call();
          },
        )
      ],
    );
  }
}
