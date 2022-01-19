import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:levaeu_app/theme.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150.w,
          child: Image.asset('assets/logos/logo-2x.png'),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.h),
          width: appComponentsWidth,
          child: Text(
            'Caronas rápidas e seguras à um click de distância!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal
            )
          ),
        ),
      ],
    );
  }
}