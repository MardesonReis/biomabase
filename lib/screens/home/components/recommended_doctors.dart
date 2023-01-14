import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
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
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recommended_doctor_card.dart';
import '../../../models/RecommendDoctor.dart';

class RecommendedDoctors extends StatefulWidget {
  RecommendedDoctors({Key? key, required this.medicos}) : super(key: key);
  List<Medicos> medicos;

  @override
  State<RecommendedDoctors> createState() => _RecommendedDoctorsState();
}

class _RecommendedDoctorsState extends State<RecommendedDoctors> {
  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SectionTitle(
            title: "Especialistas Disponíveis",
            pressOnSeeAll: () {
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
            OnSeeAll: true,
          ),
        ),
        AspectRatio(
          aspectRatio: 2.5,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85, initialPage: 3),
            itemCount: widget.medicos.length,
            itemBuilder: (context, index) => RecommendDoctorCard(
              doctor: widget.medicos[index],
            ),
          ),
        ),
      ],
    );
  }
}
