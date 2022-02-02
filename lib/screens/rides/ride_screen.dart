import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:levaeu_app/components/loading_carousel.dart';
import 'package:levaeu_app/components/loading_list.dart';
import 'package:levaeu_app/screens/home/components/driver_ride_card.dart';
import 'package:levaeu_app/services/rides.dart';
import 'package:levaeu_app/theme.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({
    Key? key,
    required this.rideID
  }) : super(key: key);

  final String rideID;

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool loadingRideData = true;
  Map ride = {};

  void getRide() async {
    var result = await RidesService().retrieve(id: widget.rideID, context: context);

    if(result != null && result['success']) {
      setState(() {
        ride = result['data'];
        loadingRideData = false;
      });
    }
  }

  Future<void> reloadScreen() async {
    setState(() {
      loadingRideData = true;
    });
    getRide();
  }

  int getAvailableVacancies() {
    return ride['passengersAmount'] - ride['passengers'].length;
  }

  @override
  void initState() {
    super.initState();
    getRide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Caronas',
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
              Navigator.of(context).pop();
            },
            child: const FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: appTextLightColor,
            ),
          ),
        ),
      ),
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
                    if (loadingRideData)
                      ...[
                        LoadingCarousel(height: 150.h, width: appComponentsWidth, addPadding: false),
                        LoadingList(width: appComponentsWidth, height: 70, addPadding: false)
                      ]
                    else
                      ...[
                        DriverRideCard(
                          startLocation: ride['startLocation']['name'],
                          endLocation: ride['endLocation']['name'],
                          date: ride['date'],
                          numberOfPassengers: ride['passengers'].length,
                          totalVacancies: ride['passengersAmount']
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Solicitar carona')
                          ),
                        ),
                        Container(
                          width: appComponentsWidth,
                          margin: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Rota do motorista',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp
                            ),
                          )
                        ),
                        SizedBox(
                          width: appComponentsWidth,
                          child: Stepper(
                            currentStep: ride['pickupPoints'].length - 1,
                            controlsBuilder: (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                              return Row(
                                children: <Widget>[
                                  Container(
                                    child: null,
                                  ),
                                  Container(
                                    child: null,
                                  ),
                                ],
                              );
                            },
                            steps: <Step>[
                              for (var index = 0; index < ride['pickupPoints'].length; index++) 
                                Step(
                                  title: SizedBox(
                                    child: Text(ride['pickupPoints'][index]['name']),
                                  ),
                                  content: Text('')
                                ),
                            ],
                          )
                        ),
                        Container(
                          width: appComponentsWidth,
                          child: Text(
                            'Pessoas confirmadas na carona',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp
                            ),
                          )
                        ),
                        Row(
                          children: [
                            if(ride['passengers'].length < ride['passengersAmount'])
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                padding: const EdgeInsets.all(10.0),
                                width: appComponentsWidth/1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: appPrimaryColor
                                ),
                                child: Text(
                                  '+${getAvailableVacancies()} vaga${getAvailableVacancies() > 1 ? 's' : ''} disponíve${getAvailableVacancies() > 1 ? 'is' : 'l'}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white
                                  ),
                                ),
                              )
                          ],
                        ),
                        Container(
                          width: appComponentsWidth,
                          margin: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Informações do motorista',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp
                            ),
                          )
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: appBorderColors, width: 2),
                            borderRadius: const BorderRadius.all(Radius.circular(8))
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 45.0.w,
                                  child: Container(
                                    width: 45.0.w,
                                    height: 45.0.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: appPrimaryColor, width: 2),
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                      image: ride['driver']['photo'] != null
                                        ? DecorationImage(
                                          image: NetworkImage( ride['driver']['photo']),
                                          fit: BoxFit.cover,
                                        )
                                        : null
                                    ),
                                    child:  ride['driver']['photo'] == null
                                      ? const Icon(
                                        Icons.person,
                                        color: appTextLightColor,
                                      )
                                      : null,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    ride['driver']['name'],
                                  ),
                                )
                              ]
                            )
                          )
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