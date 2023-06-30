import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/perfilDeAtendimento.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/utils/SelectUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class ConfirmaRegra extends StatefulWidget {
  Procedimento procedimento;
  Unidade unidade;
  Convenios conveio;
  Medicos medico;
  ConfirmaRegra(
      {Key? key,
      required this.procedimento,
      required this.medico,
      required this.unidade,
      required this.conveio})
      : super(key: key);

  @override
  State<ConfirmaRegra> createState() => _ConfirmaRegraState();
}

class _ConfirmaRegraState extends State<ConfirmaRegra> with RestorationMixin {
  final _orientacao_controller = TextEditingController();
  final _valor_sugerido_controller = TextEditingController();
  bool _tipo_regra_parceiro = false;
  bool _valor_aproximado = false;
  bool data_validade = false;
  late double _distanceToField = MediaQuery.of(context).size.width;
  final _controller_tags = TextfieldTagsController();
  final _formKey = GlobalKey<FormState>();
  String _time =
      DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();

  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => 'widget.restorationId';

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(DateTime.now().year + 1));
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
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 2),
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
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _orientacao_controller.dispose();
    _controller_tags.dispose();
    _valor_sugerido_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    PerfilDeAtendimento perfilDeAtendimento = Provider.of(context);
    RegrasList regrasList = Provider.of(context);

    List<Regra> regras = regrasList.items;
    Fidelimax fidelimax = auth.fidelimax;
    filtrosAtivos filtros = auth.filtrosativos;

    return Scaffold(
      appBar: AppBar(
        title: textResp(widget.procedimento.des_procedimentos.capitalize()),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          children: [
            Container(
              height: 2,
              color: primaryColor,
            ),
            DoctorInfor(doctor: widget.medico, press: () {}),
            // DoctorCard(doctor: widget.medico, press: () {}),
            Container(
              height: 2,
              color: primaryColor,
            ),

            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.monetization_on_sharp),
              title: Text(
                widget.procedimento.valor.toString(),
                style: TextStyle(fontSize: 11),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valor de tabela ',
                    style: TextStyle(fontSize: 11),
                  ),
                  if (widget.procedimento.especialidade.codespecialidade == '1')
                    Text(
                      ManoBino[widget.procedimento.quantidade]!,
                      style: TextStyle(fontSize: 11),
                    ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                widget.unidade.des_unidade +
                    " - " +
                    widget.unidade.bairro.capitalize() +
                    " - " +
                    widget.unidade.municipio.capitalize(),
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.group_work_sharp),
              title: Text(
                widget.conveio.desc_convenio,
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.add_link_outlined),
              title: Center(
                child: Text(
                  'Para quem a regra se aplica?',
                  style: TextStyle(fontSize: 11),
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Todos',
                    style: TextStyle(fontSize: 11),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: _tipo_regra_parceiro,
                    onChanged: (value) {
                      setState(() {
                        _tipo_regra_parceiro = true;
                      });
                    },
                  ),
                  Text(
                    'Selecionar',
                    style: TextStyle(fontSize: 11),
                  ),
                  Radio<bool>(
                    value: false,
                    groupValue: _tipo_regra_parceiro,
                    onChanged: (value) {
                      setState(() {
                        _tipo_regra_parceiro = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_tipo_regra_parceiro == true)
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Todos'),
              ),
            if (_tipo_regra_parceiro == false)
              ListTile(
                leading: Icon(Icons.person),
                title: Column(
                  children: [
                    filtros.usuarios.isNotEmpty
                        ? UserCard(
                            user: filtros.usuarios.first,
                            press: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserScreen(),
                                  ),
                                ).then((value) => {
                                      setState(() {
                                        //  widget.refreshPage.call();
                                      }),
                                    });
                              });
                            })
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserScreen(),
                                  ),
                                ).then((value) => {
                                      setState(() {
                                        //  widget.refreshPage.call();
                                      }),
                                    });
                              });
                            },
                            child: Text(
                              'Informe um usuário Bioma',
                              style: TextStyle(fontSize: 11),
                            )),
                  ],
                ),
              ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.monetization_on_outlined),
              title: Column(
                children: [
                  Text(
                    'Qual valor deve aparecer para o parceiro',
                    style: TextStyle(fontSize: 11),
                  ),
                  Form(
                    key: _formKey,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) async {
                        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                          }
                        }
                      },
                      child: TextFormField(
                        controller: _valor_sugerido_controller,
                        //  autofocus: true,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 3.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 3.0,
                              ),
                            ),
                            hintText: widget.procedimento.valor.toString()),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          _formKey.currentState!.validate();
                        },

                        maxLines: null,
                        validator: (value) {
                          if (double.parse(value!) <=
                              widget.procedimento.valor) {
                            return 'Entre com um valor maior ou igual a R\$' +
                                widget.procedimento.valor.toString();
                          }
                          return null;
                        },
                        onChanged: (valor) {
                          setState(() {
                            _formKey.currentState!.validate();
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valor sugerido ',
                    style: TextStyle(fontSize: 11),
                  ),
                  if (widget.procedimento.especialidade.codespecialidade == '1')
                    Text(
                      ManoBino[widget.procedimento.quantidade]!,
                      style: TextStyle(fontSize: 11),
                    ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.textsms_rounded),
              title: Column(
                children: [
                  Text(
                    'Observações e Orientações de agendamento',
                    style: TextStyle(fontSize: 11),
                  ),
                  TextField(
                    controller: _orientacao_controller,
                    //  autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Orientações '),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (orietacao) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.tag),
              title: Column(
                children: [
                  Text(
                    'Informe termos personalizados de busca',
                    style: TextStyle(fontSize: 11),
                  ),
                  TextFieldTags(
                    textfieldTagsController: _controller_tags,
                    initialTags: const [],
                    textSeparators: const [' ', ','],
                    letterCase: LetterCase.normal,
                    validator: (String tag) {
                      if (tag == ' ') {
                        return 'Informe um termo válido';
                      } else if (_controller_tags.getTags!.contains(tag)) {
                        return 'Termos ja inserido';
                      }
                      return null;
                    },
                    inputfieldBuilder:
                        (context, tec, fn, error, onChanged, onSubmitted) {
                      return ((context, sc, tags, onTagDelete) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: tec,
                            focusNode: fn,
                            decoration: InputDecoration(
                              isDense: true,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 3.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 3.0,
                                ),
                              ),
                              helperText:
                                  'Informe opções de busca para esse procedimento',
                              helperStyle: const TextStyle(color: primaryColor),
                              hintText: _controller_tags.hasTags
                                  ? ''
                                  : "Informe termos...",
                              errorText: error,
                              prefixIconConstraints: BoxConstraints(
                                  maxWidth: _distanceToField * 0.75),
                              prefixIcon: tags.isNotEmpty
                                  ? SingleChildScrollView(
                                      controller: sc,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: tags.map((String tag) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: primaryColor),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  '#$tag',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onTap: () {
                                                  print("$tag selected");
                                                },
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.cancel,
                                                  size: 14.0,
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                ),
                                                onTap: () {
                                                  onTagDelete(tag);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                    )
                                  : null,
                            ),
                            onChanged: onChanged,
                            onSubmitted: onSubmitted,
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.add_link_outlined),
              title: Center(
                child: Text(
                  'Informar Valor Aproximado?',
                  style: TextStyle(fontSize: 11),
                ),
              ),
              subtitle: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sim',
                        style: TextStyle(fontSize: 11),
                      ),
                      Radio<bool>(
                        value: true,
                        groupValue: _valor_aproximado,
                        onChanged: (value) {
                          setState(() {
                            _valor_aproximado = true;
                          });
                        },
                      ),
                      Text(
                        'Não',
                        style: TextStyle(fontSize: 11),
                      ),
                      Radio<bool>(
                        value: false,
                        groupValue: _valor_aproximado,
                        onChanged: (value) {
                          setState(() {
                            _valor_aproximado = false;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_valor_aproximado)
                    Column(
                      children: [
                        if (_valor_sugerido_controller.text.trim().isNotEmpty &&
                            double.parse(_valor_sugerido_controller.text) >=
                                widget.procedimento.valor)
                          Text('A partir de R\$ ' +
                              _valor_sugerido_controller.text.toString()),
                        if (_valor_sugerido_controller.text.trim().isEmpty ||
                            double.parse(_valor_sugerido_controller.text) <
                                widget.procedimento.valor)
                          Text('A partir de R\$ ' +
                              widget.procedimento.valor.toString())
                      ],
                    )
                ],
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.add_link_outlined),
              title: Center(
                child: Text(
                  'Informar data de validade para a regra?',
                  style: TextStyle(fontSize: 11),
                ),
              ),
              subtitle: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sim',
                        style: TextStyle(fontSize: 11),
                      ),
                      Radio<bool>(
                        value: true,
                        groupValue: data_validade,
                        onChanged: (value) {
                          setState(() {
                            data_validade = true;
                          });
                        },
                      ),
                      Text(
                        'Não',
                        style: TextStyle(fontSize: 11),
                      ),
                      Radio<bool>(
                        value: false,
                        groupValue: data_validade,
                        onChanged: (value) {
                          setState(() {
                            data_validade = false;
                          });
                        },
                      ),
                    ],
                  ),
                  if (data_validade)
                    ListTile(
                      tileColor: primaryColor,
                      leading: Text('Data de Validade'),
                      trailing: Text(
                          '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
                      onTap: () {
                        _restorableDatePickerRouteFuture.present();
                      },
                    ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        Usuario parceiro = new Usuario();
                        if (_tipo_regra_parceiro == false &&
                            filtros.usuarios.isEmpty) {
                          showSnackBar(
                              Text('Informe um Parceiro ou selecione todos!'),
                              context);
                          setState(() {
                            //_tipo_regra_parceiro = true;
                          });
                          return;
                        }

                        if (_tipo_regra_parceiro) {
                          parceiro.pacientes_cpf = '*';
                          parceiro.pacientes_nomepaciente = 'Todos';
                        } else {
                          parceiro = filtros.usuarios.first;
                        }
                        final DateTime now = DateTime.now();
                        final DateFormat formatterdate =
                            DateFormat('yyyy-MM-dd');
                        final DateFormat formatterHora = DateFormat('HH:mm');
                        final String dataatual = formatterdate.format(now);
                        final String horaatual = formatterHora.format(now);
                        Regra regra = Regra(
                            r_id: '',
                            r_cpf_parceiro: parceiro.pacientes_cpf,
                            r_des_parceiro: parceiro.pacientes_nomepaciente,
                            r_cod_profissional: widget.medico.cod_profissional,
                            r_cpf_profissional: widget.medico.cpf,
                            r_des_profissional: widget.medico.des_profissional,
                            r_crm_profissional: widget.medico.crm,
                            r_sub_especialidade:
                                widget.medico.subespecialidade.isNotEmpty
                                    ? widget.medico.subespecialidade
                                    : widget.medico.especialidade.descricao,
                            r_cod_especialidade:
                                widget.medico.especialidade.codespecialidade,
                            r_des_especialidade:
                                widget.medico.especialidade.descricao,
                            r_grupo: widget.procedimento.grupo,
                            r_cod_unidade: widget.unidade.cod_unidade,
                            r_des_unidade: widget.unidade.des_unidade +
                                widget.unidade.bairro,
                            r_cod_convenio: widget.conveio.cod_convenio,
                            r_desc_convenio: widget.conveio.desc_convenio,
                            r_cod_procedimentos:
                                widget.procedimento.cod_procedimentos,
                            r_des_procedimentos:
                                widget.procedimento.des_procedimentos,
                            r_cod_tratamento:
                                widget.procedimento.cod_tratamento,
                            r_tipo_tratamento:
                                widget.procedimento.des_tratamento,
                            r_tabop_quantidade: widget.procedimento.quantidade,
                            r_frequencia: '0',
                            r_valor_base: widget.procedimento.valor.toString(),
                            r_valor_sugerido: _valor_sugerido_controller
                                        .text.isEmpty ||
                                    double.parse(
                                            _valor_sugerido_controller.text) <
                                        double.parse(widget.procedimento.valor
                                            .toString())
                                ? widget.procedimento.valor.toString()
                                : _valor_sugerido_controller.text,
                            r_orientacoes: _orientacao_controller.text,
                            r_like_regra: '',
                            r_termos_buscas:
                                _controller_tags.getTags!.join(' | '),
                            r_informe_aproximado: _valor_aproximado.toString(),
                            r_status: 'A',
                            r_validade: data_validade
                                ? formatterdate.format(_selectedDate.value)
                                : '',
                            r_data_criacao: dataatual,
                            r_hora_criacao: horaatual,
                            rateios: []);

                        var id_regra = await regrasList.addRegra(regra);
                        if (id_regra != '') {
                          await AlertShowDialog('Sucesso',
                              Text('Adiconado com sucesso'), context);
                          Navigator.of(context).pop();
                        } else {
                          AlertShowDialog('Erro',
                              Text('Regra não adicionada' + id_regra), context);
                        }
                      },
                      child: Text('Adicionar Regra'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
