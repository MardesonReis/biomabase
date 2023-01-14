import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/fidelimax/card_fidelimax.dart';
import 'package:biomaapp/screens/home/components/meu_bioma.dart';
import 'package:biomaapp/screens/profile/componets/dadosPerfil.dart';
import 'package:biomaapp/screens/profile/permicoes_screen.dart';
import 'package:biomaapp/screens/settings/settings_screen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';

class AtendimentoScreen extends StatefulWidget {
  Agendamentos agendamento;
  AtendimentoScreen({Key? key, required this.agendamento}) : super(key: key);

  @override
  State<AtendimentoScreen> createState() => _AtendimentoScreenState();
}

class _AtendimentoScreenState extends State<AtendimentoScreen> {
  bool _isLoading = false;

  @override
  initState() {
    isLogin(context, () {
      setState(() {});
    });

    var dados = Provider.of<Auth>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    fidelimax.ConsultaConsumidor();
    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Em \n', 'em Andamento', () {}, [])),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                          AppRoutes.ImageUpload,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 8,
                          child: Padding(
                              padding: EdgeInsets.all(3),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    Constants.IMG_USUARIO +
                                        widget.agendamento.cpf_paciente +
                                        '.jpg'),
                              )),
                        ),
                      ),
                      SizedBox(width: defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            strutStyle: StrutStyle(fontSize: 10.0),
                            text: TextSpan(
                              style:
                                  TextStyle(color: primaryColor, fontSize: 12),
                              text:
                                  widget.agendamento.des_paciente.capitalize(),
                            ),
                          ),
                          Text(
                            'Idade: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            widget.agendamento.des_convenio.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.62),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: defaultPadding),
                  ListTile(
                    // tileColor: primaryColor,
                    title:
                        Text(widget.agendamento.des_procedimento.capitalize()),
                    //  trailing: Icon(Icons.picture_in_picture_rounded),
                  ),
                  SizedBox(height: defaultPadding),
                  ListTile(
                    tileColor: primaryColor[100],
                    title: Text(('Receitar Óculos')),
                    trailing: Icon(Icons.remove_red_eye_outlined),
                    onTap: () {
                      auth.isAuth
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListTile(
                                  tileColor: primaryColor[100],
                                  title:
                                      Text(('Adicionar Imagem ao Prontuário')),
                                  trailing:
                                      Icon(Icons.picture_in_picture_rounded),
                                ),
                              ),
                            ).whenComplete(() {
                              setState(() {});
                            })
                          : showSnackBar(Text('Logar'), context);
                    },
                  ),
                  SizedBox(height: defaultPadding),
                  ListTile(
                    tileColor: primaryColor[100],
                    title: Text(('Adicionar Imagem ao Prontuário')),
                    trailing: Icon(Icons.picture_in_picture_rounded),
                  ),
                  SizedBox(height: defaultPadding),
                  ListTile(
                    // tileColor: primaryColor,
                    title: Text('Anotações'),
                    //  trailing: Icon(Icons.picture_in_picture_rounded),
                  ),
                  TextField(
                    decoration:
                        InputDecoration(icon: Icon(Icons.short_text_rounded)),
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 5, // when user presses enter it will adapt to it
                  ),
                  SizedBox(height: defaultPadding),
                  ListTile(
                    tileColor: primaryColor[100],
                    title: Text(('Indicar Procedimentos')),
                    trailing: Icon(Icons.share),
                  ),
                  SizedBox(height: defaultPadding),
                  ListTile(
                    tileColor: primaryColor[100],
                    title: Text(('Receita Digital')),
                    trailing: Icon(Icons.medication),
                  ),
                ],
              ),
            ),
    );
  }
}

const InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(borderSide: BorderSide.none),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
);
