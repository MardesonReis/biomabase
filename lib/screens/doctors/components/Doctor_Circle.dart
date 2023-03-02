import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';

class DoctorInforCicle extends StatefulWidget {
  Medicos doctor;
  VoidCallback press;
  DoctorInforCicle({Key? key, required this.doctor, required this.press})
      : super(key: key);

  @override
  State<DoctorInforCicle> createState() => _DoctorInforCicleState();
}

class _DoctorInforCicleState extends State<DoctorInforCicle> {
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (!mounted) return;

            setState(() {
              widget.press.call();
            });
          },
          child: Column(
            children: [
              CircleAvatar(
                //   backgroundColor: primaryColor,
                //   foregroundColor: Colors.black,
                backgroundImage: NetworkImage(
                  Constants.IMG_BASE_URL +
                      'medicos/' +
                      widget.doctor.crm +
                      '.png',
                ),
                radius: 25.0,
                onBackgroundImageError: (_, __) {
                  setState(() {
                    isError = true;
                  });
                },
                child: isError == true
                    ? Text(widget.doctor.des_profissional[0])
                    : SizedBox(),
              ),
              Text(
                'Dr(a) ' + widget.doctor.des_profissional.capitalize(),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                widget.doctor.especialidade.descricao.capitalize(),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
