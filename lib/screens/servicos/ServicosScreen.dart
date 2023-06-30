import 'dart:async';

import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/calendarioScren.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/localizacao.dart';
import 'package:biomaapp/screens/servicos/componets/menuCalendario.dart';
import 'package:biomaapp/screens/servicos/componets/menuEspecialistas.dart';
import 'package:biomaapp/screens/servicos/componets/menuLocalizacao.dart';
import 'package:biomaapp/screens/servicos/componets/menuProcedimentos.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/unidadesScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicosScreen extends StatefulWidget {
  ServicosScreen({Key? key}) : super(key: key);
  List<Map<String, Object>> pageScreen = [];

  @override
  State<ServicosScreen> createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final PageController _pageController = PageController();
  final StreamController _stream = StreamController.broadcast();

  @override
  void dispose() {
    _stream.close();
    widget.pageScreen = [];
    super.dispose();
  }

  void _refreshPage() {
    _stream.sink.add(null);
  }

  @override
  void initState() {
    super.initState();

    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;

    AgendamentosList agenda = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );

    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    var RegraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    auth.atualizaAcesso(context, () {
      ListUnidade.items.isEmpty
          ? ListUnidade.loadUnidades('').then((value) {
              GetpageScreen(filtros, context).then((value) {
                setState(() {
                  _isLoading = false;
                  widget.pageScreen = value;
                });
              });
            })
          : GetpageScreen(filtros, context).then((value) {
              setState(() {
                _isLoading = false;
                widget.pageScreen = value;
              });
            });
    }).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;
    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();
    var _pages = pages;
    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];
    List<Medicos> medicos = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.dados;

    dados.retainWhere((element) {
      return filtrarUnidade
          ? filtros.unidades.contains(Unidade(
              cod_unidade: element.cod_unidade,
              des_unidade: element.des_unidade))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarConvenio
          ? filtros.convenios.contains(Convenios(
              cod_convenio: element.cod_convenio,
              desc_convenio: element.desc_convenio))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarEspecialidade
          ? filtros.especialidades.contains(Especialidade(
              codespecialidade: element.cod_especialidade,
              descricao: element.des_especialidade,
              ativo: 'S'))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarSubEspecialidade
          ? filtros.subespecialidades
              .contains(SubEspecialidade(descricao: element.sub_especialidade))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });
    dados.retainWhere((element) {
      return txtQuery.text.isNotEmpty
          ? element.textBusca
              .toUpperCase()
              .contains(txtQuery.text.toUpperCase())
          : true;
    });

    dados.map((e) {
      var especialidade = Especialidade(
          codespecialidade: e.cod_especialidade,
          descricao: e.des_especialidade,
          ativo: 'S');
      Medicos med = Medicos(especialidade: especialidade);
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;

      med.crm = e.crm;
      med.cpf = e.cpf;
      med.idademin = e.idade_mim;
      med.idademax = e.idade_max;
      med.ativo = '1';
      med.subespecialidade = e.sub_especialidade;

      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }
    }).toList();
    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    if (filtros.servicos_page.isEmpty) {
      setState(() {
        filtros.LimparServicosPage();
        filtros.addsServicosPage(widget.pageScreen[0]);
      });
    } else {
      //  filtros.LimparServicosPage();
      setState(() {
        filtros.addsServicosPage(filtros.servicos_page.first);
      });
      // filtros.addsServicosPage(pageScreen.elementAt(index));
    }

    return _isLoading
        ? Center(child: ProgressIndicatorBioma())
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndTop,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: CustomAppBar('Busque\n', 'Serviços', () {}, [])),
            drawer: AppDrawer(),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            widget.pageScreen.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await filtros.LimparServicosPage();
                                    await filtros.addsServicosPage(
                                        widget.pageScreen[index]);
                                    setState(() {});
                                  },
                                  child: Card(
                                    elevation: 8,
                                    color: widget.pageScreen[index]['titulo'] ==
                                            filtros
                                                .servicos_page.first['titulo']
                                        ? primaryColor
                                        : Colors.white,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Text(
                                          widget.pageScreen[index]['titulo']
                                              as String,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: widget.pageScreen[index]
                                                          ['titulo'] ==
                                                      filtros.servicos_page
                                                          .first['titulo']
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 0.5,
                      child: Container(
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          //   physics: PageScrollPhysics(),
                          controller: _pageController,

                          onPageChanged: (num) async {
                            await filtros.LimparServicosPage();
                            await filtros
                                .addsServicosPage(widget.pageScreen[num]);
                            setState(() {});
                          },
                          //  PageController(viewportFraction: 0.85, initialPage: 0),
                          itemCount: widget.pageScreen.length,
                          itemBuilder: (context, index) {
                            //     debugPrint(_pageController.page.toString());
                            return filtros.servicos_page.first['screen']
                                as Widget;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<List<Map<String, Object>>> GetpageScreen(
      filtrosAtivos filtros, BuildContext context) async {
    return [
      //  if (filtros.medicos.isNotEmpty)
      {'screen': MenuEspecialista(), 'titulo': 'Especialistas'},
      //    if (filtros.procedimentos.isNotEmpty)
      {'screen': MenuProcedimentos(), 'titulo': 'Procedimentos'},
      {
        'screen': MenuLocalizacao(press: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnidadesScreen(),
            ),
          ).then((value) => {
                setState(() {}),
              });
        }, refreshPage: () {
          setState(() {});
        }),
        'titulo': 'Localização'
      },
      {'screen': MenuCalendario(), 'titulo': 'Calendário'},
      //  {'screen': UnidadesScreen(), 'titulo': 'Clinicas'}
    ];
  }
}
