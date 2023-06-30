import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/AvailableDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart';

class ProcedimentosScrennViwer extends StatefulWidget {
  Procedimento procedimentos;
  VoidCallback press;
  ProcedimentosScrennViwer(
      {Key? key, required this.procedimentos, required this.press})
      : super(key: key);

  @override
  State<ProcedimentosScrennViwer> createState() =>
      _ProcedimentosScrennViwerState();
}

class _ProcedimentosScrennViwerState extends State<ProcedimentosScrennViwer> {
  bool _isLoading = false;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  bool filterViewer = false;
  late ScrollController scroll_controller = ScrollController();
  Future? _initialLoad;

  @override
  void loadMore() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    var carrega = scroll_controller.position.maxScrollExtent ==
        scroll_controller.position.pixels;

    if (carrega && dt.limit == false && dt.like.isNotEmpty)
      dt.loadMore(context).then((value) {
        scroll_controller.animateTo(
            scroll_controller.offset +
                (MediaQuery.of(context).size.height * 0.10),
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn);
        // widget.refreshPage.call();
      });
  }

  void initState() {
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    var filtros = auth.filtrosativos;
    setState(() {
      filtros.procedimentos.clear();
      filtros.procedimentos.add(widget.procedimentos);
    });
    scroll_controller.addListener(loadMore);
    _initialLoad = dt.loadMore(context).then((value) {
      setState(() {});
    });

    super.initState();
  }

  void dispose() {
    scroll_controller.removeListener(loadMore);
    super.dispose();
  }

  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context, listen: false);
    Paginas pages = auth.paginas;
    var f = filterViewer ? 0.10 : 0.05;
    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];
    List<Medicos> medicos =
        dt.returnMedicos(widget.procedimentos.cod_procedimentos);

    var filtrarProcedimento = filtros.procedimentos.isNotEmpty;

    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    iniciarBusca() {
      if (dt.limit) {
        return false;
      }
      setState(() {
        setState(() {
          dt.seemore = true;
        });
        if (dt.like.isEmpty) {
          dt.like = 'Consulta';
        }
        dt.buscar(context).then((value) {
          setState(() {
            dt.seemore = false;
          });
        });
      });
    }

    var busca = dt.seemore == false && dt.like.isNotEmpty && dt.dados.isEmpty;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(tela(context).height * (0.15 + f)),
            child: Container(
              child: Column(
                children: [
                  CustomAppBar('Procedimento:\n',
                      widget.procedimentos.des_procedimentos, () {}, [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            filterViewer = !filterViewer;
                          });
                        },
                        icon: filterViewer
                            ? Icon(Icons.filter_alt)
                            : Icon(
                                Icons.filter_alt_off,
                                color: Colors.blueGrey,
                              ))
                  ]),
                  if (filterViewer)
                    filtrosScreen(press: () {
                      filtros.medicos.clear();
                      dt.limparDados();
                      iniciarBusca();
                    }),
                  searchScreen(press: () {
                    setState(() {
                      setState(() {});
                    });
                  }),
                ],
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Wrap(
          children: [
            if (dt.seemore == true || dt.isLoading == true)
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(child: ProgressIndicatorBioma())),
          ],
        ),
        //drawer: AppDrawer(),
        onDrawerChanged: (bool) {
          setState(() {
            widget.press.call();
          });
        },
        body: busca
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                        'Nada encontrado para o termo de busca informado')),
              )
            : FutureBuilder(
                future: _initialLoad,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: ProgressIndicatorBioma());

                    case ConnectionState.done:
                      return IncrementallyLoadingListView(
                        //   controller: scroll_controller,
                        hasMore: () => !dt.limit,
                        loadMore: () async {
                          await dt.loadMore(context);
                        },
                        itemBuilder: (context, index) {
                          return DoctorInfor(
                            doctor: medicos[index],
                            press: () async {
                              setState(() {
                                filtros.LimparMedicos();
                                filtros.addMedicos(medicos[index]);
                                widget.press.call();
                              });
                            },
                          );
                        },
                        itemCount: () => medicos.length,
                        onLoadMore: () {
                          setState(() {
                            dt.seemore = true;
                          });
                        },
                        onLoadMoreFinished: () {
                          setState(() {
                            dt.seemore = false;
                          });
                        },
                        separatorBuilder: (_, __) => Divider(),
                        loadMoreOffsetFromBottom: 0,
                      );
                      break;
                    default:
                      return Text('Tem algo errado, verifique sua internet');
                  }
                }));
  }
}
