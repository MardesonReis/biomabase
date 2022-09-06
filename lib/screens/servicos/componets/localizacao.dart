import 'dart:async';
import 'dart:typed_data';
import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';

import 'package:biomaapp/screens/doctors/doctors_screen.dart';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Localizacao extends StatefulWidget {
  final VoidCallback press;
  Localizacao({required this.press});
  @override
  LocalizacaoState createState() => LocalizacaoState();
}

class LocalizacaoState extends State<Localizacao> {
  Completer<GoogleMapController> _controller = Completer();
  late Position _currentPosition;
  Set<Marker> _marker = Set<Marker>();
  bool _isLoadingAgendamento = true;
  bool _isLoadingUnidade = true;
  bool _isLoadingIcon = true;
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();
  final StreamController _stream = StreamController.broadcast();

  int count = 0;
  Completer<Uint8List> markerIcon = Completer();

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
    filtrosAtivos filtros = auth.filtrosativos;

    AgendamentosList agenda = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );

    var dados = Provider.of<DataList>(
      context,
      listen: false,
    );

    dados.items.isEmpty
        ? dados.loadDados('').then((value) => setState(() {
              _isLoading = false;
            }))
        : setState(() {
            _isLoading = false;
          });

    agenda.items.isEmpty
        ? agenda
            .loadAgendamentos(auth.fidelimax.cpf.toString())
            .then((value) => setState(() {
                  _isLoadingAgendamento = false;
                }))
        : setState(() {
            _isLoadingAgendamento = false;
          });

    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    ListUnidade.items.isEmpty
        ? ListUnidade.loadUnidades('').then((value) {
            setState(() {
              _isLoadingUnidade = false;
            });
          })
        : setState(() {
            _isLoadingUnidade = false;
          });
    getBytesFromAsset('assets/icons/bioma.png', 100).then((value) async {
      setState(() {
        markerIcon.complete(value);
        _isLoadingIcon = false;
        determinePosition();
      });
    });
  }

  double zoomVal = 8;

  @override
  Widget build(BuildContext context) {
    DataList dt = Provider.of(context, listen: false);
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
    final dados = dt.items;

    // dados.retainWhere((element) {
    //   return filtrarUnidade
    //       ? filtros.unidades.contains(Unidade(
    //           cod_unidade: element.cod_unidade,
    //           des_unidade: element.des_unidade))
    //       : true;
    // });
    if (_controller.future == null) {
      setState(() {
        _buildGoogleMap();
      });
    }
    dados.retainWhere((element) {
      return filtrarMedico
          ? filtros.medicos
              .where((medico) =>
                  element.cod_profissional == medico.cod_profissional)
              .isNotEmpty
          : true;
    });

    dados.retainWhere((element) {
      return filtrarConvenio
          ? filtros.convenios.contains(Convenios(
              cod_convenio: element.cod_convenio,
              desc_convenio: element.desc_convenio))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarEspecialidade
          ? filtros.especialidades.contains(Especialidade(
              codespecialidade: element.cod_especialidade,
              descricao: element.des_especialidade,
              ativo: 'S'))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarSubEspecialidade
          ? filtros.subespecialidades
              .contains(SubEspecialidade(descricao: element.sub_especialidade))
          : true;
    });

    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });

    dados.map((e) async {
      Unidade unidade = Unidade();
      var str = '';
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
          str = u.des_unidade +
              ' - ' +
              u.municipio +
              ' - ' +
              u.bairro +
              ' - ' +
              u.logradouro;

          if (str.toUpperCase().contains(txtQuery.text.toUpperCase())) {
            setState(() {
              unidades.add(u);
            });
          }
        }
      }
    }).toList();
    unidades.map((e) async {
      var i = await markerIcon.future;
      Marker m = await Marker(
          onTap: () async {
            setState(() {
              filtros.LimparUnidade();
              filtros.addunidades(e);
            });
            //   widget.press.call();
          },
          markerId: MarkerId(e.cod_unidade),
          position: LatLng(e.latitude, e.longitude),
          icon: await BitmapDescriptor.fromBytes(i),
          infoWindow: InfoWindow(
              title: e.des_unidade,
              snippet: e.bairro + '/' + e.municipio + '-' + e.uf));
      setState(() {
        _marker.add(m);
      });
    }).toList();

    unidades.sort((a, b) => a.distancia.compareTo(b.distancia));

    dados.map((e) {
      Procedimento p = Procedimento();

      p.cod_procedimentos = e.cod_procedimentos;
      p.des_procedimentos = e.des_procedimentos;
      p.valor = double.parse(e.valor);
      p.grupo = e.grupo;
      p.frequencia = e.frequencia;
      p.quantidade = e.tabop_quantidade;
      p.especialidade.codespecialidade = e.cod_especialidade;
      p.especialidade.descricao = e.des_especialidade;
      p.cod_tratamento = e.cod_tratamento;
      p.des_tratamento = e.tipo_tratamento;

      Medicos med = Medicos();
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;
      med.cod_especialidade = e.cod_especialidade;
      med.crm = e.crm;
      med.cpf = e.cpf;
      med.idademin = e.idade_mim;
      med.idademax = e.idade_max;
      med.ativo = '1';
      med.subespecialidade = e.sub_especialidade;

      Unidade unidade = Unidade();
      unidade.cod_unidade = e.cod_unidade;
      unidade.des_unidade = e.des_unidade;

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

    var cod_unidade = '';
    if (filtros.unidades.isNotEmpty) {
      cod_unidade = filtros.unidades.first.cod_unidade;
    }
    if (filtros.unidades.isEmpty && unidades.isNotEmpty) {
      cod_unidade = unidades.first.cod_unidade;
    }

    return _isLoadingAgendamento ||
            _isLoading ||
            _isLoadingUnidade ||
            _isLoadingIcon
        ? Center(child: CircularProgressIndicator())
        : Container(
            // height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFiltros(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildGoogleMap(),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: _zoomminusfunction(),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: _zoomplusfunction(),
                        // ),
                        //     _mylocalbutton(),
                      ],
                    ),
                  ),
                  FiltroAtivosScren(press: () {
                    setState(() {
                      _refreshPage();
                    });
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: txtQuery,
                      onChanged: (String) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            txtQuery.text = '';
                            setState(() {
                              mockResults.clear();
                              //buscarQuery(txtQuery.text);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SectionTitle(
                      title: "Locais de Atendimento",
                      pressOnSeeAll: () {},
                      OnSeeAll: false,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                        unidades.length,
                        (index) => InforUnidade(unidades[index], () {
                          filtros.LimparUnidade();
                          filtros.addunidades(unidades[index]);
                          widget.press.call();
                        }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        elevation: 8,
        color: Colors.white,
        child: IconButton(
            icon: Icon(Icons.zoom_out, color: primaryColor),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              zoomVal = await controller.getZoomLevel();
              zoomVal--;
              _minus(zoomVal);
            }),
      ),
    );
  }

  Widget _mylocalbutton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Align(
          alignment: Alignment.topRight,
          child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  child: Icon(Icons.location_on, size: 12),
                  onTap: () async {
                    await determinePosition().then((value) async {
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        zoom: 10,
                        tilt: 50.0,
                        bearing: 45.0,
                      )));
                    });
                  },
                ),
              )),
        ),
      ),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 8,
        color: Colors.white,
        child: IconButton(
            icon: Icon(Icons.zoom_in, color: primaryColor),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              zoomVal = await controller.getZoomLevel();
              zoomVal++;
              _plus(zoomVal);
            }),
      ),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(zoomVal));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(zoomVal));
  }

  Widget _buildFiltros() {
    return StreamBuilder(
        stream: _stream.stream,
        builder: (BuildContext, AsyncSnapshot) {
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PopMenuConvenios(() {
                    setState(() {});
                  }),
                  PopMenuEspecialidade(() {
                    setState(() {});
                  }),
                  PopMenuSubEspecialidades(() {
                    setState(() {});
                  }),
                  PopMenuGrupo(() {
                    setState(() {});
                  }),
                  PopoMenuUnidades(() {
                    setState(() {});
                  })
                ],
              ),
            ),
          );
        });
  }

  Widget _buildGoogleMap() {
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    return Container(
      color: primaryColor,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
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
        initialCameraPosition: CameraPosition(
            target: LatLng(-3.613425981453625, -38.53529385675654), zoom: 8),
        onMapCreated: (GoogleMapController controller) async {
          setState(() async {
            await determinePosition().then((position) {
              _currentPosition = position;
              _controller.complete(controller);
              filtros.googleMapController = controller;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(
                        position.latitude,
                        position.longitude,
                      ),
                      zoom: 10)));
            });
          });
        },
        markers: _marker,
      ),
    );
  }
}
