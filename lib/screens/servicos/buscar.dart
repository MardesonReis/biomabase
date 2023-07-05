import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/especialidades/especialidades_screen.dart';
import 'package:biomaapp/screens/home/components/available_doctors.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/BuscaMedicos.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/unidadesScreen.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/servicos/menu.dart';
import 'package:biomaapp/screens/user/user_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//import 'package:vector_math/vector_math.dart';

class BuscarScree extends StatefulWidget {
  BuscarScree({Key? key}) : super(key: key);

  @override
  State<BuscarScree> createState() => _BuscarScreeState();
}

class _BuscarScreeState extends State<BuscarScree> {
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  //final ScrollController controller = ScrollController();
  final StreamController _stream = StreamController.broadcast();
  late ScrollController scroll_controller;
  int n = 0;
  List<Regra> regras = [];
  // bool _isLoading = true;
  GlobalKey globalKey = GlobalKey();
  //late Position _currentPosition;
  //TextEditingController txtQuery = new TextEditingController();
  int count = 0;

  @override
  void dispose() {
    _stream.close();

    super.dispose();
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

    AgendamentosList agenda = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );

    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    //13978829304
    filtrosAtivos filtros = auth.filtrosativos;
    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    //scroll_controller = ScrollController()..addListener(loadMore);
    auth.atualizaAcesso(context, () {
      setState(() {});
    }).then((value) {
      setState(() {});
    });
  }

  double zoomVal = 8;

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context);
    final dados = dt.dados;
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
    List<Unidade> unidades = [];

    List<Medicos> medicos = [];
    List<Procedimento> HistoricoProcedimentos = [];
    List<Procedimento> procedimentos = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarMedico = filtros.medicos.isNotEmpty;

    // dados.retainWhere((element) {
    //   return filtrarUnidade
    //       ? filtros.unidades.contains(Unidade(
    //           cod_unidade: element.cod_unidade,
    //           des_unidade: element.des_unidade))
    //       : true;

    if (txtQuery.text == '') {
      setState(() {
        mockResults.clear();
        dt.limparDados();
        //buscarQuery(txtQuery.text);
      });
    }

    unidades.sort((a, b) => a.distancia.compareTo(b.distancia));
    dados.retainWhere((element) {
      return element.textBusca
          .toLowerCase()
          .contains(txtQuery.text.toLowerCase());
    });
    dados.map((e) {
      Procedimento p = Procedimento();
      p.convenio = Convenios(
          cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio);

      p.cod_procedimento = e.cod_procedimentos;
      p.des_procedimento = e.des_procedimentos;
      p.valor = double.parse(e.valor);
      p.valor_sugerido = double.parse(e.valor_sugerido);
      p.orientacoes = e.orientacoes;
      p.grupo = e.grupo;
      p.frequencia = e.frequencia;
      p.quantidade = e.tabop_quantidade;
      p.especialidade.cod_especialidade = e.cod_especialidade;
      p.especialidade.des_especialidade = e.des_especialidade;
      p.cod_tratamento = e.cod_tratamento;
      p.des_tratamento = e.tipo_tratamento;

      if (!ProcedimentosInclusoIncluso.contains(
          e.cod_convenio + '-' + p.valor_sugerido.toString())) {
        ProcedimentosInclusoIncluso.add(
            e.cod_convenio + '-' + p.valor_sugerido.toString());

        procedimentos.add(p);
      }

      Unidade unidade = Unidade();
      unidade.cod_unidade = e.cod_unidade;
      unidade.des_unidade = e.des_unidade;

      if (!UnidadesInclusoIncluso.contains(e.cod_unidade)) {
        UnidadesInclusoIncluso.add(e.cod_unidade);

        if (BancoDeUnidades.items.isNotEmpty) {
          var u = BancoDeUnidades.items
              .where((element) => element.cod_unidade == unidade.cod_unidade)
              .toList()
              .first;
          //  u.distancia = await getDistance(unidade.latitude, unidade.l atitude);

          unidades.add(u);
        }
      }

      // if (!UnidadesIncluso.contains(e.cod_unidade)) {
      //   UnidadesIncluso.add(e.cod_unidade);
      //   unidades.add(unidade);
      // }
    }).toList();
    unidades.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));
    double aut = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      //extendBodyBehindAppBar: true,
      drawer: AppDrawer(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Buscar\n', 'Serviços', () {}, [])),
      key: globalKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Wrap(
        children: [
          if (dt.seemore == true || dt.isLoading == true)
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(child: ProgressIndicatorBioma())),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          // controller: scroll_controller,
          child: Container(
            child: Column(
              children: [
                EspecialistasScreenn(press: () {
                  setState(() {});
                }, refreshPage: () {
                  setState(() {});
                }),
                if (dt.isLoading) Center(),
                if (!dt.isLoading &&
                    txtQuery.text.isNotEmpty &&
                    dt.dados.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                            'Nada encontrado para o termo de busca informado')),
                  ),
                if (dt.items.isEmpty) MenuScreen(),
                if (!dt.isLoading)
                  if (txtQuery.text.isNotEmpty && medicos.isNotEmpty)
                    Column(
                      children: [
                        Column(
                          children: [
                            Card(
                              child: ListTile(
                                hoverColor: Colors.yellow,
                                tileColor: Colors.yellow,
                                trailing: Icon(Icons.search),
                                title: Text('Especialistas',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                onTap: () {},
                              ),
                            ),
                            // EspecialidadesScreen(),
                          ],
                        ),
                        if (false)
                          Column(
                            children: [
                              Card(
                                child: ListTile(
                                  hoverColor: Colors.yellow,
                                  tileColor: Colors.yellow,
                                  trailing: Icon(Icons.search),
                                  title: Text('Procedimentos',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {},
                                ),
                              ),
                              Column(
                                children: List.generate(
                                    procedimentos.length,
                                    (index) => ProcedimentosInfor(
                                          procedimento: procedimentos[index],
                                          press: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProcedimentosScrennViwer(
                                                  procedimentos:
                                                      procedimentos[index],
                                                  press: () {},
                                                ),
                                              ),
                                            );
                                          },
                                          update: () {
                                            setState(() {});
                                          },
                                        )),
                              ),
                              if (dt.limit == false)
                                Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          // buscar('r_des_procedimentos');
                                        },
                                        child: Text('Ver Mais')),
                                  ],
                                )
                            ],
                          ),
                        if (false)
                          Column(
                            children: [
                              Card(
                                child: ListTile(
                                  hoverColor: Colors.yellow,
                                  tileColor: Colors.yellow,
                                  trailing: Icon(Icons.search),
                                  title: Text('Locais de Atendimento',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {},
                                ),
                              ),
                              Column(
                                children: List.generate(
                                    unidades.length,
                                    (index) => InforUnidade(
                                          unidades[index],
                                          () {
                                            filtros.LimparUnidade();
                                            filtros
                                                .addunidades(unidades[index]);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UnidadesScreen(),
                                              ),
                                            ).then((value) => {
                                                  setState(() {}),
                                                });
                                          },
                                        )),
                              ),
                              if ((dt.limit == false))
                                Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          //   buscar('r_des_unidade');
                                        },
                                        child: Text('Ver Mais')),
                                  ],
                                )
                            ],
                          ),
                      ],
                    )
              ],
            ),
          ),
        ),
      ),

      // : FloatingActionButtonLocation.centerTop,
      // backgroundColor: primaryColor,
    );
  }
}
