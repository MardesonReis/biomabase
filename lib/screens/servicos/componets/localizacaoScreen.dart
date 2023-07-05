import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/unidadesScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

//import 'package:vector_math/vector_math.dart';

class LocalizacaoScreen extends StatefulWidget {
  LocalizacaoScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacaoScreen> createState() => _LocalizacaoScreenState();
}

class _LocalizacaoScreenState extends State<LocalizacaoScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _position = LatLng(-3.613425981453625, -38.53529385675654);
  Set<Marker> _marker = Set<Marker>();
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  //final ScrollController controller = ScrollController();
  final StreamController _stream = StreamController.broadcast();
  late GoogleMapController controller;
  double latitude = -3.792303806385164;
  double longitude = -38.603039058733025;
  double zoom = 9;
  List<Regra> regras = [];
  Set<Marker> marker = Set<Marker>();
  // bool _isLoading = true;
  GlobalKey globalKey = GlobalKey();
  //late Position _currentPosition;
  //TextEditingController txtQuery = new TextEditingController();
  int count = 0;

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }

  void _refreshPage() {
    setState(() {
      _stream.sink.add(null);
    });
  }

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    AgendamentosList agenda = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );

    var RegraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    //13978829304
    filtrosAtivos filtros = auth.filtrosativos;
    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    auth.atualizaAcesso(context, () {
      setState(() {
        ListUnidade.items.isEmpty
            ? ListUnidade.loadUnidades('').then((value) {
                setState(() {
                  _isLoading = false;
                });
              })
            : setState(() {
                _isLoading = false;
              });
      });
    }).then((value) {
      setState(() {});
    });
  }

  double zoomVal = 8;

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);
    UnidadesList BancoDeUnidades = Provider.of(context);
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    Paginas pages = auth.paginas;

    Set<String> EspecialidadesInclusas = Set();
    Set<String> UnidadesInclusoIncluso = Set();
    Set<String> UltimasUnidadesIncluso = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> MedicosInclusos = Set();
    Set<String> UnidadesIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Unidade> HistoricoUnidades = [];
    List<Unidade> unidades = [];

    List<Medicos> medicos = [];
    List<Procedimento> HistoricoProcedimentos = [];
    List<Procedimento> procedimentos = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarMedico = filtros.medicos.isNotEmpty;
    final dados = dt.dados;

    // dados.retainWhere((element) {
    //   return filtrarUnidade
    //       ? filtros.unidades.contains(Unidade(
    //           cod_unidade: element.cod_unidade,
    //           des_unidade: element.des_unidade))
    //       : true;
    // });
    if (_controller.future == null) {
      setState(() {
        //   _buildGoogleMap();
      });
    }
    dados.retainWhere((element) {
      return element.textBusca
          .toUpperCase()
          .contains(txtQuery.text.toUpperCase());
    });

    // dados.retainWhere((element) {
    //   return filtrarConvenio
    //       ? filtros.convenios.contains(Convenios(
    //           cod_convenio: element.cod_convenio,
    //           desc_convenio: element.desc_convenio))
    //       : true;
    // });
    // dados.retainWhere((element) {
    //   return filtrarEspecialidade
    //       ? filtros.especialidades.contains(Especialidade(
    //           codespecialidade: element.cod_especialidade,
    //           descricao: element.des_especialidade,
    //           ativo: 'S'))
    //       : true;
    // });
    // dados.retainWhere((element) {
    //   return filtrarSubEspecialidade
    //       ? filtros.subespecialidades
    //           .contains(SubEspecialidade(descricao: element.sub_especialidade))
    //       : true;
    // });

    // dados.retainWhere((element) {
    //   return filtrarGrupos
    //       ? filtros.grupos.contains(Grupo(descricao: element.grupo))
    //       : true;
    // });

    unidades.sort((a, b) => a.distancia.compareTo(b.distancia));

    dados.map((e) {
      Procedimento p = Procedimento();
      p.convenio = Convenios(
          cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio);

      p.cod_procedimento = e.cod_procedimentos;
      p.des_procedimento = e.des_procedimentos;
      p.valor = double.parse(e.valor);
      p.grupo = e.grupo;
      p.frequencia = e.frequencia;
      p.quantidade = e.tabop_quantidade;
      p.especialidade.cod_especialidade = e.cod_especialidade;
      p.especialidade.des_especialidade = e.des_especialidade;
      p.cod_tratamento = e.cod_tratamento;
      p.des_tratamento = e.tipo_tratamento;
      var especialidade = Especialidade(
          cod_especialidade: e.cod_especialidade,
          des_especialidade: e.des_especialidade,
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

      Unidade unidade = Unidade();
      unidade.cod_unidade = e.cod_unidade;
      unidade.des_unidade = e.des_unidade;

      if (!UnidadesInclusoIncluso.contains(e.cod_unidade)) {
        UnidadesInclusoIncluso.add(e.cod_unidade);

        if (BancoDeUnidades.items.isNotEmpty) {
          var u = BancoDeUnidades.items
              .where((element) => element.cod_unidade == unidade.cod_unidade)
              .toList()
              .first;
          //  u.distancia = await getDistance(unidade.latitude, unidade.l atitude);

          unidades.add(u);
        }
      }

      if (!ProcedimentosInclusoIncluso.contains(e.cod_procedimentos)) {
        ProcedimentosInclusoIncluso.add(e.cod_procedimentos);
        procedimentos.add(p);
      }
      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }
      // if (!UnidadesIncluso.contains(e.cod_unidade)) {
      //   UnidadesIncluso.add(e.cod_unidade);
      //   unidades.add(unidade);
      // }
    }).toList();
    unidades.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));
    double aut = MediaQuery.of(context).size.height * 0.2;
    return Container(
        // ignore: unnecessary_new
        child: new Scaffold(
      extendBodyBehindAppBar: true,
      drawer: AppDrawer(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Buscar\n', 'Serviços', () {}, [])),
      key: globalKey,
      body: Container(
        child: _isLoading
            ? Center(child: ProgressIndicatorBioma())
            : GoogleMap(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                trafficEnabled: false,
                indoorViewEnabled: true,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: _position, zoom: zoom),
                onMapCreated: OnMapCreated,
                markers: retornarMakers(unidades, filtros),
              ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: txtQuery.text.isNotEmpty && dados.isNotEmpty
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.centerTop,

      // : FloatingActionButtonLocation.centerTop,
      backgroundColor: primaryColor,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: aut, left: 15, right: 15),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //   color: redColor,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: txtQuery,
                          onChanged: (String) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.7),
                            ),
                            hoverColor: Colors.white,
                            hintText: "Buscar Serviços, Especialistas...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            focusColor: Colors.white,
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                txtQuery.text = '';
                                setState(() {
                                  mockResults.clear();
                                  //buscarQuery(txtQuery.text);
                                });
                                //  widget.press.call();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (txtQuery.text.isNotEmpty && medicos.isNotEmpty)
                      Column(
                        children: [
                          Card(
                            child: ListTile(
                              hoverColor: Colors.yellow,
                              tileColor: Colors.yellow,
                              trailing: Icon(Icons.search),
                              title: Text('Especialistas',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {},
                            ),
                          ),
                          SingleChildScrollView(
                            key: Key('Especialistas'),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  medicos.length,
                                  (index) => DoctorInforCicle(
                                      doctor: medicos[index],
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorDetailsScreen(
                                              doctor: medicos[index],
                                              press: () {
                                                //   if (!mounted) return;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ).then((value) => {
                                              setState(() {}),
                                            });
                                      })),
                            ),
                          ),
                        ],
                      ),
                    if (txtQuery.text.isNotEmpty && procedimentos.isNotEmpty)
                      Column(
                        children: [
                          Card(
                            child: ListTile(
                              hoverColor: Colors.yellow,
                              tileColor: Colors.yellow,
                              trailing: Icon(Icons.search),
                              title: Text('Procedimentos',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {},
                            ),
                          ),
                          Column(
                            children: List.generate(
                                procedimentos.length,
                                (index) => ProcedimentosInfor(
                                      procedimento: procedimentos[index],
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProcedimentosScrennViwer(
                                              procedimentos:
                                                  procedimentos[index],
                                              press: () {},
                                            ),
                                          ),
                                        );
                                      },
                                      update: () {
                                        setState(() {});
                                      },
                                    )),
                          ),
                        ],
                      ),
                    if (txtQuery.text.isNotEmpty && unidades.isNotEmpty)
                      Column(
                        children: [
                          Card(
                            child: ListTile(
                              hoverColor: Colors.yellow,
                              tileColor: Colors.yellow,
                              trailing: Icon(Icons.search),
                              title: Text('Locais de Atendimento',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {},
                            ),
                          ),
                          Column(
                            children: List.generate(
                                unidades.length,
                                (index) => InforUnidade(
                                      unidades[index],
                                      () {
                                        filtros.LimparUnidade();
                                        filtros.addunidades(unidades[index]);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UnidadesScreen(),
                                          ),
                                        ).then((value) => {
                                              setState(() {}),
                                            });
                                      },
                                    )),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void OnMapCreated(GoogleMapController gmc) async {
    if (!mounted) return;

    MinhaLocalizacao().then((value) async {
      var position = await determinePosition().then((value) {
        try {
          gmc
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(
                    _position.latitude,
                    _position.longitude,
                  ),
                  zoom: 10)))
              .then((value2) {
            setState(() {
              _position = value;
              _controller.complete(gmc);
            });
          });
        } on FormatException catch (err) {
          if (!mounted) return;
          // print(err);
          setState(() {});
          //setState(() => _err = err);
        }
      });
    });
  }

  Future<void> MinhaLocalizacao() async {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    // double distance = await Geolocator.distanceBetween(
    //     latitude, longitude, _position.latitude, _position.latitude);

    final Marker mkr = Marker(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnidadesScreen(),
            ),
          ).then((value) => {
                setState(() {}),
              });
        },
        markerId: MarkerId(DateTime.now().toString()),
        position: _position,
        icon: filtros.markerIcon,
        infoWindow:
            InfoWindow(title: 'Minha Localização', snippet: 'Fortaleza/CE'));

    final Marker mkr2 = Marker(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnidadesScreen(),
            ),
          ).then((value) => {
                setState(() {}),
              });
        },
        markerId: MarkerId(DateTime.now().toString()),
        position: LatLng(latitude, longitude),
        icon: filtros.markerIcon,
        infoWindow:
            InfoWindow(title: 'Minha Localização', snippet: 'Fortaleza/CE'));

    setState(() {
      marker.add(mkr);
      marker.add(mkr2);
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          _position.latitude,
          _position.longitude,
        ),
        zoom: zoom)));
    setState(() {
      _isLoading = false;
    });
  }

  Set<Marker> retornarMakers(List<Unidade> unidades, filtrosAtivos filtros) {
    Set<Marker> _unidades = Set<Marker>();

    unidades.map((e) async {
      Marker m = await Marker(
          onTap: () async {
            setState(() {
              filtros.LimparUnidade();
              filtros.addunidades(e);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnidadesScreen(),
                ),
              ).then((value) => {
                    setState(() {}),
                  });
            });
            //   widget.press.call();
          },
          markerId: MarkerId(e.cod_unidade),
          position: LatLng(e.latitude, e.longitude),
          icon: filtros.markerIcon,
          // icon: kIsWeb ? BitmapDescriptor.defaultMarker : _markerIcon,
          infoWindow: InfoWindow(
              title: e.des_unidade,
              snippet: e.bairro + '/' + e.municipio + '-' + e.uf));
      setState(() {
        _unidades.add(m);
      });
    }).toList();

    return _unidades;
  }
}
