import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class BuildConvenios extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  BuildConvenios({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<BuildConvenios> createState() => _BuildConveniosState();
}

class _BuildConveniosState extends State<BuildConvenios> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      floatingActionButton: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: filtros.convenios.isNotEmpty,
              child: FloatingActionButton.extended(
                disabledElevation: filtros.convenios.isEmpty ? 1 : 0,
                onPressed: () {
                  setState(() {
                    widget.press.call();
                    //filtros.LimparPasso();
                  });
                  widget.press.call();
                },
                label: Text('Continuar'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Selecione um convênio',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            PopMenuConvenios(() {
              setState(() {
                widget.refreshPage.call();
                // Navigator.pop(context);
              });
            }),
          ],
        ),
      ),
    );
  }
}
