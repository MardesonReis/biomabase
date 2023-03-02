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
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context, listen: false);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];
    List<Medicos> medicos = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarMedicos = filtros.medicos.isNotEmpty;
    var filtrarProcedimento = filtros.procedimentos.isNotEmpty;

    final dados = dt.dados;
    dados.retainWhere((element) {
      return filtrarProcedimento
          ? element.cod_procedimentos == widget.procedimentos.cod_procedimentos
          : true;
    });
    dados.retainWhere((element) {
      return filtrarProcedimento
          ? double.parse(element.valor_sugerido) ==
              widget.procedimentos.valor_sugerido
          : true;
    });
    if (filtrarMedicos) {
      dados.retainWhere((element) {
        return filtros.medicos
            .where((m) => m.cod_profissional == element.cod_profissional)
            .isNotEmpty;
      });
    }

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
      med.especialidade = Especialidade(
          codespecialidade: e.cod_especialidade,
          descricao: e.des_especialidade,
          ativo: 'S');

      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }
    }).toList();
    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('',
              widget.procedimentos.des_procedimentos.capitalize(), () {}, [])),
      //drawer: AppDrawer(),
      onDrawerChanged: (bool) {
        setState(() {
          widget.press.call();
        });
      },
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    ProcedimentosInfor(
                        procedimento: widget.procedimentos, press: () {}),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              medicos.length.toString() + ' - Especialista(s)',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Realiza(m) esse procedimento ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )
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
                          hintText: "Buscar Especialistas",
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
                      padding: const EdgeInsets.all(defaultPadding),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: medicos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).orientation.name ==
                                      'portrait'
                                  ? 2
                                  : 4,
                          crossAxisSpacing: defaultPadding,
                          mainAxisSpacing: defaultPadding,
                        ),
                        itemBuilder: (context, index) => DoctorCard(
                            doctor: medicos[index],
                            press: () {
                              filtros.LimparMedicos();
                              filtros.addMedicos(medicos[index]);
                              filtros.LimparProcedimentos();
                              filtros.AddProcedimentos(widget.procedimentos);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(
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
                  ],
                ),
              ),
            ),
    );
  }
}
