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
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class IndicacoesItensScren extends StatefulWidget {
  Indicacao indicacao;
  IndicacoesItensScren({Key? key, required this.indicacao}) : super(key: key);

  @override
  State<IndicacoesItensScren> createState() => _IndicacoesItensScrenState();
}

class _IndicacoesItensScrenState extends State<IndicacoesItensScren> {
  bool _isLoading = true;
  bool _isLoadingDados = true;
  bool _isLoadingIndicacao = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  Set<String> Id_indicacao_Inclusas = Set();
  Set<String> MedicosInclusos = Set();
  Set<String> ProcedimentosInclusos = Set();
  List<Indicacao> itens = [];
  List<Procedimento> procedimentos = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var indicacoes = Provider.of<IndicacoesList>(
      context,
      listen: false,
    );

    var dados = Provider.of<DataList>(
      context,
      listen: false,
    );

    dados.items.isEmpty
        ? dados.loadDados('').then((value) => setState(() {
              _isLoadingDados = false;
            }))
        : setState(() {
            _isLoadingDados = false;
          });

    await indicacoes.loadIndicacoes(auth.fidelimax.cpf, '0', '0').then((value) {
      setState(() {
        _isLoadingIndicacao = false;

        var itens = indicacoes.items
            .where((element) =>
                element.id_indicacao == widget.indicacao.id_indicacao)
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicacoesList dt_indcacao = Provider.of(context, listen: false);
    DataList dt = Provider.of(context, listen: false);

    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;

    mockResults = auth.filtrosativos.medicos;

    dt_indcacao.items.map((e) {
      if (e.id_indicacao == widget.indicacao.id_indicacao) {
        if (!Id_indicacao_Inclusas.contains(e.id_servico)) {
          print(e.id_servico + '\n');
          Id_indicacao_Inclusas.add(e.id_servico);
          itens.add(e);
        }
      }
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('', widget.indicacao.descricao, () {}, [])),
      //  drawer: AppDrawer(),
      body: _isLoading && _isLoadingDados && _isLoadingIndicacao
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(itens.length,
                        (index) => biuldIndicacaoItens(itens[index])),
                  ),
                ),
              ),
            ),
    );
  }

  Widget biuldIndicacaoItens(Indicacao i) {
    IndicacoesList dt = Provider.of(context, listen: false);

    return Card(
      child: ListTile(
        onTap: () {},
        leading: Text(i.id_servico),
        title: Text(i.des_procedimento),
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
            onPressed: () {},
            icon: Icon(
              Icons.swap_horizontal_circle_sharp,
              color: primaryColor,
            )),
      ),
    );
  }
}
