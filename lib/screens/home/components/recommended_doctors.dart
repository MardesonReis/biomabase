import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
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
  VoidCallback press;
  RecommendedDoctors({Key? key, required this.press}) : super(key: key);

  @override
  State<RecommendedDoctors> createState() => _RecommendedDoctorsState();
}

class _RecommendedDoctorsState extends State<RecommendedDoctors> {
  bool _isLoading = true;

  PageController pgControle =
      PageController(viewportFraction: 0.85, initialPage: 1);
  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    dt.loadMore(context).then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;
    List<Medicos> medicos = dt.returnMedicos('');

    return _isLoading
        ? CircularProgressIndicator()
        : Column(
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
                  OnSeeAll: false,
                ),
              ),
              AspectRatio(
                aspectRatio: 2.5,
                child: PageView.builder(
                  controller: pgControle,
                  onPageChanged: (value) {
                    if (medicos.length > 3) {
                      if (value >= medicos.length - 3 && dt.limit == false) {
                        dt.loadMore(context).then((value) {
                          setState(() {
                            widget.press.call();
                          });
                        });
                      }
                    }
                  },
                  itemCount: medicos.length,
                  itemBuilder: (context, index) => RecommendDoctorCard(
                    doctor: medicos[index],
                  ),
                ),
              ),
            ],
          );
  }
}
