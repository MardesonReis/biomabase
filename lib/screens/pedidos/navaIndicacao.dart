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
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_itens_screen.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart' as dr;

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
  late Medicos especialista;
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
      Medicos.toId(indicacoes.items.first.cod_especialista).then((value) {
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
    filtrosAtivos filtros = auth.filtrosativos;
    Paginas pages = auth.paginas;

    mockResults = auth.filtrosativos.medicos;
    var user = Usuario();
    if (itens.isNotEmpty) {
      user.cpf = itens.first.autor;
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Link \n', 'de agendamentos', () {}, [])),
      drawer: AppDrawer(),
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
                        // textResp('Você Recebeu uma indicação de'),
                        Text(
                          'Você recebeu uma indicação de',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        user.cpf.isNotEmpty
                            ? UserCard(user: user, press: () {})
                            : SizedBox(),
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
                                        dr.QrImageView(
                                          data:
                                              'http://bioma.app.br?id_indicacao=' +
                                                  widget.IdIndicacao,
                                          version: dr.QrVersions.auto,
                                          size: 200.0,
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
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    Procedimento procedimentos = Procedimento();

    return Card(
      child: ListTile(
        onTap: () {},
        // leading: Text(i.id_servico),
        title: Text(i.des_procedimento),
        trailing: IconButton(
            onPressed: () async {
              Medicos medico = await Medicos.toId(i.cod_especialista);
              procedimentos.loadProcedimentosID(i.cod_especialista, '0', '0',
                  i.cod_unidade, i.cod_procedimento, i.cod_convenio);

              Convenios convenio = Convenios(
                  cod_convenio: i.cod_convenio, desc_convenio: i.des_convenio);
              Especialidade especialidade = Especialidade(
                  cod_especialidade: i.cod_especialidade,
                  des_especialidade: i.des_especialidade,
                  ativo: 'S');

              procedimentos.especialidade = especialidade;
              procedimentos.olho = i.olho;
              filtros.LimparMedicos();
              filtros.addMedicos(medico);
              filtros.LimparProcedimentos();
              filtros.AddProcedimentos(procedimentos);
              filtros.LimparConvenios();
              filtros.addConvenios(convenio);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentScreen(
                    press: () {
                      setState(() {});
                    },
                  ),
                ),
              ).then((value) => {
                    setState(() {}),
                  });
            },
            icon: Icon(
              Icons.calendar_month,
              color: primaryColor,
            )),
      ),
    );
  }
}
