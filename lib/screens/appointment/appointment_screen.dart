import 'dart:async';

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
import 'package:biomaapp/models/extrato_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/appointment/componets/agenda_indicar.dart';
import 'package:biomaapp/screens/appointment/componets/buildConvenios.dart';
import 'package:biomaapp/screens/appointment/componets/buildEspecialistas.dart';
import 'package:biomaapp/screens/appointment/componets/buildCalendario.dart';
import 'package:biomaapp/screens/appointment/componets/buildLocalizacao.dart';
import 'package:biomaapp/screens/appointment/componets/buildProcedimentos.dart';
import 'package:biomaapp/screens/appointment/componets/buildUsuario.dart';
import 'package:biomaapp/screens/appointment/componets/calendario.dart';
import 'package:biomaapp/screens/appointment/componets/confirmaInformacoes.dart';
import 'package:biomaapp/screens/appointment/componets/indicar.dart';
import 'package:biomaapp/screens/appointment/componets/agendar.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/screens/auth/logar.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_screen.dart';
import 'package:biomaapp/screens/pedidos/orders_page.dart';
import 'package:biomaapp/screens/procedimentos/procedimentosCircle.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/search/components/menu_bar_convenios.dart';
import 'package:biomaapp/screens/search/components/menu_bar_dias.dart';
import 'package:biomaapp/screens/search/components/menu_bar_horarios.dart';
import 'package:biomaapp/screens/search/components/menu_bar_meses.dart';
import 'package:biomaapp/screens/search/components/menu_bar_unidades.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/localizacao.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/screens/user/components/user_screen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  VoidCallback press;
  int menu = 99;
  AppointmentScreen({Key? key, required this.press}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool _isLoadingAgenda = true;
  bool _isLoadUnidades = true;
  List<Clips> horarios = [];
  List<Clips> meses = [];
  List<Clips> dias = [];
  List<Clips> escolherOlho = [];
  final PageController _pageController = PageController();
  final StreamController _stream = StreamController.broadcast();
  Completer<GoogleMapController> _controller = Completer();
  ScrollController _scrollController = ScrollController();
  List<Map<String, Object>> passo = [];
  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }

  void _refreshPage() {
    _stream.sink.add(null);
  }

  @override
  void initState() {
    // if (!mounted) return;

    super.initState();

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    //widget.procedimentos = auth.filtrosativos.procedimentos.first;
    if (auth.filtrosativos.medicos.isNotEmpty)
      Provider.of<agendaMedicoList>(
        context,
        listen: false,
      )
          .loadAgendaMedico(
              auth.filtrosativos.medicos.first.cod_profissional, 'N')
          .then((value) {
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

    //RegrasList dt = Provider.of(context, listen: false);
    UnidadesList BaseUnidades = Provider.of(context);

    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> UnidadesInclusoIncluso = Set();
    Set<String> ConveniosInclusoIncluso = Set();
    List<Unidade> unidadeslist = [];
    List<Convenios> conveniosslist = [];
    DateTime data = DateTime.now();
    List<AgendaMedico> agenda = Provider.of<agendaMedicoList>(
      context,
      listen: false,
    ).items;
    if (filtros.procedimentos
        .isNotEmpty) if (filtros.procedimentos.first.quantidade != '2') {
      setState(() {
        filtros.procedimentos.first.EscolherOlho('A');
        _refreshPage();
      });
    }

    goToPasso(int index) {
      double _height = 60;

      _scrollController.animateTo(_height * index,
          duration: const Duration(seconds: 1), curve: Curves.slowMiddle);
    }

    ProxiPasso() {
      if (true) {
        var proximo = passo.where(
          (element) {
            return element['Status'] as bool == false;
          },
        ).toList();

        if (proximo.isNotEmpty) {
          setState(() {
            widget.menu = passo.indexOf(proximo.first);

            goToPasso(widget.menu);
            _refreshPage();
          });
        } else {
          setState(() {
            widget.menu = passo.indexOf(passo.last);

            goToPasso(widget.menu);
            _refreshPage();
          });
        }
      }
    }

    passo = getPasso(ProxiPasso, auth);

    if (widget.menu == 99) {
      ProxiPasso();
    }
    double _height = 60;

    void _scrollToIndexConvenios(int index) {
      _scrollController.animateTo(_height * index,
          duration: const Duration(seconds: 1), curve: Curves.slowMiddle);
    }

    Widget menu() {
      return Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              passo.length,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    // filtros.LimparPasso();
                    widget.menu = passo.indexOf(passo[index]);
                    passo[index]['Status'] == false;
                    // filtros.addPasso(passo[index]['desc'].toString());
                  });
                },
                child: Container(
                  color: passo[index]['Status'] as bool
                      ? Colors.green[200]
                      : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: defaultPadding,
                      ),
                      passo[index]['Status'] as bool
                          ? Icon(
                              passo[index]['Ico'] as IconData,
                              size: 12,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.cancel,
                              size: 12,
                              color: redColor,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(passo[index]['desc'].toString(),
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.menu == passo.indexOf(passo[index])
                                        ? primaryColor
                                        : Colors.black)),
                      ),
                      Container(
                        color: passo[index]['Status'] as bool
                            ? Colors.green
                            : Colors.white,
                        height: 5,
                        child: SizedBox(
                          width: double.parse(passo[index]['desc']
                                  .toString()
                                  .length
                                  .toString()) *
                              6,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _isLoadingAgenda && _isLoadUnidades
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: CustomAppBar('Agendado\n', 'Procedimentos', () {}, [])),
            body: !auth.isAuth
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: redColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('Login Necessário'),
                                Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      callbackLogin(context, () {
                                        // setState(() {});
                                      });
                                    },
                                    child: Text(
                                      'Logar',
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            menu(),
                            corpo(passo),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
  }

  corpo(List<Map<String, Object>> passo) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Column(children: [
      SizedBox(
        height: defaultPadding,
      ),
      Container(
        //   height: MediaQuery.of(context).size.height,
        //  width: MediaQuery.of(context).size.width,

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          color: redColor,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            //   physics: PageScrollPhysics(),
            controller: _pageController,

            onPageChanged: (num) async {
              setState(() {
                double _height = 60;
                widget.menu = passo.indexOf(passo[num]);
              });
            },
            findChildIndexCallback: (key) {
              print('key');
            },
            //  PageController(viewportFraction: 0.85, initialPage: 0),
            itemCount: passo.length,
            itemBuilder: (context, index) {
              //     debugPrint(_pageController.page.toString());

              return passo[widget.menu]['page'] as Widget;
            },
          ),
        ),
      )
    ]);
  }

  getPasso(VoidCallback ProxiPasso, Auth auth) {
    filtrosAtivos filtros = auth.filtrosativos;
    var StatusProcedimentos = filtros.procedimentos.isNotEmpty
        ? filtros.procedimentos.first.especialidade.codespecialidade != '1'
            ? filtros.procedimentos.isNotEmpty
            : filtros.procedimentos.first.especialidade.codespecialidade ==
                        '1' &&
                    filtros.procedimentos.first.olho != ''
                ? true
                : false
        : false;
    return [
      {
        'desc': 'Convenio',
        'page': BuildConvenios(press: () {
          setState(() {
            ProxiPasso();
          });
        }, refreshPage: () {
          setState(() {
            _refreshPage();
            //filtros.LimparPasso();
          });
          // widget.press.call();
        }),
        'Ico': Icons.check_circle_sharp,
        'Status': filtros.convenios.isNotEmpty
      },
      {
        'desc': 'Especialista',
        'page': BuildEspecialistas(press: () {
          //filtros.LimparPasso();
          setState(() {
            ProxiPasso();
          });
        }, refreshPage: () {
          setState(() {
            _refreshPage();
          });
        }),
        'Ico': Icons.check_circle_sharp,
        'Status': filtros.medicos.isNotEmpty
      },
      {
        'desc': 'Procedimentos',
        'page': BuildProcedimentos(press: () {
          //filtros.LimparPasso();
          setState(() {
            ProxiPasso();
          });
        }, refreshPage: () {
          setState(() {
            _refreshPage();
          });
        }),
        'Ico': Icons.check_circle_sharp,
        'Status': StatusProcedimentos
      },
      {
        'desc': 'Localização',
        'page': BuildLocalizacao(press: () {
          setState(() {
            // Navigator.pop(context);
            ProxiPasso();
          });
        }, refreshPage: () {
          setState(() {
            _refreshPage();
          });
        }),
        'Ico': Icons.check_circle_sharp,
        'Status': filtros.unidades.isNotEmpty
      },
      {
        'desc': 'Calendário',
        'page': BuildCalendario(press: () {
          setState(() {
            ProxiPasso();
          });
        }, refreshPage: () {
          setState(() {
            _refreshPage();
          });
        }),
        'Ico': Icons.check_circle_sharp,
        'Status': filtros.meses.isNotEmpty &&
            filtros.dias.isNotEmpty &&
            filtros.horarios.isNotEmpty
      },
      {
        'desc': 'Usuário',
        'page': BuildUsuario(press: () {
          setState(() {
            _refreshPage();

            var data = DateFormat("yyyy-MM-dd", "pt_BR")
                .format(DateTime.parse(auth.filtrosativos.dias.first.keyId));
            var hora = auth.filtrosativos.horarios.first.subtitulo.toString();
            var id = auth.filtrosativos.horarios.first.keyId.toString();

            var dtDescritiva = '';
            auth.filtrosativos.dias.isNotEmpty &&
                    auth.filtrosativos.horarios.isNotEmpty
                ? dtDescritiva =
                    DateFormat("EEEE', ' d 'de' MMMM 'de' y", "pt_BR").format(
                            DateTime.parse(
                                auth.filtrosativos.dias.first.keyId)) +
                        ' ás ' +
                        hora
                : true;
            //  auth.filtrosativos.LimparFila();
            var fila = Fila(
                medico: auth.filtrosativos.medicos.first,
                data: data,
                olho: auth.filtrosativos.procedimentos.first.olho,
                horario: hora,
                sequencial: id,
                status: '',
                procedimento: auth.filtrosativos.procedimentos.first,
                unidade: auth.filtrosativos.unidades.first,
                convenios: auth.filtrosativos.convenios.first,
                indicado: auth.filtrosativos.usuarios.first,
                indicando: auth.fidelimax.usuario);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmaInfor(
                    fila: fila,
                    press: () {
                      setState(() {
                        _refreshPage();
                        filtros.LimparTipoFila();
                        filtros.LimparCalendario();
                        filtros.LimparPasso();
                        filtros.LimparUsuarios();
                      });
                    }),
              ),
            ).then((value) => {
                  setState(() {
                    _refreshPage();
                  }),
                });
          });
        }, refreshPage: () {
          setState(() {
            _refreshPage();
          });
        }),
        'Ico': Icons.check_circle_sharp,
        'Status': filtros.usuarios.isNotEmpty,
      },
    ];
  }
}
