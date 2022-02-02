import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:levaeu_app/hive/user.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/hive.dart';

class LevaEuAppBar extends StatelessWidget with PreferredSizeWidget {
  const LevaEuAppBar({
    Key? key,
    required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box(userBox);

    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: appTextColor
          ),
        ),
        centerTitle: true,
        leading: Center(
          child: GestureDetector(
            onTap: () {
            },
            child: const FaIcon(
              Icons.menu,
              color: appTextLightColor,
              size: 32
            ),
          ),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  User user = box.get('user');
                  user.selectedType = user.selectedType == 'driver' 
                    ? 'passenger'
                    : 'driver';
                  box.put('user', user);
                },
                child: const FaIcon(
                  Icons.compare_arrows,
                  color: appTextLightColor,
                  size: 32
                ),
              ),
            ),
          ),
        ],
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}