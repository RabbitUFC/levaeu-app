import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:levaeu_app/theme.dart';

class NoRidesCard extends StatelessWidget {
  const NoRidesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: appBorderColors, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Center(
        child: Text(
          'Nenhuma carona encontrada no momento.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: appTextLightColor
          ),
        )
      )
    );
  }
}