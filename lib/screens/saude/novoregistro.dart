import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/screens/saude/regristrarMinhaSaude.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NovoRegistro extends StatefulWidget {
  VoidCallback press;

  List<MinhaSaude> grupo;
  NovoRegistro({required this.grupo, required this.press, Key? key})
      : super(key: key);

  @override
  State<NovoRegistro> createState() => _NovoRegistroState();
}

class _NovoRegistroState extends State<NovoRegistro> {
  @override
  Set<String> subgrupos = Set();
  List<MinhaSaude> sublist = [];

  Widget build(BuildContext context) {
    widget.grupo.map((e) {
      if (!subgrupos.contains(e.subgrupo) && e.subgrupo != 'null') {
        subgrupos.add(e.subgrupo);
        sublist.add(e);
      }
    }).toList();
    return Scaffold(
        appBar: AppBar(title: Text('Selecione  ' + widget.grupo.first.grupo)),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ListTile(
                tileColor: primaryColor,
                title: Text('Registros Frequêntes'),
              ),
              Column(
                children: sublist
                    .where((element) => element.franquencia == '1')
                    .toList()
                    .map(
                      (e) => ListTile(
                        leading: new Icon(IconMinhaSaude[e.grupo.trim()]),
                        title: new Text(e.subgrupo),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrarMinhaSaude(
                                      press: widget.press,
                                      grupo: widget.grupo
                                          .where((element) =>
                                              element.subgrupo == e.subgrupo)
                                          .toList(),
                                      restorationId: e.subgrupo,
                                    )),
                          ).then((value) {
                            setState(() {
                              // widget.press.call();
                            });
                          })
                        },
                      ),
                    )
                    .toList(),
              ),
              ListTile(
                tileColor: primaryColor,
                title: Text('Outras Atividades'),
              ),
              Column(
                children: sublist
                    .map(
                      (e) => ListTile(
                        leading: new Icon(IconMinhaSaude[e.grupo.trim()]),
                        title: new Text(e.subgrupo),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrarMinhaSaude(
                                      press: widget.press,
                                      grupo: widget.grupo
                                          .where((element) =>
                                              element.subgrupo == e.subgrupo)
                                          .toList(),
                                      restorationId: e.subgrupo,
                                    )),
                          ).then((value) {
                            setState(() {});
                          })
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ));
  }
}
