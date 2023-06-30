import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/exceptions/auth_exception.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/minhasaude_list.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/saude/medicamento.dart';
import 'package:biomaapp/screens/saude/novoregistro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MenuMinhaSaude extends StatefulWidget {
  VoidCallback press;
  MenuMinhaSaude({Key? key, required this.press}) : super(key: key);

  @override
  State<MenuMinhaSaude> createState() => _MenuMinhaSaudeState();
}

class _MenuMinhaSaudeState extends State<MenuMinhaSaude> {
  bool _isLoading = true;
  Future<void> buscarRegistros() {
    print('Iniciando Busca');
    var minhasaude = Provider.of<MinhaSaudeList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    return minhasaude.ListarTipos().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void initState() {
    var minhasaude = Provider.of<MinhaSaudeList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    if (!auth.isAuth) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthOrHomePage(),
          )).then((value) {
        setState(() {});
      });
    }
    if (minhasaude.tipos.isEmpty) {
      buscarRegistros();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MinhaSaudeList minhasaude = Provider.of(context);
    Set<String> grupos = Set();

    minhasaude.tipos.map((e) {
      if (!grupos.contains(e.grupo) && e.grupo != 'null') {
        grupos.add(e.grupo.trim());
      }
    }).toList();
    if (_isLoading) return ProgressIndicatorBioma();

    return Wrap(
        children: grupos
            .map((e) => ListTile(
                leading: Icon(IconMinhaSaude[e]),
                title: new Text(e),
                onTap: () => {
                      if (e == 'Medicamento')
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MinhaSaudeMedicamento()),
                          ).then((value) {
                            setState(() {});
                          })
                        }
                      else
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NovoRegistro(
                                      press: widget.press,
                                      grupo: minhasaude.tipos
                                          .where((element) =>
                                              element.grupo.trim() == e)
                                          .toList(),
                                    )),
                          ).then((value) {
                            setState(() {
                              widget.press.call();
                            });
                          })
                        }
                    }))
            .toList());
  }
}
