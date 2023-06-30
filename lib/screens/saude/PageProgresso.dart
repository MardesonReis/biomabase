import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/minhasaude_list.dart';
import 'package:biomaapp/models/ms_registro.dart';
import 'package:biomaapp/screens/saude/grafico_2.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class Progresses extends StatefulWidget {
  const Progresses({Key? key}) : super(key: key);

  @override
  State<Progresses> createState() => _ProgressesState();
}

class _ProgressesState extends State<Progresses> {
  bool _isLoading = true;

  Future<void> buscarRegistros() {
    var minhasaude = Provider.of<MinhaSaudeList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    setState(() {
      _isLoading = true;
    });
    return minhasaude.listar(auth.fidelimax.cpf, '', '').then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void initState() {
    var minhasaude = Provider.of<MinhaSaudeList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    buscarRegistros();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<String> grupos = Set();
    List<Ms_registro> p_a = [];
    Set<String> itens = Set();
    List<Ms_registro> org = [];
    MinhaSaudeList minhasaude = Provider.of(context);
    List<MinhaSaude> ms = [];
    var subGrupo = [];
    minhasaude.tipos.map((element) {
      if (!subGrupo.contains(element.subgrupo)) {
        ms.add(element);
        subGrupo.add(element.subgrupo);
      }
    }).toList();
    ms.retainWhere((tp) => minhasaude.items
        .where((element) => element.ms_id == tp.id)
        .toList()
        .isNotEmpty);

    return GroupedListView<MinhaSaude, String>(
      elements: ms,
      groupBy: (element) => element.subgrupo,
      groupSeparatorBuilder: (groupByValue) {
        return ListTile(tileColor: primaryColor, title: Text(groupByValue));
      },
      itemBuilder: (context, MinhaSaude element) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: BuildGrafico(minhaSaude: element),
      ),
      itemComparator: (item1, item2) =>
          item1.subgrupo.compareTo(item2.subgrupo), // optional
      //  useStickyGroupSeparators: true, // optional
      // floatingHeader: true, // optional
      order: GroupedListOrder.ASC,
      // optional
    );
  }
}
