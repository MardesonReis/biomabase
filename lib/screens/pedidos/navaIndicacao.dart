import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/AvailableDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/indicacao.dart';
import 'package:biomaapp/models/indicacoes_list.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_itens_screen.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NovaIndicacao extends StatefulWidget {
  String IdIndicacao;
  NovaIndicacao({Key? key, required this.IdIndicacao}) : super(key: key);

  @override
  State<NovaIndicacao> createState() => _NovaIndicacaoState();
}

class _NovaIndicacaoState extends State<NovaIndicacao> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  Set<String> Id_indicacao_Inclusas = Set();
  Set<String> MedicosInclusos = Set();
  List<Indicacao> itens = [];
  Medicos especialista = Medicos();
  bool isError = false;

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var indicacoes = Provider.of<IndicacoesList>(
      context,
      listen: false,
    );

    indicacoes.loadIndicacoesItens('0', widget.IdIndicacao, '0').then((value) {
      setState(() {
        itens = value;
      });
      especialista.BuscarMedicoPorId(indicacoes.items.first.cod_especialista)
          .then((value) {
        setState(() {
          especialista = value;
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicacoesList dt = Provider.of(context, listen: false);
    final dados = dt.items;
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;

    mockResults = auth.filtrosativos.medicos;

    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Image.asset('assets/imagens/biomaLogo.png'),
          ),
          actions: [
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
                  Icons.home,
                  color: Colors.white,
                ))
          ],
          elevation: 0,
          title: Center(
            child: Text(
              'Procedimentos Solicitados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          )),
      //   appBar: PreferredSize(
      //        preferredSize: Size.fromHeight(40),
      //        child: CustomAppBar('Filas de\n', 'Indicações', () {}, [])),
      //   drawer: AppDrawer(),
      backgroundColor: primaryColor,
      body: _isLoading
          ? Container(
              padding: EdgeInsets.only(
                  top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Especialista',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          leading: CircleAvatar(
                            //   backgroundColor: primaryColor,
                            //   foregroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              Constants.IMG_BASE_URL +
                                  'medicos/' +
                                  especialista.crm +
                                  '.png',
                            ),
                            onBackgroundImageError: (_, __) {
                              setState(() {
                                isError = true;
                              });
                            },
                            child: isError == true
                                ? Text(
                                    especialista.des_profissional.toString()[0])
                                : SizedBox(),
                          ),
                          title: Text(
                            'Dr(a) ' +
                                especialista.des_profissional.capitalize(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            especialista.subespecialidade.capitalize(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 8,
                              child: ListTile(
                                title: Text(
                                  itens.first.descricao,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  itens.first.obs,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      final box = context.findRenderObject()
                                          as RenderBox?;
                                      var link =
                                          'http://bioma.app.br?id_indicacao=' +
                                              widget.IdIndicacao;

                                      ShareResult result;
                                      result = await Share.shareWithResult(link,
                                          subject:
                                              'Solicitação de Procedimento ',
                                          sharePositionOrigin:
                                              box!.localToGlobal(Offset.zero) &
                                                  box.size);
                                      debugPrint(result.status.toString());
                                      print(result.status);
                                      if (result.status ==
                                          ShareResultStatus.success)
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Sucesso"),
                                        ));

                                      if (result.status !=
                                          ShareResultStatus.success)
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: primaryColor,
                                          content: Text("Cancelado"),
                                        ));
                                    },
                                    icon: Icon(Icons.share)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.56,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Procedimentos',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    children: List.generate(
                                        itens.length,
                                        (index) =>
                                            biuldIndicacaoItens(itens[index])),
                                  ),
                                  Card(
                                    elevation: 8,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Mostre o QR Code ao paciente para um agendamento mais rápido',
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        QrImage(
                                          data:
                                              'http://bioma.app.br?id_indicacao=' +
                                                  widget.IdIndicacao,
                                          version: QrVersions.auto,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          gapless: false,
                                          //embeddedImage: AssetImage('assets/imagens/biomaLogo.png'),
                                          embeddedImageStyle:
                                              QrEmbeddedImageStyle(
                                            size: Size(80, 80),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Código da Solicitação: ' +
                                                widget.IdIndicacao,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Link: ' +
                                                  'bioma.app.br?id_indicacao=' +
                                                  widget.IdIndicacao,
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget biuldIndicacaoItens(Indicacao i) {
    IndicacoesList dt = Provider.of(context, listen: false);

    return Card(
      child: ListTile(
        onTap: () {},
        // leading: Text(i.id_servico),
        title: Text(i.des_procedimento),
        trailing: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.calendar_month,
              color: primaryColor,
            )),
      ),
    );
  }
}
