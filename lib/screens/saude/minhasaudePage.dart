import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/minhasaude_list.dart';
import 'package:biomaapp/models/ms_registro.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/saude/MenuMinhaSaude.dart';
import 'package:biomaapp/screens/saude/bottonMenuMinhaSaude.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class MinhaSaudePage extends StatefulWidget {
  const MinhaSaudePage({Key? key}) : super(key: key);

  @override
  State<MinhaSaudePage> createState() => _MinhaSaudePageState();
}

class _MinhaSaudePageState extends State<MinhaSaudePage> with RestorationMixin {
  bool _isLoading = true;
  Future<void> buscarRegistros() {
    print('Iniciando Busca');
    var minhasaude = Provider.of<MinhaSaudeList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    return minhasaude.ListarTipos().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void initState() {
    var minhasaude = Provider.of<MinhaSaudeList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    if (!auth.isAuth) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthOrHomePage(),
          )).then((value) {
        setState(() {});
      });
    }
    if (minhasaude.tipos.isEmpty) {
      buscarRegistros();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }

  String _time =
      DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();

  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => 'widget.restorationId';

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
        buscarRegistros();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MinhaSaudeList minhasaude = Provider.of(context);
    Auth auth = Provider.of(context);

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(tela(context).height * (0.1)),
            child: Column(
              children: [
                CustomAppBar('Minha\n', 'Saúde', () {}, [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => MenuMinhaSaude(press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MinhaSaudePage()),
                          ).then((value) {
                            setState(() {
                              buscarRegistros();
                            });
                          });
                        }),
                      ).then((value) {
                        setState(() {
                          //  buscarRegistros();
                        });
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.add,
                        color: destColor,
                      ),
                    ),
                  )
                ]),
              ],
            )),
        drawer: AppDrawer(),
        floatingActionButton: Visibility(
          visible: false,
          child: FloatingActionButton.extended(
            focusColor: redColor,
            splashColor: redColor,
            extendedIconLabelSpacing: defaultPadding,
            label: const Text('Novo Registro',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            icon: Icon(Icons.edit),
            backgroundColor: primaryColor,
            elevation: 8,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => MenuMinhaSaude(press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MinhaSaudePage()),
                  ).then((value) {
                    setState(() {
                      buscarRegistros();
                    });
                  });
                }),
              ).then((value) {
                setState(() {
                  //  buscarRegistros();
                });
              });
            },
          ),
        ),
        bottomNavigationBar: BottonMenuMinhaSaude(),
        body: _isLoading
            ? ProgressIndicatorBioma()
            : auth.BottonMinhaSaude!.pages[auth.BottonMinhaSaude!.selectedPage]
                ['page'] as Widget);
  }
}
