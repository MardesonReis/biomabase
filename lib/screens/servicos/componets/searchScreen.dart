import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class searchScreen extends StatefulWidget {
  VoidCallback press;
  searchScreen({Key? key, required this.press}) : super(key: key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController(text: 'Consulta');
  bool _isLoading = true;

  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    auth.atualizaAcesso(context, () {
      setState(() {
        _isLoading = false;
        setState(() {
          _controller.text = dt.like;
        });
      });
    });

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context);
    Auth aut = Provider.of(context);
    UnidadesList BancoDeUnidades = Provider.of(context);
    Future<void> b() {
      setState(() {
        dt.seemore = true;
      });
      return dt.buscar(context).then((value) {
        setState(() {
          dt.seemore = false;
          widget.press.call();
        });
      });
    }

    IniciarBuscar() {
      if (dt.like.isNotEmpty) {
        aut.filtrosativos.medicos.clear();
        dt.limparDados();
        widget.press.call();
        dt.limit = false;
      }

      b().then((value) {
        setState(() {
          widget.press.call();
        });
      });
    }

    ;

    return Card(
      elevation: 8,
      // color: Colors.white,
      child: Container(
        color: Colors.white,
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) async {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              widget.press.call();
              IniciarBuscar();
            }
          },
          child: TextFormField(
            //  initialValue: dt.like,
            key: _formKey,
            keyboardType: TextInputType.text,
            autofocus: false,
            controller: _controller,
            onChanged: (String) async {
              setState(() {
                dt.like = String;
                widget.press.call();
              });
            },
            onFieldSubmitted: (text) async {
              IniciarBuscar();
              widget.press.call();
            },
            decoration: InputDecoration(
              hintText: "Buscar Serviços, Especialistas...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  IniciarBuscar();
                  widget.press.call();
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () async {
                  setState(() {
                    mockResults.clear();
                    dt.limparDados();
                    dt.like = '';
                    _controller.text = '';
                    dt.limit = false;
                    widget.press.call();
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
