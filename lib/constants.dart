import 'dart:async';
import 'dart:typed_data';

import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math' show sin, cos, sqrt, atan2;

const BiosTaxa = 0.10;
const primaryColor = Colors.cyan;
const secudaryColor = Color.fromRGBO(224, 247, 250, 1);
const textColor = Color(0xFF35364F);
const backgroundColor = Color(0xFFE6EFF9);
const redColor = Color.fromARGB(255, 230, 151, 151);
const destColor = Color.fromRGBO(251, 192, 45, 1);
String MarterDoctor = '13978829304';
List<String> Master = ['60465112323', MarterDoctor];

const defaultPadding = 8.0;

const emailError = 'Enter a valid email address';
const requiredField = "This field is required";

callbackLogin(BuildContext context, VoidCallback fun) {
  RegrasList regrasList = Provider.of<RegrasList>(
    context,
    listen: false,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AuthPage(
        func: () {
          fun.call();
          Navigator.pop(context);
        },
      ),
    ),
  ).whenComplete(() {
    fun.call();
  });
}

textResp(String text) {
  return RichText(
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    strutStyle: StrutStyle(fontSize: 11.0),
    text: TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 11),
      text: text.isEmpty ? '' : text.capitalize(),
    ),
  );
}

List<Medicos> mockResults = <Medicos>[];
List<String> listOfMonths = [
  "Janeiro",
  "Fevereiro",
  "Março",
  "Abril",
  "Maio",
  "Junho",
  "Julho",
  "Agosto",
  "Setembro",
  "Outubro",
  "Novembro",
  "Dezembro"
];
List<String> listOfDays = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"];

Map<String, String> StatusProcedimentosAgendadosSSS = {
  "A": "AGENDADO",
  "R": "REALIZADO",
  "S": "SOLICITADO",
  "P": "RESERVADO",
  "X": "CANCELADO",
};
Map<String, String> StatusProximaConsulta = {
  "A": "AGENDADO",
  "R": "REALIZADO",
  "C": "CIRURGIA",
  "S": "SOLICITADO"
};

Map<String, String> StatusAgenda = {
  "A": "ATENDIDO",
  "T": "EM ATENDIMENTO",
  "P": "RESERVADO",
  "V": "CONFIRMADO",
  //"C": "CHEGOU",

//  "L": "LIBERADO",
  // "O": "DILATANDO",
  //"I": "DILATADO",
  "X": "SUSPENSO",
  "D": "DESISTIU",
};
Map<String, String> olhoDescritivo = {
  "A": "Em Dois Olhos" as String,
  "D": "No Olho Direito" as String,
  "E": "No Olho Esquerdo" as String,
};
Map<String, String> ManoBino = {
  "2": "Em 1 Olho" as String,
  "1": "Em 2 Olhos" as String,
  " ": "" as String,
};
isLogin(BuildContext context, VoidCallback press) async {
  Auth auth = Provider.of<Auth>(
    context,
    listen: false,
  );

  if (!auth.isAuth) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      press.call();

      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return AuthOrHomePage();
      }));
    });
  }
}

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ],
);

const InputDecoration dropdownInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
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

Future<double> getDistance(double lat1, double log1) async {
  double earthRadius = 6371000;

  var position = await determinePosition();

  var dLat = vector.radians(lat1 - position.latitude);
  var dLng = vector.radians(log1 - position.longitude);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      cos(vector.radians(position.latitude)) *
          cos(vector.radians(lat1)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = earthRadius * c;

  return (d / 1000);
}

especialidadeDetalhe(Procedimento p) {
  if (p.especialidade.codespecialidade == '1' && p.olho == '') {
    return false;
  } else {
    return true;
  }
}

Future<LatLng> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  LatLng latLng = LatLng(-3.613425981453625, -38.53529385675654);

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    //return Future.error('Os serviços de localização estão desativados.');
    return latLng;
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
      // return Future.error('As permissões de localização foram negadas');
      return latLng;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    // return Future.error(        'As permissões de localização são negadas permanentemente, não podemos solicitar permissões.');
    return latLng;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  var local = await Geolocator.getCurrentPosition();
  latLng = LatLng(local.latitude, local.longitude);
  return latLng;
}

distanciaValida(double d) {
  if (d > 0 && d < 100) {
    return true;
  } else {
    return false;
  }
}

