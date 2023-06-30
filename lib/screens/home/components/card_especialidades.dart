import 'package:biomaapp/models/Category.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/especialidades/especialidades_screen.dart';
import 'package:biomaapp/screens/home/components/EspecialidadesCard.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:biomaapp/screens/servicos/componets/menuEspecialistas.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class EspecialidadesView extends StatefulWidget {
  EspecialidadesView({Key? key}) : super(key: key);

  @override
  State<EspecialidadesView> createState() => _EspecialidadesViewState();
}

class _EspecialidadesViewState extends State<EspecialidadesView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<EspecialidadesList>(
      context,
      listen: false,
    ).loadEspecialidade('').then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    EspecialidadesList especialidades = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();

    return _isLoading
        ? CircularProgressIndicator()
        : Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SectionTitle(
                    title: "Especialidades",
                    pressOnSeeAll: () {
                      setState(() {
                        pages.selecionarPaginaHome('Especialistas');
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuEspecialista(),
                        ),
                      );
                    },
                    OnSeeAll: true,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Wrap(
                      spacing: 1.0, // gap between adjacent chips
                      runSpacing: 1.0, // gap between lines
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        especialidades.items.length,
                        (index) => Center(
                          child: EspecialidadesCard(
                            esp: especialidades.items[index],
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuEspecialista(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
