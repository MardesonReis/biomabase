import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class filtrosScreen extends StatefulWidget {
  VoidCallback press;
  filtrosScreen({Key? key, required this.press}) : super(key: key);

  @override
  State<filtrosScreen> createState() => _filtrosScreenState();
}

class _filtrosScreenState extends State<filtrosScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;
    filtros.BuscarFiltrosAtivos();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProgressIndicatorBioma(),
                  )
                : IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      var regraList = Provider.of<RegrasList>(
                        context,
                        listen: false,
                      );
                      //13978829304

                      await regraList.carrgardados(context, all: true,
                          Onpress: () {
                        setState(() {
                          _isLoading = false;
                          widget.press.call();
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthOrHomePage(),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      });
                    },
                    icon: Icon(Icons.refresh)),
            PopMenuConvenios(() {
              setState(() {
                widget.press.call();
              });
            }),
            PopMenuEspecialidade(() {
              setState(() {
                widget.press.call();
              });
            }),
            PopMenuSubEspecialidades(() {
              setState(() {
                widget.press.call();
              });
            }),
            PopMenuGrupo(() {
              setState(() {
                widget.press.call();
              });
            }),
            PopoMenuUnidades(() {
              setState(() {
                widget.press.call();
              });
            })
          ],
        ),
      ),
    );
  }
}
