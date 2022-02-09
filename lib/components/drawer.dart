import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:levaeu_app/hive/user.dart';
import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/hive.dart';

class LevaEuDrawer extends StatelessWidget {
  const LevaEuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(userBox).listenable(),
      builder: (BuildContext context, Box box, Widget? child) {
        User user = box.get('user');
        return SizedBox(
          child: Drawer(
            child: Container(
              color:  user.selectedType == 'passenger'
                ? appPrimaryColor
                : appSecondaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(10.0),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 60.0.w,
                                  height: 60.0.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white, width: 2),
                                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    image: user.photo != ''
                                      ? DecorationImage(
                                        image: NetworkImage( user.photo),
                                        fit: BoxFit.cover,
                                      )
                                      : null
                                  ),
                                  child:  user.photo == ''
                                    ? const Icon(
                                      Icons.person,
                                      color: appTextLightColor,
                                    )
                                    : null,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const ListTile(
                            title: Text(
                              'Perfil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            title: Text(
                              'Configurações',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            title: Text(
                              'Ajuda',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            title: Text(
                              'Sair',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 20),
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        // This container holds all the children that will be aligned
                        // on the bottom and should not scroll with the above ListView
                        child: Column(
                          children: const <Widget>[
                             Divider(),
                            ListTile(
                              title: Text(
                                'Versão 1.0.0',
                                style: TextStyle(color: Colors.white),
                              )
                            )
                          ],
                        )
                      )
                    )
                  ],
                ),
              ),
            )
          )
        );
      }
    );
  }
}
