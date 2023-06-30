import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
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
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/procedimento_list.dart';
import 'package:biomaapp/models/regras_list.dart';
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
import 'package:biomaapp/screens/procedimentos/procedimento_grid_item.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_grid.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
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
  bool filterViewer = false;
  Future? _initialLoad;

  iniciarBusca() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    setState(() {
      dt.isLoading = true;
      dt.seemore = true;
      dt.limparDados();
    });
    dt.buscar(context).then((value) {
      setState(() {
        dt.seemore = false;

        dt.isLoading = false;
      });
    });
  }

  void initState() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    //txtQuery.text = dt.like;
    setState(() {
      dt.limit = false;
      dt.offset.clear();
    });
    _initialLoad = iniciarBusca();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;

    var busca = !dt.isLoading && dt.dados.isEmpty;
    List<Procedimento> procedimentos = dt
        .returnProcedimentos(widget.doctor.cod_profissional)
        .where((element) => element.des_procedimentos
            .toUpperCase()
            .contains(txtQuery.text.toUpperCase()))
        .toList();
    return Scaffold(
        //bottomNavigationBar: BottonMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Wrap(
          children: [
            if (dt.seemore == true || dt.isLoading == true)
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(child: ProgressIndicatorBioma())),
          ],
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(tela(context).height * (0.25)),
            child: Container(
              child: Column(
                children: [
                  CustomAppBar(
                      'Dr(a)\n', widget.doctor.des_profissional, () {}, []),
                  filtrosScreen(press: () {
                    // dt.limparDados();
                    iniciarBusca();
                  }),
                  Card(
                    elevation: 8,
                    // color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (event) async {
                          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                            iniciarBusca();
                          }
                        },
                        child: TextFormField(
                          //initialValue: dt.like,
                          keyboardType: TextInputType.text,
                          controller: txtQuery,
                          onChanged: (String) async {
                            setState(() {
                              // dt.like = String;
                              //  widget.press.call();
                            });
                          },
                          onFieldSubmitted: (text) async {
                            iniciarBusca();
                          },
                          decoration: InputDecoration(
                            hintText: "Buscar Serviços, Especialistas...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                dt.buscar(context);
                              },
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () async {
                                setState(() {
                                  mockResults.clear();
                                  // dt.limparDados();
                                  // dt.like = '';
                                  //widget.press.call();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: busca
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                        'Nada encontrado para o termo de busca informado')),
              )
            : FutureBuilder(
                future: dt.loadMore(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    //  return Center(child: ProgressIndicatorBioma());

                    case ConnectionState.done:
                      return IncrementallyLoadingListView(
                        //  controller: scroll_controller,
                        hasMore: () => !dt.limit,
                        loadMore: () async {
                          await dt.loadMore(context);
                        },
                        itemBuilder: (context, index) {
                          return ProcedimentosInfor(
                            procedimento: procedimentos[index],
                            press: () {
                              setState(() {
                                filtros.medicos.clear();
                                filtros.medicos.add(widget.doctor);
                                filtros.procedimentos.clear();
                                filtros.procedimentos.add(procedimentos[index]);
                                widget.press.call();
                              });
                            },
                          );
                        },
                        itemCount: () => procedimentos.length,
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
              ));
  }
}
