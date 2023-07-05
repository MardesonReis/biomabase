import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fila_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/appointment/meusAgendamentos.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AgendarList extends StatefulWidget {
  List<Fila> fila;
  List<Fila> sucesso = [];
  List<Fila> erro = [];
  AgendarList({Key? key, required this.fila}) : super(key: key);

  @override
  State<AgendarList> createState() => _AgendarListState();
}

class _AgendarListState extends State<AgendarList> {
  bool _isLoading = false;

  void initState() {
    super.initState();

    widget.fila.map((e) async {
      await agendar(e);
    }).toList();
  }

  agendar(Fila e) async {
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;

    var listfila = Provider.of<FilaList>(
      context,
      listen: false,
    );
    if (auth.fidelimax.parceiro.id.isEmpty ||
        auth.fidelimax.parceiro.id == "") {
      await auth.ParceiroExisteOuCria();
    }
    e.indicando = auth.fidelimax.parceiro;

    await listfila.Agendar(e).then((value) async {
      if (value != '') {
        e.sequencial = value;
        await listfila.ProcedimentosAgendados(e).then((value) async {
          if (value != '') {
            setState(() {
              widget.sucesso.add(e);
              filtros.removerFila(e);
            });
          } else {
            setState(() {
              widget.erro.add(e);
            });
          }
        });
      } else {
        setState(() {
          widget.erro.add(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    Paginas pages = auth.paginas;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Agendar \n', 'Procedimentos', () {}, [])),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: defaultPadding,
              ),
              Column(
                children: List.generate(widget.fila.length, (
                  index,
                ) {
                  var erro = widget.erro;
                  return ListTile(
                    title:
                        Text(widget.fila[index].procedimento.des_procedimento),
                    trailing: Wrap(children: [
                      if (!widget.erro.contains(widget.fila[index]) &&
                          !widget.sucesso.contains(widget.fila[index]))
                        CircularProgressIndicator()
                      else if (widget.erro.contains(widget.fila[index]))
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.erro.remove(widget.fila[index]);
                              });
                              agendar(widget.fila[index]);
                            },
                            icon: Icon(
                              Icons.error,
                              color: redColor,
                            ))
                      else if (widget.sucesso.contains(widget.fila[index]))
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthOrHomePage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.task_alt,
                              color: Colors.green,
                            ))
                    ]),
                  );
                }),
              ),
              widget.fila.length == (widget.erro.length + widget.sucesso.length)
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthOrHomePage(),
                            ),
                          );
                        });
                      },
                      child: Text('Voltar'))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
