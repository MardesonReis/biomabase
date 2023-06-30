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
import 'package:biomaapp/models/redebioma.dart';
import 'package:biomaapp/models/redebioma_list.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/home/components/cardRede.dart';
import 'package:biomaapp/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recommended_doctor_card.dart';
import '../../../models/RecommendDoctor.dart';

class RedeBiomaViwer extends StatefulWidget {
  VoidCallback press;
  RedeBiomaViwer({Key? key, required this.press}) : super(key: key);

  @override
  State<RedeBiomaViwer> createState() => _RedeBiomaViwerState();
}

class _RedeBiomaViwerState extends State<RedeBiomaViwer> {
  bool _isLoading = true;
  int _currentPage = 0;

  PageController pgControle =
      PageController(viewportFraction: 0.85, initialPage: 3);
  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var rede = Provider.of<RedeBiomaList>(
      context,
      listen: false,
    );

    rede.ListarRede('0').then((value) {
      setState(() {
        _startTimer(rede.items);
        _isLoading = false;
      });
    });

    // super.initState();
  }

  void _startTimer(List<RedeBioma> _pages) {
    Future.delayed(Duration(seconds: 10)).then((_) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      pgControle.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _startTimer(_pages);
    });
  }

  @override
  Widget build(BuildContext context) {
    RedeBiomaList rede = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);

    return _isLoading
        ? CircularProgressIndicator()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: SectionTitle(
                  title: "Rede Bioma",
                  pressOnSeeAll: () {
                    setState(() {
                      //  pages.selecionarPaginaHome('Especialistas');
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
                aspectRatio: 2.3,
                child: PageView.builder(
                  controller: pgControle,
                  onPageChanged: (value) {},
                  itemCount: rede.items.length,
                  itemBuilder: (context, index) => CardRede(
                    Redeitem: rede.items[index],
                  ),
                ),
              ),
            ],
          );
  }
}