Future<void> gotoLocation(
    double lat, double long, GoogleMapController controller) async {
  controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    target: LatLng(lat, long),
    zoom: 15,
    tilt: 50.0,
    bearing: 45.0,
  )));
}

Column buildAppointmentInfo(String title, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        maxLines: 1,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: textColor.withOpacity(0.62),
        ),
      ),
    ],
  );
}

Column buildInfoPage(String title, String text, Icon ico) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 30,
          child: ico,
        ),
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: primaryColor,
        ),
      ),
      ListTile(
        title: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.62),
            ),
          ),
        ),
      ),
    ],
  );
}

Column buildIndicadores(String title, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 30,
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: textColor.withOpacity(0.62),
        ),
      ),
    ],
  );
}

Column buildInfo(String title, String text, Icon ico) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 20,
        child: ico,
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: textColor.withOpacity(0.62),
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor.withOpacity(0.62),
        ),
      ),
    ],
  );
}

Image buildImgUser(String cpf, BuildContext context) {
  return Image.network(
    Constants.IMG_USUARIO + cpf + '.jpg',
    height: MediaQuery.of(context).size.height,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;

      return const Center(child: CircularProgressIndicator());
    },
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return new Image.asset(
        'assets/imagens/deful.png',
        height: MediaQuery.of(context).size.height * 0.5,
      );
    },
  );
}

Image buildImgDoctor(Medicos doctor, BuildContext context) {
  double h = 400;
  return Image.network(
    Constants.IMG_USUARIO + doctor.cpf + '.jpg',
    height: h,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;

      return const Center(child: CircularProgressIndicator());
    },
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return Image.network(
        Constants.IMG_BASE_URL + 'medicos/' + doctor.crm + '.png',
        height: h,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;

          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return new Image.asset(
            'assets/imagens/deful.png',
            height: h,
          );
        },
      );
    },
  );
}

abrirUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
}

abrirWhatsApp(String msg) async {
  var whatsappUrl = "whatsapp://send?phone=&text=" + msg;

  if (await launchUrl(Uri.parse(whatsappUrl))) {
    await launchUrl(Uri.parse(whatsappUrl));
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}

abrirGmail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'ianwandersong12@gmail.com',
    query: 'subject=Reportar&body=Detalhe aqui qual bug você encontrou: ',
  );
  String url = params.toString();
  if (await launchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

abrirGoogleMaps() async {
  const urlMap =
      "https://www.google.com/maps/search/?api=1&query=-22.9732303,-43.2032649";
  if (await launchUrl(Uri.parse(urlMap))) {
    await launchUrl(Uri.parse(urlMap));
  } else {
    throw 'Could not launch $urlMap';
  }
}

abrirMessenger(String msg) async {
  var messengerUrl = 'https://www.facebook.com/messages/t/ianwandersom';
  if (await launchUrl(Uri.parse(messengerUrl))) {
    await launchUrl(Uri.parse(messengerUrl));
  } else {
    throw 'Could not launch $messengerUrl';
  }
}

abrirContatos() async {
  const url = 'content://com.android.contacts/contacts';
  if (await launchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

enviarSms() async {
  const url = "sms:86994324465?body=Olá, tudo bem?";
  if (await launchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

fazerLigacao() async {
  const url = "tel:86994324465";
  if (await launchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

Future<BitmapDescriptor> getico(
    String path, VoidCallback pess, filtrosAtivos filtros) async {
  // 'assets/icons/bioma_maps.png'

  if (filtros.markerIcon == BitmapDescriptor.defaultMarker) {
    var ico = await getBytesFromAsset(path, 100);
    filtros.markerIcon =
        await BitmapDescriptor.fromBytes(ico, size: ui.Size(100, 100));
  }

  // pess.call();
  return filtros.markerIcon;
}

showSnackBar(Widget content, BuildContext context) {
  // final _scaffoldKey = GlobalKey();

  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      //  final context = _scaffoldKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: content,
          backgroundColor: primaryColor,
          dismissDirection: DismissDirection.down,
          duration: const Duration(seconds: 5),
        ));
      }
    },
  );
}

AlertShowDialog(String title, String msg, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

bool cpfOuCnpjValido(String _cpf) {
  var cpf = _cpf
      .toString()
      .replaceAll('.', '')
      .replaceAll('-', '')
      .replaceAll('/', '');

  return UtilBrasilFields.isCPFValido(_cpf) ||
      UtilBrasilFields.isCNPJValido(_cpf);
}
