import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/loading_list.dart';
import 'package:levaeu_app/screens/auth/sign_in.dart';
import 'package:levaeu_app/screens/passenger/components/ride_card.dart';

import 'package:levaeu_app/theme.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);
  static String routeName = "/passenger/home";

  @override
  _PassengerHomeState createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  bool startsAtUFCSelected = false;
  bool loadingStartsAtUFC = true;
  bool loadingEndsAtUFC = true;

  List<Map> startsAtUFCRides = [
    {
      'user': {
        'photo': 'https://leva-eu.s3.amazonaws.com/users/142e07a2-5d8c-4aaf-9f67-2c0d34c26693.png',
        'name': 'João',
      },
      'startsAt': 'Messejana',
      'endsAt': 'UFC Benfica',
      'date': '19:45 - 26/01'
    },
    {
      'user': {
        'photo': 'https://leva-eu.s3.amazonaws.com/users/3382215f-b611-4bbb-971e-88e7e3c7913d.png',
        'name': 'Wellington',
      },
      'startsAt': 'Edson Queiroz',
      'endsAt': 'UFC Pici',
      'date': '21:45 - 26/01'
    },
  ];

  List<Map> endsAtUFCRides = [
    {
      'user': {
        'photo': 'https://leva-eu.s3.amazonaws.com/users/33cd779b-efe3-457a-be7f-b9183f83981e.jpeg',
        'name': 'Gabriele',
      },
      'startsAt': 'UFC Benfica',
      'endsAt': 'Messejana',
      'date': '16:00 - 26/01'
    },
    {
      'user': {
        'photo': 'https://leva-eu.s3.amazonaws.com/users/3382215f-b611-4bbb-971e-88e7e3c7913d.png',
        'name': 'Gabriel',
      },
      'startsAt': 'UFC Pici',
      'endsAt': 'Presidente Kennedy',
      'date': '18:00 - 26/01'
    },
    {
      'user': {
        'photo': 'https://leva-eu.s3.amazonaws.com/users/142e07a2-5d8c-4aaf-9f67-2c0d34c26693.png',
        'name': 'Levi',
      },
      'startsAt': 'UFC Benfica',
      'endsAt': 'José Walter',
      'date': '18:30 - 26/01'
    },
  ];

  void getStartsAtUFC() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      loadingStartsAtUFC = false;
    });
  }

  void getEndsAtUFC() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      loadingEndsAtUFC = false;
    });
  }

  Future<void> reloadScreen() async {
    // if (loadingStartsAtUFC || loadingEndsAtUFC) {
    //   return;
    // }
    setState(() {
      loadingStartsAtUFC = true;
      loadingEndsAtUFC = true;
    });
    getStartsAtUFC();
    getEndsAtUFC();
  }

  @override
  void initState() {
    super.initState();
    getStartsAtUFC();
    getEndsAtUFC();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Passageiro',
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
              Navigator.pushNamed(context, SignIn.routeName);
            },
            child: const FaIcon(
              Icons.menu,
              color: appTextLightColor,
            ),
          ),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                },
                child: const FaIcon(
                  Icons.compare_arrows,
                  color: appTextLightColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: reloadScreen,
          color: appPrimaryColor,
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20.0),
              width: appComponentsWidth,
              child: Column(
                children: [
                  SizedBox(
                    width: appComponentsWidth,
                    child: Text(
                      'Caronas disponíveis',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: buildSearchFormField(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC4C4C4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: AnimatedContainer(
                            duration: Duration(seconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  startsAtUFCSelected = true;
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: startsAtUFCSelected
                                  ? BoxDecoration(
                                      color: appPrimaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                  )
                                  : null,
                                child: Text(
                                  'Chegando na UFC',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: startsAtUFCSelected ? Colors.white : appTextColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: AnimatedContainer(
                            duration: Duration(seconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  startsAtUFCSelected = false;
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: !startsAtUFCSelected
                                  ? BoxDecoration(
                                      color: appPrimaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                  )
                                  : null,
                                child: Text(
                                  'Saindo da UFC',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: startsAtUFCSelected ? appTextColor : Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if(startsAtUFCSelected)
                    if (loadingStartsAtUFC)
                      LoadingList(
                        width: appComponentsWidth,
                        height: 50,
                        addPadding: false
                      )
                    else
                      ...[
                        for (var ridesIndex = 0; ridesIndex < startsAtUFCRides.length; ridesIndex++)
                          RideCard(ride: startsAtUFCRides[ridesIndex])
                      ]
                  else
                    if (loadingEndsAtUFC)
                      LoadingList(
                        width: appComponentsWidth,
                        height: 50,
                        addPadding: false
                      )
                    else
                      ...[
                        for (var ridesIndex = 0; ridesIndex < endsAtUFCRides.length; ridesIndex++)
                          RideCard(ride: endsAtUFCRides[ridesIndex])
                      ]
                ],
              ),
            ),
          )
        ),
      )
    );
  }
  TextFormField buildSearchFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
      },
      decoration: AppTheme.textFieldStyle(
        labelTextStr: 'Procurar rotas e destinos',
        icon: const CustomIcon(
          icon: FontAwesomeIcons.search,
          color: appInputTextColor
        )
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }
}