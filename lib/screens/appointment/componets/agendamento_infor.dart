import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/models/AgendaMedico.dart';
import 'package:flutter/material.dart';

class AgendamentoInfor extends StatelessWidget {
  AgendamentoInfor(this.agendamento);
  final Agendamentos agendamento;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          agendamento.des_procedimento,
        ),
        SizedBox(height: 8.0),
        // RatingInformation(movie),
        SizedBox(height: 12.0),
        // Row(children: _buildCategoryChips(textTheme)),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: Image.network('src'),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Poster(
              //   movie.posterUrl,
              //   height: 180.0,
              // ),
              SizedBox(width: 16.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }
}
