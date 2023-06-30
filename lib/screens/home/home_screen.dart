import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/appointment/componets/historico_procedimentos_view.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/screens/home/components/RedeBiomaViwer.dart';
import 'package:biomaapp/screens/home/components/card_especialidades.dart';
import 'package:biomaapp/screens/home/components/meu_bioma.dart';
import 'package:biomaapp/screens/home/components/recommended_doctors.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:biomaapp/screens/saude/minhasaudePage.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'package:flutter/material.dart';

import '../../components/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    auth.atualizaAcesso(context, () {
      CarregarDados();
    });

    super.initState();
  }

  CarregarDados() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    dt.buscar(context).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    EspecialidadesList especialidadesList = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.dados;
    List<Medicos> medicos = dt.returnMedicos('');
    List<Especialidade> especialidades = especialidadesList.items;
    return _isLoading
        ? Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProgressIndicatorBioma()]),
          )
        : Scaffold(
            appBar: CustomAppBar('Meu\n', 'Bioma', () {
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
            drawer: AppDrawer(),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: RefreshIndicator(
                  onRefresh: () async {
                    AlertShowDialog('title', Text(''), context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Divider(),
                      if (auth.isAuth) MeuBioma(),
                      if (!auth.isAuth)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthPage(
                                  func: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AuthOrHomePage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: primaryColor,
                              child: Center(
                                child: ListTile(
                                  leading: Image.asset(
                                      'assets/imagens/biomaLogo.png',
                                      width: 30),
                                  title: Text(
                                    'Bem Vindo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                  ),
                                  subtitle: Text(
                                      'O Bioma ajuda você a cuidar da sua saúde, '
                                      'buscar serviços e especialistas e  acumular Bions '
                                      'que você pode trocar por serviços. Clique para fazer login',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12)),
                                  trailing: Icon(Icons.login),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Divider(),
                      if (auth.isAuth)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            focusColor: redColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MinhaSaudePage(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              color: primaryColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Minha Saúde',
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
                                        Icons.medical_information,
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
                      EspecialidadesView(),
                      RecommendedDoctors(
                        press: () {
                          setState(() {});
                        },
                      ),
                      RedeBiomaViwer(
                        press: () {
                          setState(() {});
                        },
                      ),

                      // AvailableDoctors(),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      //HistoricoProcedimentosView(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
