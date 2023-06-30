import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MinhaSaudeMedicamento extends StatefulWidget {
  const MinhaSaudeMedicamento({Key? key}) : super(key: key);

  @override
  State<MinhaSaudeMedicamento> createState() => _MinhaSaudeMedicamentoState();
}

class _MinhaSaudeMedicamentoState extends State<MinhaSaudeMedicamento> {
  TextEditingController txtQuery = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Selecione um Medicamento')),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  inputFormatters: [
                    // obrigatório
                    //    FilteringTextInputFormatter.digitsOnly,
                    //    CpfOuCnpjFormatter(),
                  ],
                  //    keyboardType: TextInputType.number,
                  controller: txtQuery,
                  // initialValue: filtros.usuarios.isNotEmpty
                  //     ? filtros.usuarios.first.cpf
                  //     : '',

                  //     onChanged: buscarQuery,
                  decoration: InputDecoration(
                    hintText: "Buscar Medicamentos",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          //  buscarQuery(txtQuery.text);
                        });
                      },
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        txtQuery.text = '';
                        setState(() {
                          // mockResults.clear();
                          // filtros.LimparUsuarios();
                          //buscarQuery(txtQuery.text);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
