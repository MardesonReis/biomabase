import 'package:biomaapp/components/app_drawer.dart';
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
import 'package:biomaapp/screens/appointment/componets/historico_procedimentos_view.dart';
import 'package:biomaapp/screens/home/components/card_especialidades.dart';
import 'package:biomaapp/screens/home/components/card_indicacao.dart';
import 'package:biomaapp/screens/home/components/meu_bioma.dart';
import 'package:biomaapp/screens/home/components/recommended_doctors.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'package:flutter/material.dart';

import 'components/available_doctors.dart';
import '../../components/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  bool _isLoadingAgendamento = true;
  bool _isLoadingUnidade = true;
  @override
  void initState() {
    // if (!mounted) return;

    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;
    filtros.LimparUnidade();

    var RegraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    //13978829304

    RegraList.carrgardados(context, Onpress: () {
      setState(() {
        _isLoading = false;
      });
    });

    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    ListUnidade.items.isEmpty
        ? ListUnidade.loadUnidades('').then((value) {
            setState(() {
              _isLoadingUnidade = false;
            });
          })
        : setState(() {
            _isLoadingUnidade = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];
    List<Medicos> medicos = [];
    List<Especialidade> especialidades = [];
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

    dados.map((e) {
      Medicos med = Medicos();
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;
      med.cod_especialidade = e.cod_especialidade;
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

      if (!EspecialidadesInclusas.contains(e.cod_especialidade)) {
        EspecialidadesInclusas.add(e.cod_especialidade);
        especialidades.add(Especialidade(
            codespecialidade: e.cod_especialidade,
            descricao: e.des_especialidade,
            ativo: 'S'));
      }
    }).toList();
    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    especialidades.sort((a, b) => a.descricao.compareTo(b.descricao));

    return _isLoading && _isLoadingAgendamento && _isLoadingUnidade
        ? Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Aguarde...',
                  ),
                  Text('Buscando especialistas próximos'),
                ]),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: CustomAppBar('Meu\n', 'Bioma', () {
                  setState(() {
                    pages.selecionarPaginaHome('Especialistas');
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                }, []),
              ),
            ),
            drawer: AppDrawer(),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: RefreshIndicator(
                  onRefresh: () async {
                    AlertShowDialog('title', 'msg', context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Divider(),
                      MeuBioma(),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          focusColor: redColor,
                          onTap: () {
                            setState(() {
                              pages.selecionarPaginaHome('Especialistas');
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 8,
                            color: primaryColor,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Nova Indicação',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // cardIndicacao(),
                      EspecialidadesView(especialidade: especialidades),
                      RecommendedDoctors(medicos: medicos),

                      // AvailableDoctors(),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      HistoricoProcedimentosView(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
