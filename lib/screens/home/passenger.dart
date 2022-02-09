import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:levaeu_app/components/appbar.dart';

import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/drawer.dart';
import 'package:levaeu_app/components/loading_list.dart';
import 'package:levaeu_app/screens/home/components/no_rides_card.dart';
import 'package:levaeu_app/screens/home/components/ride_card.dart';
import 'package:levaeu_app/services/rides.dart';

import 'package:levaeu_app/theme.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);
  static String routeName = "/home/passenger";

  @override
  _PassengerHomeState createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  bool startsAtUFCSelected = true;
  bool loadingStartsAtUFC = true;
  bool loadingEndsAtUFC = true;

  List<dynamic> startsAtUFCRides = [];
  List<dynamic> endsAtUFCRides = [];

  void getStartsAtUFC() async {
    getEndsAtUFC();
    var response = await RidesService().list(
      query: {
        'startLocationByName': 'UFC'
      },
      context: context
    );

    setState(() {
      startsAtUFCRides = response['data'];
      loadingStartsAtUFC = false;
    });
  }

  void getEndsAtUFC() async {
    var response = await RidesService().list(
      query: {
        'endLocationByName': 'UFC'
      },
      context: context
    );

    setState(() {
      endsAtUFCRides = response['data'];
      loadingEndsAtUFC = false;
    });
  }

  Future<void> reloadScreen() async {
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
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LevaEuDrawer(),
      appBar: const LevaEuAppBar(title: 'Passageiro'),
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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  startsAtUFCSelected = true;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                    fontSize: 12.0.sp,
                                    color: startsAtUFCSelected ? Colors.white : appTextColor
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
                                  startsAtUFCSelected = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                    fontSize: 12.0.sp,
                                    color: startsAtUFCSelected ? appTextColor : Colors.white
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
                          if (startsAtUFCRides.isEmpty)
                            const NoRidesCard(),

                          if(startsAtUFCRides.isNotEmpty)
                            for (var ridesIndex = 0; ridesIndex < startsAtUFCRides.length; ridesIndex++)
                              RideCard(
                                rideID: startsAtUFCRides[ridesIndex]['_id'],
                                driver: startsAtUFCRides[ridesIndex]['driver'],
                                startLocation: startsAtUFCRides[ridesIndex]['startLocation']['name'],
                                endLocation: startsAtUFCRides[ridesIndex]['endLocation']['name'],
                                date: startsAtUFCRides[ridesIndex]['date'],
                                numberOfPassengers: startsAtUFCRides[ridesIndex]['passengers'].length,
                                totalVacancies: startsAtUFCRides[ridesIndex]['passengersAmount'],
                                pickupPoints: startsAtUFCRides[ridesIndex]['pickupPoints'],
                              )
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
                          if (endsAtUFCRides.isEmpty)
                            const NoRidesCard(),

                            for (var ridesIndex = 0; ridesIndex < endsAtUFCRides.length; ridesIndex++)
                              RideCard(
                                rideID: endsAtUFCRides[ridesIndex]['_id'],
                                driver: endsAtUFCRides[ridesIndex]['driver'],
                                startLocation: endsAtUFCRides[ridesIndex]['startLocation']['name'],
                                endLocation: endsAtUFCRides[ridesIndex]['endLocation']['name'],
                                date: endsAtUFCRides[ridesIndex]['date'],
                                numberOfPassengers: endsAtUFCRides[ridesIndex]['passengers'].length,
                                totalVacancies: endsAtUFCRides[ridesIndex]['passengersAmount'],
                                pickupPoints: endsAtUFCRides[ridesIndex]['pickupPoints'],
                              )
                        ]
                  ],
                ),
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