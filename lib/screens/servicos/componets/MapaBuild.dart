import 'dart:async';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  List<Unidade> unidades;
  Mapa({Key? key, required this.unidades}) : super(key: key);

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  var _currentPosition;
  late LatLng _position = LatLng(-3.613425981453625, -38.53529385675654);
  Set<Marker> _marker = Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 8;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    widget.unidades.map((e) async {
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
          icon: filtros.markerIcon,
          infoWindow: InfoWindow(
              title: e.des_unidade,
              snippet: e.bairro + '/' + e.municipio + '-' + e.uf));
      setState(() {
        _marker.add(m);
      });
    }).toList();
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
              size: 32, //change size on your need
              color: destColor,

              //change color on your need
              shadows: [
                Shadow(blurRadius: 3.0, color: Colors.grey, offset: Offset.zero)
              ]),
          title: Text('Mapa',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold))),
      body: GoogleMap(
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
        initialCameraPosition: CameraPosition(target: _position, zoom: 8),
        onMapCreated: OnMapCreated,
        markers: retornarMakers(widget.unidades, filtros),
      ),
    );
  }

  Set<Marker> retornarMakers(List<Unidade> unidades, filtrosAtivos filtros) {
    unidades.map((e) async {
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
          icon: await getico('assets/icons/bioma_maps.png', () {
            setState(() {});
          }, filtros),
          //  icon: kIsWeb ? BitmapDescriptor.defaultMarker : _markerIcon,
          infoWindow: InfoWindow(
              title: e.des_unidade,
              snippet: e.bairro + '/' + e.municipio + '-' + e.uf));
      setState(() {
        _marker.add(m);
      });
    }).toList();
    return _marker;
  }

  void OnMapCreated(GoogleMapController controller) async {
    if (!mounted) return;
    if (!_marker.isEmpty) return;

    _controller.complete(controller);
    try {
      var position = await determinePosition();

      await controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _position, zoom: 10)));
      setState(() {
        _position = position;
      });
      return;
    } on FormatException catch (err) {
      if (!mounted) return;
      print(err);
      setState(() {});
      //setState(() => _err = err);
    }
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(zoomVal));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(zoomVal));
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
}
