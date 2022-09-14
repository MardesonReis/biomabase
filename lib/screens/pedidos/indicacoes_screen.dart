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
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_itens_screen.dart';
import 'package:biomaapp/screens/pedidos/navaIndicacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class IndicacoesScreen extends StatefulWidget {
  const IndicacoesScreen({Key? key}) : super(key: key);

  @override
  State<IndicacoesScreen> createState() => _IndicacoesScreenState();
}

class _IndicacoesScreenState extends State<IndicacoesScreen> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  Set<String> Id_indicacao_Inclusas = Set();
  Set<String> MedicosInclusos = Set();
  List<Indicacao> indicacoes = [];
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

    indicacoes.loadIndicacoes(auth.fidelimax.cpf, '0', '0').then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicacoesList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;

    mockResults = auth.filtrosativos.medicos;

    dt.indicacoes.map((e) {
      if (!Id_indicacao_Inclusas.contains(e.id_indicacao)) {
        Id_indicacao_Inclusas.add(e.id_indicacao);
        indicacoes.add(e);
      }
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Filas de\n', 'Indicações', () {}, [])),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(indicacoes.length,
                        (index) => biuldIndicacao(indicacoes[index])),
                  ),
                ),
              ),
            ),
    );
  }

  Widget biuldIndicacao(Indicacao i) {
    IndicacoesList dt = Provider.of(context, listen: false);

    var itens = dt.indicacoes
        .where((element) => element.id_indicacao.contains(i.id_indicacao))
        .toList();
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NovaIndicacao(IdIndicacao: i.id_indicacao),
            ),
          ).then((value) => {
                setState(() {}),
              });
        },
        leading: Text(i.id_indicacao),
        title: Text(i.descricao),
        subtitle: Row(
          children: [
            CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    itens.length.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                maxRadius: 12),
            Text(' Itens'),
          ],
        ),
        trailing: IconButton(
            onPressed: () async {
              final box = context.findRenderObject() as RenderBox?;
              var link = 'http://bioma.app.br?id_indicacao=' + i.id_indicacao;

              ShareResult result;
              result = await Share.shareWithResult(link,
                  subject: 'Solicitação de Procedimento ',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size);
              debugPrint(result.status.toString());
              print(result.status);
              if (result.status == ShareResultStatus.success)
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Sucesso"),
                ));

              if (result.status != ShareResultStatus.success)
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Cancelado"),
                ));

              // abrirUrl('http://bioma.app.br?id_indicacao=' + i.id_indicacao);
            },
            icon: Icon(
              Icons.share,
              color: primaryColor,
            )),
      ),
    );
  }
}
