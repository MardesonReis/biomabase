import 'dart:io';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/voucher_list.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/screens/vouches/ListaVoucherViwer.dart';
import 'package:biomaapp/utils/SelectLocais.dart';
import 'package:biomaapp/utils/SelectUser.dart';
import 'package:biomaapp/utils/SelectProcedimentos.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/servicos/componets/menuProcedimentos.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'VoucherBuild.dart';
import 'package:biomaapp/screens/appointment/componets/buildProcedimentos.dart';

class VocuherCriador extends StatefulWidget {
  @override
  _VocuherCriadorState createState() => _VocuherCriadorState();
}

class _VocuherCriadorState extends State<VocuherCriador> with RestorationMixin {
  int quantity = 0;
  List<Procedimento> servicos = [];

  final _orientacao_controller = TextEditingController();
  bool data_validade = false;
  bool revendedor = false;
  double _porcentagem = 100;
  var isError;
  List<Usuario> revendedores = [];
  List<Unidade> locais = [];
  String _time =
      DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
  List<Voucher> vouchers = [];
  pdf.Document? pdfDocument;

  @override
  void dispose() {
    super.dispose();
  }

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

  void generateVouchers(VoucherList GestorDeVoucher, Auth auth) async {
    String validade;
    if (data_validade) {
      validade = _selectedDate.value.day.toString() +
          '/' +
          _selectedDate.value.month.toString() +
          '/' +
          _selectedDate.value.year.toString();
    } else {
      validade = '';
    }

    if (quantity > 0 && servicos.isNotEmpty) {
      vouchers = GestorDeVoucher.generateAutomaticVouchers(
        quantity: quantity,
        locais: locais,
        servicos: servicos,
        logista: [auth.fidelimax.usuario],
        representantes: revendedores,
        clientes: [],
        dataValidade: validade,
        observacao: _orientacao_controller.text,
        status: 'A',
      );

      Voucher voucherToShare = vouchers.first;
      GestorDeVoucher.shareVoucherWithSalesRepresentative(
          voucherToShare, 'Sales Representative');

      Voucher voucherToDistribute = vouchers.last;
      GestorDeVoucher.distributeVoucherToBuyer(voucherToDistribute, 'Buyer');

      //VoucherManager.shareVouchersOnWhatsApp(vouchers);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    VoucherList GestorDeVoucher = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    SProcedimentos() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: SelectProcedimentos(press: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  }),
                )),
      ).then((value) => {
            setState(() {
              Procedimento procedimento = filtros.procedimentos.first;
              if (!servicos.contains(procedimento)) {
                procedimento.desconto = _porcentagem;
                servicos.add(procedimento);
              }
            }),
          });
    }

    SLocais() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: SelectLocais(press: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  }),
                )),
      ).then((value) => {
            setState(() {
              Unidade unidade = filtros.unidades.first;

              if (!locais.contains(unidade)) {
                locais.add(unidade);
              }
            }),
          });
    }

    SRevendedor() {
      setState(() {
        filtros.LimparUsuarios();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(),
        ),
      ).then((value) => {
            setState(() {
              if (!revendedores.contains(filtros.usuarios.first)) {
                revendedores.add(filtros.usuarios.first);
              }
            }),
          });
    }

    verVouches() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            bool isloading = false;
            return ListVoucheViwer(
              vouchers: vouchers,
              salvar: true,
            );
          },
          fullscreenDialog: true));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            size: 32, //change size on your need
            color: destColor,

            //change color on your need
            shadows: [
              Shadow(blurRadius: 3.0, color: Colors.grey, offset: Offset.zero)
            ]),
        title: Text('Gerenciador de vouchers',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Digite a quantidade de vouchers e selecione o serviço:',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: TextField(
                  decoration:
                      InputDecoration(labelText: 'Quantidade de Vouchers'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      quantity = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Selecione locais de atendimento',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    SLocais();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      // Largura desejada para o botão "Adicionar Mais"

                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 20,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          //  textResp('Adicionar Mais')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Column(
                    children: locais
                        .map((e) => InkWell(
                              onDoubleTap: () {
                                setState(() {
                                  locais.remove(e);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [InforUnidade(e, () {})],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Selecione um Serviço',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    SProcedimentos();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      // Largura desejada para o botão "Adicionar Mais"

                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 20,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          //  textResp('Adicionar Mais')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Column(
                    children: servicos
                        .map((e) => InkWell(
                              onDoubleTap: () {
                                setState(() {
                                  servicos.remove(e);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    ProcedimentosInfor(
                                      procedimento: e,
                                      press: () => () {},
                                      widget: ListTile(
                                        title: Column(
                                          children: [
                                            textResp('Regulador de desconto',
                                                fontSize: 12),
                                            Slider(
                                              value: e.desconto,
                                              min: 0,
                                              max: 100,
                                              divisions: 10,
                                              onChanged: (double value) {
                                                setState(() {
                                                  e.desconto = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          ' ${e.desconto.toStringAsFixed(1)}%',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      update: () {
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.question_mark,
                      color: destColor,
                    ),
                    title: Center(
                      child: Text(
                        'Outros usuários podem compartilhar os vouches?',
                        //style: TextStyle(fontSize: 11),
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
                              groupValue: revendedor,
                              onChanged: (value) {
                                setState(() {
                                  revendedor = true;
                                });
                              },
                            ),
                            Text(
                              'Não',
                              style: TextStyle(fontSize: 11),
                            ),
                            Radio<bool>(
                              value: false,
                              groupValue: revendedor,
                              onChanged: (value) {
                                setState(() {
                                  revendedor = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (revendedor)
                    Column(
                      children: [
                        Container(
                          height: 100, // Altura desejada para a lista
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: revendedores.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < revendedores.length) {
                                Usuario e = revendedores[index];
                                return InkWell(
                                  onDoubleTap: () {
                                    setState(() {
                                      revendedores.remove(e);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          onBackgroundImageError: (_, __) {
                                            setState(() {
                                              isError = true;
                                            });
                                          },
                                          child: isError == true
                                              ? Text(' ')
                                              : SizedBox(),
                                          backgroundImage: NetworkImage(
                                            Constants.IMG_USUARIO +
                                                e.cpf +
                                                '.jpg',
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            textResp(e.nome.split(' ').first),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            textResp(e.nome.split(' ').last)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    SRevendedor();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      // Largura desejada para o botão "Adicionar Mais"

                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: primaryColor,
                                            radius: 25,
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          //  textResp('Adicionar Mais')
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.question_mark,
                      color: destColor,
                    ),
                    title: Center(
                      child: Text(
                        'Os vouches tem data de validade ?',
                        // style: TextStyle(fontSize: 11),
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
                              // style: TextStyle(fontSize: 11),
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
                              //   style: TextStyle(fontSize: 11),
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
                      ],
                    ),
                  ),
                  if (data_validade)
                    Card(
                      elevation: 8,
                      child: ListTile(
                        // tileColor: primaryColor,
                        leading: Icon(Icons.calendar_month),
                        trailing: Text(
                            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
                        onTap: () {
                          _restorableDatePickerRouteFuture.present();
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.textsms_rounded),
                title: Text(
                  'Observações e Orientações de uso do voucher',
                  style: TextStyle(fontSize: 11),
                ),
                subtitle: TextField(
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
              ),
              SizedBox(height: 16),
              if (quantity > 0 && servicos.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    generateVouchers(GestorDeVoucher, auth);
                    verVouches();
                  },
                  child: Text('Gerar Vouchers'),
                ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
