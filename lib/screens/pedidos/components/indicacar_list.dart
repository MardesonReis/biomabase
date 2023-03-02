import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fila_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/appointment/meusAgendamentos.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_screen.dart';
import 'package:biomaapp/screens/pedidos/navaIndicacao.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class IndicarList extends StatefulWidget {
  List<Fila> fila;
  List<Fila> sucesso = [];
  List<Fila> erro = [];
  String filaId = '';
  IndicarList({Key? key, required this.fila}) : super(key: key);

  @override
  State<IndicarList> createState() => _IndicarListState();
}

class _IndicarListState extends State<IndicarList> {
  bool _isLoading = false;

  void initState() {
    super.initState();
    GerarFila(widget.fila.first);

    //widget.fila.map((e) => indicar(e)).toList();
  }

  GerarFila(Fila e) async {
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;

    var listfila = Provider.of<FilaList>(
      context,
      listen: false,
    );
    //e.indicado = filtros.usuarios.first;
    var user = Usuario();
    user.pacientes_cpf = auth.fidelimax.cpf;
    e.indicando = user;

    listfila.GerarFilaIndicacao(e).then((value) {
      setState(() {
        widget.filaId = value;
      });
      if (value != '') {
        widget.fila.map((e) => SalvaFila(e, widget.filaId)).toList();
      } else {
        widget.fila.map((e) => widget.erro.add(e)).toList();
        setState(() {});
      }
    });
  }

  SalvaFila(Fila e, String filaId) async {
    print(e.data + '\n');
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    filtrosAtivos filtros = auth.filtrosativos;

    var listfila = Provider.of<FilaList>(
      context,
      listen: false,
    );
    //e.indicado = filtros.usuarios.first;
    var user = Usuario();
    user.pacientes_cpf = auth.fidelimax.cpf;
    e.indicando = user;

    listfila.SalvaIndicacao(e, filaId).then((value) {
      if (value != '') {
        setState(() {
          widget.sucesso.add(e);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovaIndicacao(IdIndicacao: widget.filaId),
          ),
        ).then((value) => {
              setState(() {}),
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
          child: CustomAppBar('indicar \n', 'Procedimentos', () {}, [])),
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
                        Text(widget.fila[index].procedimento.des_procedimentos),
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
                              SalvaFila(widget.fila[index], widget.filaId);
                            },
                            icon: Icon(
                              Icons.error,
                              color: redColor,
                            ))
                      else if (widget.sucesso.contains(widget.fila[index]))
                        IconButton(
                            onPressed: () {
                              setState(() {
                                pages.selecionarPaginaHome('Agendamentos');
                              });
                              Navigator.of(context).pushReplacementNamed(
                                AppRoutes.AUTH_OR_HOME,
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
            ],
          ),
        ),
      ),
    );
  }
}
