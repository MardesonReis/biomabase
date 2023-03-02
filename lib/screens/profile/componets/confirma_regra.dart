import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/perfilDeAtendimento.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/screens/user/components/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ConfirmaRegra extends StatefulWidget {
  Procedimento procedimento;
  Unidade unidade;
  Convenios conveio;
  Medicos medico;
  ConfirmaRegra(
      {Key? key,
      required this.procedimento,
      required this.medico,
      required this.unidade,
      required this.conveio})
      : super(key: key);

  @override
  State<ConfirmaRegra> createState() => _ConfirmaRegraState();
}

class _ConfirmaRegraState extends State<ConfirmaRegra> {
  final _orientacao_controller = TextEditingController();
  final _valor_sugerido_controller = TextEditingController();
  bool _tipo_regra_parceiro = false;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _orientacao_controller.dispose();
    _valor_sugerido_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    PerfilDeAtendimento perfilDeAtendimento = Provider.of(context);
    RegrasList regrasList = Provider.of(context);

    List<Regra> regras = regrasList.items;
    Fidelimax fidelimax = auth.fidelimax;
    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Adicionar Regra - ' + widget.procedimento.cod_procedimentos)),
      body: SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          children: [
            Container(
              height: 2,
              color: primaryColor,
            ),
            DoctorInfor(doctor: widget.medico, press: () {}),
            // DoctorCard(doctor: widget.medico, press: () {}),
            Container(
              height: 2,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text(
                widget.procedimento.des_procedimentos.capitalize(),
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.monetization_on_sharp),
              title: Text(
                widget.procedimento.valor.toString(),
                style: TextStyle(fontSize: 11),
              ),
              subtitle: Text(
                'Valor de tabela',
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                widget.unidade.des_unidade +
                    " - " +
                    widget.unidade.bairro.capitalize() +
                    " - " +
                    widget.unidade.municipio.capitalize(),
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.group_work_sharp),
              title: Text(
                widget.conveio.desc_convenio,
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.add_link_outlined),
              title: Center(
                child: Text(
                  'Para quem a regra se aplica?',
                  style: TextStyle(fontSize: 11),
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Todos',
                    style: TextStyle(fontSize: 11),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: _tipo_regra_parceiro,
                    onChanged: (value) {
                      setState(() {
                        _tipo_regra_parceiro = true;
                      });
                    },
                  ),
                  Text(
                    'Selecionar',
                    style: TextStyle(fontSize: 11),
                  ),
                  Radio<bool>(
                    value: false,
                    groupValue: _tipo_regra_parceiro,
                    onChanged: (value) {
                      setState(() {
                        _tipo_regra_parceiro = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_tipo_regra_parceiro == true)
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Todos'),
              ),
            if (_tipo_regra_parceiro == false)
              ListTile(
                leading: Icon(Icons.person),
                title: Column(
                  children: [
                    filtros.usuarios.isNotEmpty
                        ? UserCard(
                            user: filtros.usuarios.first,
                            press: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserScreen(),
                                  ),
                                ).then((value) => {
                                      setState(() {
                                        //  widget.refreshPage.call();
                                      }),
                                    });
                              });
                            })
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserScreen(),
                                  ),
                                ).then((value) => {
                                      setState(() {
                                        //  widget.refreshPage.call();
                                      }),
                                    });
                              });
                            },
                            child: Text(
                              'Informe um usuário Bioma',
                              style: TextStyle(fontSize: 11),
                            )),
                  ],
                ),
              ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.textsms_rounded),
              subtitle: Text(
                'Um valor maior oi igual a R\$' +
                    widget.procedimento.valor.toString(),
                style: TextStyle(fontSize: 11),
              ),
              title: Column(
                children: [
                  Text(
                    'Qual valor deve aparecer para o parceiro',
                    style: TextStyle(fontSize: 11),
                  ),
                  TextField(
                    controller: _valor_sugerido_controller,
                    //  autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.procedimento.valor.toString()),
                    keyboardType: TextInputType.number,
                    maxLines: null,

                    onChanged: (valor) {
                      setState(() {
                        //  widget.refreshPage.call();
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.textsms_rounded),
              title: Column(
                children: [
                  Text(
                    'Observações e Orientações de agendamento',
                    style: TextStyle(fontSize: 11),
                  ),
                  TextField(
                    controller: _orientacao_controller,
                    //  autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Orientações '),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (orietacao) {
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        Usuario parceiro = new Usuario();
                        if (_tipo_regra_parceiro == false &&
                            filtros.usuarios.isEmpty) {
                          showSnackBar(
                              Text('Informe um Parceiro ou selecione todos!'),
                              context);
                          setState(() {
                            //_tipo_regra_parceiro = true;
                          });
                          return;
                        }

                        if (_tipo_regra_parceiro) {
                          parceiro.pacientes_cpf = '*';
                          parceiro.pacientes_nomepaciente = 'Todos';
                        } else {
                          parceiro = filtros.usuarios.first;
                        }
                        Regra regra = Regra(
                            id_regra: '',
                            cpf_parceiro: parceiro.pacientes_cpf,
                            des_parceiro: parceiro.pacientes_nomepaciente,
                            cpf_medico: widget.medico.cpf,
                            des_medico: widget.medico.des_profissional,
                            valor_base: widget.procedimento.valor.toString(),
                            cod_procedimento:
                                widget.procedimento.cod_procedimentos,
                            des_procedimento:
                                widget.procedimento.des_procedimentos,
                            cod_convenio: widget.conveio.cod_convenio,
                            des_convenio: widget.conveio.desc_convenio,
                            cod_unidade: widget.unidade.cod_unidade,
                            des_unidade: widget.unidade.des_unidade,
                            orientacoes: _orientacao_controller.text,
                            valor_sugerido: _valor_sugerido_controller
                                        .text.isEmpty ||
                                    double.parse(
                                            _valor_sugerido_controller.text) <
                                        double.parse(widget.procedimento.valor
                                            .toString())
                                ? widget.procedimento.valor.toString()
                                : _valor_sugerido_controller.text,
                            status: 'A',
                            data_criacao: '',
                            hora_criacao: '',
                            rateios: []);

                        var id_regra = await regrasList.addRegra(regra);
                        if (id_regra != '') {
                          await AlertShowDialog('Sucesso',
                              Text('Adiconado com sucesso'), context);
                          Navigator.of(context).pop();
                        } else {
                          AlertShowDialog(
                              'Erro', Text('Regra não adicionada'), context);
                        }
                      },
                      child: Text('Adicionar Regra'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
