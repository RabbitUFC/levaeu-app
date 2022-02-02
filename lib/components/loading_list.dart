import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

import 'package:levaeu_app/theme.dart';

class LoadingList extends StatelessWidget {
  const LoadingList({
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
      padding: EdgeInsets.only(
        left: addPadding ? ((ScreenUtil().screenWidth - appComponentsWidth)/2) : 0
      ),
      child: Row(
        children: <Widget> [
          Column(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: const SkeletonItem(
                  child: SkeletonAvatar(),
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: width,
                height: height,
                child: const SkeletonItem(
                  child: SkeletonAvatar(),
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}