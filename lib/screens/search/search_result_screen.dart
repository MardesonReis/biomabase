import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/AvailableDoctor.dart';
import 'package:biomaapp/models/SearchDoctor.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/screens/home/components/available_doctors.dart';
import 'package:biomaapp/screens/home/components/recommended_doctor_card.dart';
import 'package:biomaapp/screens/home/components/recommended_doctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components/search_doctor_card.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Selected area",
              style: Theme.of(context).textTheme.caption,
            ),
            Text("Boston"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/icons/Chat.svg"),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: [
                    SectionTitle(
                      title: "All Cardiologist",
                      pressOnSeeAll: () {},
                      OnSeeAll: true,
                    ),
                    ...List.generate(
                      demo_search_doctors.length,
                      (index) => SearchDoctorCard(
                          info: demo_search_doctors[index], press: () {}
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DoctorDetailsScreen(doctor: Medicos(),),
                          //   ),
                          // ),
                          ),
                    ),
                  ],
                ),
              ),
              AvailableDoctors(),
            ],
          ),
        ),
      ),
    );
  }
}
