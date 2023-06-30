import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/minhasaude.dart';
import 'package:biomaapp/models/minhasaude_list.dart';
import 'package:biomaapp/models/ms_registro.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraficoDeLinha extends StatefulWidget {
  final MinhaSaude minhaSaude;
  List<Ms_registro> Dados = [];
  GraficoDeLinha({required this.minhaSaude});

  @override
  State<GraficoDeLinha> createState() => _GraficoDeLinhaState();
}

class _GraficoDeLinhaState extends State<GraficoDeLinha> {
  bool _isLoading = true;
  List<FlSpot> spots = [];
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
    spots.clear();
    widget.Dados.clear();
    MinhaSaudeList minhasaude = Provider.of(context);

    widget.Dados = minhasaude.items;
    var Dados = widget.Dados;
    Dados.retainWhere((element) => element.ms_id == widget.minhaSaude.id);

    Dados.map((e) {
      var v_x = e.data_registro.month.toDouble() ?? 0;
      var v_y = double.tryParse(e.ms_value) ?? 0;

      x.add(v_x);
      y.add(v_y);
      FlSpot flSpot = FlSpot(v_x, v_y);
      spots.add(flSpot);
    }).toList();
    x.sort();
    y.sort();

    return Column(
      children: [
        ListTile(
            title: Text(widget.minhaSaude.medida),
            subtitle: Text(widget.minhaSaude.descricao)),
        AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: LineChart(
              sampleData1,
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: x.first,
        maxX: x.last,
        maxY: y.last,
        minY: y.first,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        //   lineChartBarData1_2,
        //  lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );

    return Column(
      children: [
        Text(value.toString(), style: style, textAlign: TextAlign.center),
        Text(widget.minhaSaude.medida,
            style: style, textAlign: TextAlign.center),
      ],
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 5,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: style);
        break;
      case 2:
        text = const Text('FEV', style: style);
        break;
      case 3:
        text = const Text('MAR', style: style);
        break;
      case 4:
        text = const Text('ABR', style: style);
        break;
      case 5:
        text = const Text('MAI', style: style);
        break;
      case 6:
        text = const Text('JUN', style: style);
        break;
      case 7:
        text = const Text('JUL', style: style);
        break;
      case 8:
        text = const Text('AGO', style: style);
        break;
      case 9:
        text = const Text('SET', style: style);
        break;
      case 10:
        text = const Text('OUT', style: style);
        break;
      case 11:
        text = const Text('NOV', style: style);
        break;
      case 12:
        text = const Text('DEZ', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: primaryColor,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.pinkAccent,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.pink.withOpacity(0),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Colors.cyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );
}
