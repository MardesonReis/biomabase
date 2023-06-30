import 'dart:async';

import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
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
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/home/components/card_especialidades.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class EspecialistasScreenn extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  EspecialistasScreenn(
      {Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<EspecialistasScreenn> createState() => _EspecialistasScreenState();
}

class _EspecialistasScreenState extends State<EspecialistasScreenn> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  final ScrollController controller = ScrollController();
  final StreamController _stream = StreamController.broadcast();
  late ScrollController scroll_controller = ScrollController();
  late ScrollNotification _notification;
  Future? _initialLoad;

  @override
  void initState() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    _initialLoad = dt.loadMore(context).then((value) {
      setState(() {});
    });
    super.initState();
  }

  void dispose() {
    _stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context);

    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    List<Medicos> medicos = dt.returnMedicos('');

    // medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    var busca = dt.seemore == false && dt.like.isNotEmpty && dt.dados.isEmpty;

    var a;

    a = dt.like.trim().isEmpty
        ? a = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Informe termos para busca')),
          )
        : a = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text('Nada encontrado para o termo de busca informado')),
          );

    return busca
        ? a
        : FutureBuilder(
            future: _initialLoad,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                // return Center(child: ProgressIndicatorBioma());

                case ConnectionState.done:
                  return IncrementallyLoadingListView(
                    //  controller: scroll_controller,
                    hasMore: () => !dt.limit,
                    loadMore: () async {
                      await dt.loadMore(context);
                    },
                    itemBuilder: (context, index) {
                      return DoctorInfor(
                        doctor: medicos[index],
                        press: () async {
                          setState(() {
                            widget.press.call();
                          });
                        },
                      );
                    },
                    itemCount: () => medicos.length,
                    onLoadMore: () {
                      setState(() {
                        dt.seemore = true;
                      });
                    },
                    onLoadMoreFinished: () {
                      setState(() {
                        dt.seemore = false;
                      });
                    },
                    separatorBuilder: (_, __) => Divider(),
                    loadMoreOffsetFromBottom: 2,
                  );
                  break;
                default:
                  return Text('Tem algo errado, verifique sua internet');
              }
            },
          );
  }
}
