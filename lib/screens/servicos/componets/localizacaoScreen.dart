import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' show sin, cos, sqrt, atan2;
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

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:vector_math/vector_math.dart';

class LocalizacaoScreen extends StatefulWidget {
  LocalizacaoScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacaoScreen> createState() => _LocalizacaoScreenState();
}

class _LocalizacaoScreenState extends State<LocalizacaoScreen> {
  late GoogleMapController controller;
  double latitude = -3.792303806385164;
  double longitude = -38.603039058733025;
  double zoom = 18;
  Set<Marker> marker = Set<Marker>();
  bool _isLoading = true;
  GlobalKey globalKey = GlobalKey();
  late Position _currentPosition;
  TextEditingController txtQuery = new TextEditingController();
  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    UnidadesList dadosunidades = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    dadosunidades.items.isEmpty
        ? Provider.of<UnidadesList>(
            context,
            listen: false,
          ).loadUnidades('').then((value) {
            setState(() {
              _isLoading = false;
            });
          })
        : setState(() {
            _isLoading = false;
          });
  }
//Using pLat and pLng as dummy location

//Use Geolocator to find the current location(latitude & longitude)

//Calculating the distance between two points without Geolocator plugin

  double getDistance(double lat1, double log1) {
    double earthRadius = 6371000;

    var dLat = radians(lat1 - _currentPosition.latitude);
    var dLng = radians(log1 - _currentPosition.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radians(_currentPosition.latitude)) *
            cos(radians(lat1)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = earthRadius * c;
    return (d); //d is the distance in meters
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    DataList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);
    UnidadesList unidadeslist = Provider.of(context);
    final dadosunidades = unidadeslist.items;
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> EspecialidadesInclusas = Set();
    Set<String> UnidadesIncluso = Set();
    Set<String> UltimasUnidadesIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Unidade> HistoricoUnidades = [];
    List<Unidade> unidades = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.items;

    dados.retainWhere((element) {
      return filtrarUnidade
          ? filtros.unidades.contains(Unidade(
              cod_unidade: element.cod_unidade,
              des_unidade: element.des_unidade))
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
      return element.des_procedimentos
          .toLowerCase()
          .contains(txtQuery.text.toLowerCase());
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });

    dados
        .map((e) => dadosunidades.where((element) {
              if (element.cod_unidade.contains(e.cod_unidade)) {
                if (!UnidadesIncluso.contains(element.cod_unidade)) {
                  UnidadesIncluso.add(element.cod_unidade);

                  setState(() {
                    unidades.add(element);
                  });
                }
                return true;
              } else {
                return false;
              }
            }).toList())
        .toList();
    unidades.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));
    return Container(
      child: new Scaffold(
        key: globalKey,
        body: Container(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
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
                  trafficEnabled: true,
                  indoorViewEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  markers: marker,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  onMapCreated: OnMapCreated,
                  onCameraMove: onCameraMove,
                  onTap: (value) {
                    // print(value);
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude), zoom: zoom)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: primaryColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: MinhaLocalizacao,
          label: Text('Serviços Próximos'),
          icon: Icon(Icons.location_on),
        ),
      ),
    );
  }

  void OnMapCreated(GoogleMapController gmc) async {
    controller = gmc;
    try {
      MinhaLocalizacao();
    } catch (e) {
      e.toString();
    }
  }

  Future<void> MinhaLocalizacao() async {
    var a = await _determinePosition().then((value) async {
      var markerIcon =
          await getBytesFromAsset('assets/icons/bioma.png', 100).then((value) {
        setState(() {});
      });

      double distance = await Geolocator.distanceBetween(
          latitude, longitude, value.latitude, value.latitude);
      final Marker mkr = Marker(
          onTap: () {
            showModalBottomSheet(
                context: globalKey.currentState!.context,
                builder: (context) => Text('Distancia:' +
                    getDistance(latitude, longitude).toString()));
          },
          markerId: MarkerId(DateTime.now().toString()),
          position: LatLng(
            value.latitude,
            value.longitude,
          ),
          icon: await BitmapDescriptor.fromBytes(markerIcon),
          infoWindow:
              InfoWindow(title: 'Minha Localização', snippet: 'Fortaleza/CE'));

      final Marker mkr2 = Marker(
          onTap: () {
            showModalBottomSheet(
                context: globalKey.currentState!.context,
                builder: (context) => Text('Distancia:' +
                    getDistance(latitude, longitude).toString()));
          },
          markerId: MarkerId(DateTime.now().toString()),
          position: LatLng(latitude, longitude),
          icon: await BitmapDescriptor.fromBytes(markerIcon),
          infoWindow:
              InfoWindow(title: 'Minha Localização', snippet: 'Fortaleza/CE'));

      setState(() {
        marker.add(mkr);
        marker.add(mkr2);
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            value.latitude,
            value.longitude,
          ),
          zoom: zoom)));
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> onCameraMove(CameraPosition value) async {}

  Future<void> onTap(LatLng value) async {}

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _currentPosition = await Geolocator.getCurrentPosition();
    return await Geolocator.getCurrentPosition();
  }
}
