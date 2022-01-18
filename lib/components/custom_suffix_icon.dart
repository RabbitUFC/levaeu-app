import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:levaeu_app/theme.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    this.icon = FontAwesomeIcons.user,
    this.color = appBlackIconsColor,
  }) : super(key: key);

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        20.w,
        20.w,
        20.w,
      ),
      child: FaIcon(
        icon,
        size: 18.w,
        color: color,
      ),
    );
  }
}