import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';

import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/procedimentos/procedimentosCircle.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart';

class ProcedimentosScreen extends StatefulWidget {
  final VoidCallback press;

  ProcedimentosScreen({Key? key, required this.press}) : super(key: key);

  @override
  State<ProcedimentosScreen> createState() => _ProcedimentosScreenState();
}

class _ProcedimentosScreenState extends State<ProcedimentosScreen> {
  bool _isLoading = true;
  List<Regra> regras = [];
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();
  late ScrollController scroll_controller = ScrollController();
  Future? _initialLoad;
  @override
  void loadMore() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    var carrega = scroll_controller.position.pixels >=
        scroll_controller.position.maxScrollExtent -
            (tela(context).height * 0.2);

    if (carrega)
      dt.loadMore(context).then((value) {
        setState(() {});
      });
  }

  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    //13978829304

    //13978829304
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

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);

    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> EspecialidadesInclusas = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> UltimoProcedimentosInclusoIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Procedimento> HistoricoProcedimentos = [];
    final dados = dt.dados;
    List<Procedimento> procedimentos = dt.returnProcedimentos('');

    procedimentos
        .sort((a, b) => a.des_procedimento.compareTo(b.des_procedimento));
    var busca = dt.seemore == false && procedimentos.isEmpty;
    var a;
    a = dt.like.trim().isEmpty
        ? a = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Informe termos para busca')),
          )
        : a = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text('Nada encontrado para o termo de busca informado')),
          );

    return busca
        ? a
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
                      if (index < procedimentos.length) {
                        return ProcedimentosInfor(
                          procedimento: procedimentos[index],
                          press: () {
                            setState(() {
                              filtros.procedimentos.clear();
                              filtros.procedimentos.add(procedimentos[index]);
                              widget.press.call();
                            });
                          },
                          update: () {
                            setState(() {
                              filtros.procedimentos.clear();
                              filtros.procedimentos.add(procedimentos[index]);
                              widget.press.call();
                            });
                          },
                        );
                      } else {
                        if (dt.seemore == true || dt.isLoading == true) {
                          return ProgressIndicatorBioma();
                        } else {
                          return SizedBox();
                        }
                      }
                    },
                    itemCount: () => procedimentos.length + 1,
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
            },
          );
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      controller: scroll_controller,
      itemCount: procedimentos.length,
      itemBuilder: (context, index) {
        return ProcedimentosInfor(
          procedimento: procedimentos[index],
          press: () {
            setState(() {
              filtros.procedimentos.clear();
              filtros.procedimentos.add(procedimentos[index]);
              widget.press.call();
            });
          },
          update: () {
            setState(() {});
          },
        );
      },
    );
  }
}
