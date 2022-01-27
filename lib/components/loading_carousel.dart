import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

import 'package:levaeu_app/theme.dart';

class LoadingCarousel extends StatelessWidget {
  const LoadingCarousel({
    Key? key,
    required this.width,  
    required this.height,
    this.addPadding = true
  }) : super(key: key);

  final double width;
  final double height;
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget> [
          if (addPadding)
            Padding(padding: EdgeInsets.only(
              left: ((ScreenUtil().screenWidth - appComponentsWidth)/2)
            )),
          SizedBox(
            width: width,
            height: height,
            child: const SkeletonItem(
              child: SkeletonAvatar(),
            ),
          ),
          if (addPadding)
            Padding(padding: EdgeInsets.only(
              right: ((ScreenUtil().screenWidth - appComponentsWidth)/2)
            )),
        ]
      ),
    );
  }
}