import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/minhasaude_list.dart';
import 'package:biomaapp/models/ms_registro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class BuildGrafico extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final MinhaSaude minhaSaude;
  BuildGrafico({Key? key, required this.minhaSaude}) : super(key: key);

  @override
  BuildGraficoState createState() => BuildGraficoState();
}

class BuildGraficoState extends State<BuildGrafico> {
  bool _isLoading = true;
  //List<FlSpot> spots = [];
  List<double> x = [];
  List<double> y = [];
  var _onePercentRange = 0.0;
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
    return minhasaude
        .listar(auth.fidelimax.cpf, '', widget.minhaSaude.id)
        .then((value) {
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

    // buscarRegistros();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  spots.clear();

    List<Ms_registro> Dados = [];
    List<SplineSeries<Ms_registro, String>> charts = [];
    MinhaSaudeList minhasaude = Provider.of(context);
    List<MinhaSaude> grupos = [];

    Dados = minhasaude.items;

    List<Map<String, List<Ms_registro>>> dados = [];

    minhasaude.tipos.map((e) {
      minhasaude.tipos
          .where((element) => element.subgrupo == widget.minhaSaude.subgrupo)
          .toList()
          .map((el) {
        if (!grupos.contains(el)) {
          grupos.add(el);
        }
      }).toList();

      // if (d.isNotEmpty) charts.add(returLines(d, widget.minhaSaude));
    }).toList();
    //grupos.map((e) => charts.add(returLines(grupos, widget.minhaSaude))).toList();
    print(grupos.toString());
    grupos.map((e) {
      var d = Dados.where((element) => element.ms_id == e.id).toList();
      if (d.isNotEmpty) charts.add(returLines(d, e));
    }).toList();

    return Column(
      children: [
        SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            //  title: ChartTitle(text: 'Half yearly sales analysis'),

            // Enable legend
            legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                alignment: ChartAlignment.center),
            // Enable tooltip
            // isTransposed: true,
            tooltipBehavior: TooltipBehavior(enable: true),
            series: charts),
      ],
    );
  }
}

SplineSeries<Ms_registro, String> returLines(
    List<Ms_registro> Dados, MinhaSaude minhaSaude) {
  return SplineSeries<Ms_registro, String>(
      // dashArray: <double>[5, 5],
      splineType: SplineType.cardinal,
      cardinalSplineTension: 0.8,
      dataSource: Dados,
      xValueMapper: (Ms_registro ms, _) =>
          ms.data_registro.day.toString() +
          '/' +
          ms.data_registro.month.toString() +
          '/' +
          ms.data_registro.year.toString(),
      yValueMapper: (Ms_registro ms, _) => double.tryParse(ms.ms_value) ?? 0,
      name: minhaSaude.medida,
      // Enable data label
      isVisibleInLegend: true,
      markerSettings: MarkerSettings(isVisible: true),
      legendIconType: LegendIconType.circle,
      sortFieldValueMapper: (datum, index) => datum.obs,
      // dataLabelMapper: (datum, index) => datum.data_registro.toString(),
      //  pointColorMapper: (datum, index) => redColor,

      xAxisName: 'Data',
      yAxisName: minhaSaude.medida,
      emptyPointSettings:
          EmptyPointSettings(borderWidth: 8, borderColor: redColor),
      dataLabelSettings: DataLabelSettings(isVisible: true));
}
