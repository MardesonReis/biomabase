import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class BuscaMedicos extends StatefulWidget {
  VoidCallback press;
  BuscaMedicos({Key? key, required this.press}) : super(key: key);

  @override
  State<BuscaMedicos> createState() => _BuscaMedicosState();
}

class _BuscaMedicosState extends State<BuscaMedicos> {
  late ScrollController scroll_controller;
  Set<String> MedicosInclusos = Set();

  @override
  void initState() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    b() {
      setState(() {
        dt.seemore = true;
      });
      dt.buscar(context).then((value) {
        setState(() {
          dt.seemore = false;
          ;
        });
      });
    }

    ;
    scroll_controller = ScrollController()..addListener(b);
  }

  void dispose() {
    scroll_controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context);
    final dados = dt.dados;
    List<Medicos> medicos = [];
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
    return SingleChildScrollView(
      controller: scroll_controller,
      key: Key('Especialistas'),
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            filtrosScreen(press: widget.press),
            searchScreen(press: widget.press),
            Column(
              children: List.generate(
                medicos.length,
                (i) => DoctorInfor(
                  doctor: medicos[i],
                  press: () async {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsScreen(
                            doctor: medicos[i],
                            press: () {
                              //   if (!mounted) return;
                              setState(() {});
                            },
                          ),
                        ),
                      ).then((value) => {
                            setState(() {}),
                          });
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
