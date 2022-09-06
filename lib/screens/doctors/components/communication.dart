import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class Communication extends StatelessWidget {
  const Communication({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 0),
            backgroundColor: Color(0xFF51BEFB).withOpacity(0.75),
          ),
          onPressed: () {},
          icon: SvgPicture.asset("assets/icons/Call.svg"),
          label: Text(""),
        ),
      ],
    );
  }
}
