import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/heightlight.dart';
import 'package:biomaapp/components/rating.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/home/components/botton_menu.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_grid.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Medicos doctor;
  final VoidCallback press;

  DoctorDetailsScreen({Key? key, required this.doctor, required this.press})
      : super(key: key);

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    DataList Data = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;
    Set<String> UnidadesInclusoIncluso = Set();
    Set<String> ConveniosInclusoIncluso = Set();
    Set<String> EspecialidadesInclusoIncluso = Set();
    Set<String> SubEspecialidadesInclusoIncluso = Set();
    Set<String> GruposInclusoIncluso = Set();
    List<Unidade> unidadeslist = [];
    List<Especialidade> especialidadeslist = [];
    List<SubEspecialidade> subespecialidadeslist = [];
    List<Grupo> gruposlist = [];
    List<Convenios> convenioslist = [];
    Set<String> convenios = Set();
    filtrosAtivos filtros = auth.filtrosativos;
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    // print(Data.items.length);
    final dados = Data.items;

    dados.retainWhere((element) {
      return filtrarUnidade
          ? filtros.unidades.contains(Unidade(
              cod_unidade: element.cod_unidade,
              des_unidade: element.des_unidade))
          : true;
    });

    dados.retainWhere((element) {
      return element.cod_profissional.contains(widget.doctor.cod_profissional);
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
      return element.des_profissional
          .toLowerCase()
          .contains(txtQuery.text.toLowerCase());
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });
    dados.map((e) {
      if (!UnidadesInclusoIncluso.contains(e.cod_unidade)) {
        UnidadesInclusoIncluso.add(e.cod_unidade);
        unidadeslist.add(
            Unidade(cod_unidade: e.cod_unidade, des_unidade: e.des_unidade));
      }

      if (!ConveniosInclusoIncluso.contains(e.cod_convenio)) {
        ConveniosInclusoIncluso.add(e.cod_convenio);

        convenioslist.add(Convenios(
            cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio));
      }
      if (!GruposInclusoIncluso.contains(e.grupo)) {
        GruposInclusoIncluso.add(e.grupo);

        gruposlist.add(Grupo(descricao: e.grupo));
      }
      if (!EspecialidadesInclusoIncluso.contains(e.cod_especialidade)) {
        EspecialidadesInclusoIncluso.add(e.cod_especialidade);

        especialidadeslist.add(Especialidade(
            codespecialidade: e.cod_especialidade,
            descricao: e.des_especialidade,
            ativo: 'S'));
      }
      if (!SubEspecialidadesInclusoIncluso.contains(e.sub_especialidade)) {
        SubEspecialidadesInclusoIncluso.add(e.sub_especialidade);

        subespecialidadeslist
            .add(SubEspecialidade(descricao: e.sub_especialidade));
      }
    }).toList();

    especialidadeslist.sort((a, b) => a.descricao.compareTo(b.descricao));
    unidadeslist.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));
    convenioslist.sort((a, b) => a.desc_convenio.compareTo(b.desc_convenio));
    gruposlist.sort((a, b) => a.descricao.compareTo(b.descricao));
    subespecialidadeslist.sort((a, b) => a.descricao.compareTo(b.descricao));

    return Scaffold(
      //bottomNavigationBar: BottonMenu(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: CustomAppBar(
            '', 'Dr(a) ' + widget.doctor.des_profissional.capitalize(), () {}, [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Todos os Médicos',
            onPressed: () {
              // handle the press
              pages.selecionarPaginaHome('Serviços');
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_OR_HOME,
              );
            },
          ),
        ]),
      ),

      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            //    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PopMenuConvenios(() {
                        setState(() {});
                      }),
                      PopMenuEspecialidade(() {
                        setState(() {});
                      }),
                      PopMenuSubEspecialidades(() {
                        setState(() {});
                      }),
                      PopMenuGrupo(() {
                        setState(() {});
                      }),
                      PopoMenuUnidades(() {
                        setState(() {});
                      })
                    ],
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
                ProcedimentoGrid(widget.doctor, txtQuery.text, widget.press),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
