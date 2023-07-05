import 'dart:async';
import 'dart:typed_data';
import 'dart:math' show sin, cos, sqrt, atan2;

import 'dart:ui' as ui;
import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';

import 'package:biomaapp/screens/doctors/doctors_screen.dart';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart';

class Localizacao extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;
  Localizacao({required this.press, required this.refreshPage});
  @override
  LocalizacaoState createState() => LocalizacaoState();
}

class LocalizacaoState extends State<Localizacao> {
  Completer<GoogleMapController> _controller = Completer();
  //late Position _currentPosition;

  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();
  final StreamController _stream = StreamController.broadcast();
  late ScrollController scroll_controller = ScrollController();
  Future? _initialLoad;
  int count = 0;

  @override
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

  void _refreshPage() {
    setState(() {
      _stream.sink.add(null);
    });
  }

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;

    AgendamentosList agenda = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );

    //13978829304

    AgendamentosList dados = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    //13978829304

    scroll_controller.addListener(loadMore);

    _initialLoad = dt.loadMore(context).then((value) {
      setState(() {});
    });
    super.initState();
  }

  void dispose() {
    scroll_controller.removeListener(loadMore);

    _stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);
    UnidadesList BancoDeUnidades = Provider.of(context);
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    Paginas pages = auth.paginas;

    Set<String> EspecialidadesInclusas = Set();
    Set<String> UnidadesInclusoIncluso = Set();
    Set<String> UltimasUnidadesIncluso = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> MedicosInclusos = Set();
    Set<String> UnidadesIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Unidade> HistoricoUnidades = [];
    List<Unidade> unidades = dt.returnUnidades(BancoDeUnidades.items);

    List<Medicos> medicos = [];
    List<Procedimento> HistoricoProcedimentos = [];
    List<Procedimento> procedimentos = [];
    late bool _hasMoreItems;

    unidades.sort((a, b) => a.distancia.compareTo(b.distancia));

    var cod_unidade = '';
    if (filtros.unidades.isNotEmpty) {
      cod_unidade = filtros.unidades.first.cod_unidade;
    }
    if (filtros.unidades.isEmpty && unidades.isNotEmpty) {
      cod_unidade = unidades.first.cod_unidade;
    }
    var busca = dt.seemore == false && unidades.isEmpty;
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
                    // controller: scroll_controller,
                    hasMore: () => !dt.limit,
                    loadMore: () async {
                      await dt.loadMore(context);
                    },
                    itemBuilder: (context, index) {
                      return InforUnidade(unidades[index], () {
                        filtros.LimparUnidade();
                        filtros.addunidades(unidades[index]);
                        widget.press.call();
                      });
                    },
                    itemCount: () => unidades.length,
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
  }

  Widget _buildFiltros() {
    return StreamBuilder(
        stream: _stream.stream,
        builder: (BuildContext, AsyncSnapshot) {
          return Align(
              alignment: Alignment.topCenter,
              child: filtrosScreen(
                press: () => setState(() {}),
              ));
        });
  }
}
