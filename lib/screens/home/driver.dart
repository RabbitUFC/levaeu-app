import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:levaeu_app/components/appbar.dart';
import 'package:levaeu_app/components/loading_list.dart';
import 'package:levaeu_app/screens/home/components/driver_ride_card.dart';
import 'package:levaeu_app/screens/home/components/no_rides_card.dart';

import 'package:levaeu_app/services/rides.dart';
import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/hive.dart';
import 'package:levaeu_app/hive/user.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);
  static String routeName = "/home/driver";

  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  Box box = Hive.box(userBox);
  String? userID;

  bool activeRidesSelected = true;
  bool loadingActiveRides = true;
  bool loadingFinishedRides = true;

  List<dynamic> activeRides = [];
  List<dynamic> finishedRides = [];

  void getActiveRides() async {
    var response = await RidesService().list(
      query: {
        'driver': userID
      },
      context: context
    );

    setState(() {
      loadingActiveRides = false;
      activeRides = response['data'];
    });
  }

  void getFinishedRides() async {
    var response = await RidesService().list(
      query: {
        'driver': userID,
        'active': false
      },
      context: context
    );

    setState(() {
      loadingFinishedRides = false;
      finishedRides = response['data'];
    });
  }

  Future<void> reloadScreen() async {
    setState(() {
      loadingActiveRides = true;
      loadingFinishedRides = true;
    });

    getActiveRides();
    getFinishedRides();
  }

  @override
  void initState() {
    super.initState();
    User user = box.get('user');
    setState(() {
      userID = user.id;
    });

    getActiveRides();
    getFinishedRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LevaEuAppBar(title: 'Motorista'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: reloadScreen,
          color: appPrimaryColor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: appComponentsWidth,
                child: Column(
                  children: [
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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeRidesSelected = true;
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: activeRidesSelected
                                  ? BoxDecoration(
                                      color: appSecondaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                  )
                                  : null,
                                child: Text(
                                  'Caronas ativas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: activeRidesSelected ? Colors.white : appTextColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeRidesSelected = false;
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: !activeRidesSelected
                                  ? BoxDecoration(
                                      color: appSecondaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                  )
                                  : null,
                                child: Text(
                                  'Caronas finalizadas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: activeRidesSelected ? appTextColor : Colors.white
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if(activeRidesSelected)
                      if (loadingActiveRides)
                        LoadingList(
                          width: appComponentsWidth,
                          height: 50,
                          addPadding: false
                        )
                      else
                        ...[
                          if (activeRides.isEmpty)
                            const NoRidesCard(),

                          for (var ridesIndex = 0; ridesIndex < activeRides.length; ridesIndex++)
                            DriverRideCard(
                              startLocation: activeRides[ridesIndex]['startLocation']['name'],
                              endLocation: activeRides[ridesIndex]['endLocation']['name'],
                              date: activeRides[ridesIndex]['date'],
                              numberOfPassengers: activeRides[ridesIndex]['passengers'].length,
                              totalVacancies: activeRides[ridesIndex]['passengersAmount'],
                            )
                        ]
                    else
                      if (loadingFinishedRides)
                        LoadingList(
                          width: appComponentsWidth,
                          height: 50,
                          addPadding: false
                        )
                      else
                        ...[
                          if (finishedRides.isEmpty)
                            const NoRidesCard(),

                          for (var ridesIndex = 0; ridesIndex < finishedRides.length; ridesIndex++)
                            DriverRideCard(
                              startLocation: finishedRides[ridesIndex]['startLocation']['name'],
                              endLocation: finishedRides[ridesIndex]['endLocation']['name'],
                              date: finishedRides[ridesIndex]['date'],
                              numberOfPassengers: finishedRides[ridesIndex]['passengers'].length,
                              totalVacancies: finishedRides[ridesIndex]['passengersAmount'],
                            )
                        ]
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}