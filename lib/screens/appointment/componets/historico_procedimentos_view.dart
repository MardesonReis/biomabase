import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/appointment/componets/historico_procedimentos_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/historico_procedimentos.dart';
import '../../../constants.dart';

class HistoricoProcedimentosView extends StatefulWidget {
  HistoricoProcedimentosView({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoricoProcedimentosView> createState() =>
      _HistoricoProcedimentosViewState();
}

class _HistoricoProcedimentosViewState
    extends State<HistoricoProcedimentosView> {
  bool _isLoading = true;
  List<Agendamentos> Filtrados = [];
  Set<String> AgendamentosInclusos = Set();
  PageController _pageController =
      PageController(viewportFraction: 0.9, initialPage: 1);

  var _curr = 0;

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    AgendamentosList dados = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    dados.items.isEmpty
        ? dados
            .loadAgendamentos(auth.fidelimax.cpf.toString(), '0', '0', '0')
            .then((value) => setState(() {
                  _isLoading = false;
                }))
        : setState(() {
            _isLoading = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    filtrosAtivos filtros = auth.filtrosativos;
    AgendamentosList list = Provider.of(context, listen: false);
    List<Agendamentos> dados = list.items;
    AgendamentosInclusos.clear();
    Filtrados.clear();
    dados.map((e) {
      if (!AgendamentosInclusos.contains(
          e.des_status_agenda.trim().toUpperCase())) {
        // debugPrint(e.status.trim());
        AgendamentosInclusos.add(e.des_status_agenda.trim().toUpperCase());
        Filtrados.add(e);
      }
      ;
    }).toList();

    return _isLoading
        ? CircularProgressIndicator()
        : Filtrados.isEmpty
            ? SectionTitle(
                title: ('Sem histórico para exibir').capitalize(),
                pressOnSeeAll: () {},
                OnSeeAll: true,
              )
            : Container(
                child: Column(
                  children: [
                    SectionTitle(
                      title: ('Procedimentos ' +
                              StatusAgenda[Filtrados[_curr].des_status_agenda]
                                  .toString() +
                              's')
                          .capitalize(),
                      pressOnSeeAll: () {},
                      OnSeeAll: false,
                    ),
                    AspectRatio(
                      aspectRatio: 2 / 1,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (num) {
                          setState(() {
                            _curr = num;
                          });
                        },
                        //  PageController(viewportFraction: 0.85, initialPage: 0),
                        itemCount: AgendamentosInclusos.length,
                        itemBuilder: (context, index) {
                          //     debugPrint(_pageController.page.toString());
                          return HistoricoProcedimentosCard(
                              agendamentos: dados
                                  .where((element) =>
                                      element.des_status_agenda ==
                                      Filtrados[index].des_status_agenda)
                                  .toList());
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
  }
}
