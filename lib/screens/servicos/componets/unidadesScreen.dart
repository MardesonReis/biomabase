import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';

import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/procedimentos/procedimentosCircle.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/search/components/menu_bar_unidades.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnidadesScreen extends StatefulWidget {
  UnidadesScreen({Key? key}) : super(key: key);

  @override
  State<UnidadesScreen> createState() => _UnidadesScreenState();
}

class _UnidadesScreenState extends State<UnidadesScreen> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var unlist = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    auth.atualizaAcesso(context, () {
      setState(() {
        unlist.items.isEmpty
            ? unlist.loadUnidades('').then((value) {
                setState(() {
                  _isLoading = false;
                });
              })
            : setState(() {
                _isLoading = false;
              });
      });
    }).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);
    UnidadesList unidadeslist = Provider.of(context);
    final dadosunidades = unidadeslist.items;
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> EspecialidadesInclusas = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> MedicosInclusos = Set();
    Set<String> UnidadesIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Procedimento> HistoricoProcedimentos = [];
    List<Procedimento> procedimentos = dt.returnProcedimentos('');
    List<Medicos> medicos = dt.returnMedicos('');
    List<Unidade> unidades = dt.returnUnidades(unidadeslist.items);

    var cod_unidade = '';
    if (filtros.unidades.isNotEmpty) {
      cod_unidade = filtros.unidades.first.cod_unidade;
    }
    if (filtros.unidades.isEmpty && unidades.isNotEmpty) {
      cod_unidade = unidades.first.cod_unidade;
    }

    return _isLoading
        ? Center(child: ProgressIndicatorBioma())
        : Scaffold(
            appBar: AppBar(
              title: Text(filtros.unidades.isNotEmpty
                  ? filtros.unidades.last.des_unidade +
                      ' - ' +
                      filtros.unidades.last.bairro.capitalize() +
                      ' - ' +
                      filtros.unidades.last.municipio.capitalize()
                  : ' '),
            ),
            body: Container(
              //  height: MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                              'https://biotvindoor.com/bioma/imagens/unidades/' +
                                  cod_unidade +
                                  '.jpg'),
                          fit: BoxFit.cover,
                        )),
                        child: Column(
                          children: [
                            filtrosScreen(press: () {
                              setState(() {});
                            })
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: txtQuery,
                        onChanged: (String) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Buscar",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              txtQuery.text = '';
                              setState(() {
                                mockResults.clear();
                                //buscarQuery(txtQuery.text);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: "Especialistas",
                        pressOnSeeAll: () {
                          setState(() {
                            pages.selecionarPaginaHome('Especialistas');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorsScreen(),
                            ),
                          );
                        },
                        OnSeeAll: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            medicos.length,
                            (index) => DoctorInforCicle(
                                doctor: medicos[index],
                                press: () {
                                  setState(() {
                                    filtros.LimparMedicos();
                                    filtros.addMedicos(medicos[index]);
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDetailsScreen(
                                        doctor: medicos[index],
                                        press: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ).then((value) => {
                                        setState(() {}),
                                      });
                                }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: "Todos os Procedimentos",
                        pressOnSeeAll: () {
                          setState(() {
                            pages.selecionarPaginaHome('Especialistas');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorsScreen(),
                            ),
                          );
                        },
                        OnSeeAll: true,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(
                          procedimentos.length,
                          (index) => ProcedimentosInfor(
                            procedimento: procedimentos[index],
                            press: () {
                              setState(() {
                                filtros.LimparProcedimentos();
                                filtros.AddProcedimentos(procedimentos[index]);
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProcedimentosScrennViwer(
                                    procedimentos: procedimentos[index],
                                    press: () {
                                      setState(() {
                                        filtros.LimparProcedimentos();
                                        filtros.AddProcedimentos(
                                            procedimentos[index]);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            update: () {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
