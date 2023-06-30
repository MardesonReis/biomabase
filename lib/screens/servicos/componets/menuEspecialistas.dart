import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuEspecialista extends StatefulWidget {
  MenuEspecialista({Key? key}) : super(key: key);

  @override
  State<MenuEspecialista> createState() => _MenuEspecialistaState();
}

class _MenuEspecialistaState extends State<MenuEspecialista> {
  bool filterViewer = false;
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    RegrasList dt = Provider.of(context);
    iniciarBusca() {
      if (dt.limit) {
        return false;
      }
      setState(() {
        dt.isLoading = true;
        dt.seemore = true;

        if (dt.like.isEmpty) {
          dt.like = 'Consulta';
        }
        dt.buscar(context).then((value) {
          setState(() {
            dt.seemore = false;

            dt.isLoading = false;
          });
        });
      });
    }

    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      drawer: AppDrawer(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(tela(context).height * (0.35)),
          child: Container(
            child: Column(
              children: [
                CustomAppBar('Buscar\n', 'Especialistas', () {}, []),
                filtrosScreen(press: () {
                  setState(() {
                    filtros.medicos.clear();
                    dt.limparDados();
                    iniciarBusca();
                  });
                }),
                FiltroAtivosScren(press: () {
                  setState(() {
                    dt.limparDados();

                    iniciarBusca();
                  });
                }),
                searchScreen(press: () {
                  setState(() {});
                }),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Wrap(
        children: [
          if (dt.seemore == true || dt.isLoading == true)
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(child: ProgressIndicatorBioma())),
        ],
      ),
      body: EspecialistasScreenn(press: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(
              doctor: filtros.medicos.first,
              press: () {
                //   if (!mounted) return;

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
              },
            ),
          ),
        ).then((value) => {
              setState(() {}),
            });
      }, refreshPage: () {
        setState(() {});
      }),
    );
  }
}
