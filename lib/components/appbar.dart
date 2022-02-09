import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:levaeu_app/hive/user.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/hive.dart';

class LevaEuAppBar extends StatelessWidget with PreferredSizeWidget {
  const LevaEuAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20.sp, fontWeight: FontWeight.bold, color: appTextColor),
      ),
      centerTitle: true,
      leading: Center(
        child: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const FaIcon(Icons.menu, color: appTextLightColor, size: 32),
        ),
      ),
      actions: [
        Center(
          child: ValueListenableBuilder(
            valueListenable: Hive.box(userBox).listenable(),
            builder: (BuildContext context, Box box, Widget? child) {
              User user = box.get('user');
              return Container(
                height: 40,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: user.selectedType == 'driver'
                    ? appSecondaryColor
                    : appPrimaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        user.selectedType = user.selectedType == 'driver'
                          ? 'passenger'
                          : 'driver';
                        box.put('user', user);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: user.selectedType == 'driver'
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: appSecondaryColor, width: 2)
                              )
                            : null,
                        child: Icon(
                          FontAwesomeIcons.car,
                          color: user.selectedType == 'driver'
                            ? appSecondaryColor
                            : Colors.white,
                          size: 18,
                        )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        user.selectedType = user.selectedType == 'driver'
                          ? 'passenger'
                          : 'driver';
                        box.put('user', user);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: user.selectedType == 'passenger'
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: appPrimaryColor, width: 2)
                              )
                            : null,
                        child: Icon(
                          FontAwesomeIcons.walking,
                          color: user.selectedType == 'passenger'
                            ? appPrimaryColor
                            : Colors.white,
                          size: 18,
                        )
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
