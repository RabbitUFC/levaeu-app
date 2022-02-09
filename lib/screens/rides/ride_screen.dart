import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:levaeu_app/components/loading_carousel.dart';
import 'package:levaeu_app/components/loading_list.dart';
import 'package:levaeu_app/hive/user.dart';
import 'package:levaeu_app/screens/home/components/driver_ride_card.dart';
import 'package:levaeu_app/services/rides.dart';
import 'package:levaeu_app/services/rides_requests.dart';
import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/hive.dart';
import 'package:levaeu_app/utils/toast.dart';

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
  var box = Hive.box(userBox);

  bool loadingRideData = true;
  bool creatingRideRequest = false;
  bool rideRequestAlreadyMade = false;

  Map ride = {};

  void getRide() async {
    var result = await RidesService().retrieve(id: widget.rideID, context: context);

    if(result != null && result['success']) {
      setState(() {
        ride = result['data'];
      });
      getRideRequest();
    }
  }

  void getRideRequest() async {
    User user = box.get('user');

    var response = await RidesRequestsService().list(
      query: {
        'ride': ride['_id'],
        'passenger': user.id
      },
      context: context
    );
    setState(() {
      loadingRideData = false;
    });
    if(response != null && response['success']) {
      setState(() {
        rideRequestAlreadyMade = response['data'].length > 0;
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

  void createRideRequest() async {
    User user = box.get('user');
    
    setState(() {
      creatingRideRequest = true;
    });

    var response = await RidesRequestsService().create(
      data: {
        'ride': ride['_id'],
        'passenger': user.id
      },
      context: context
    );

    setState(() {
      creatingRideRequest = false;
    });

    if (response != null && response['success']) {
      toast(
        message: 'Solicitação criada com sucesso.',
        context: context,
        type: 'success'
      );
      Navigator.of(context).pop();
    }
  }

  bool verifyDriverEqualsToUser() {
    User user = box.get('user');

    return ride['driver']['_id'] == user.id;
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
                          rideID: ride['_id'],
                          startLocation: ride['startLocation']['name'],
                          endLocation: ride['endLocation']['name'],
                          date: ride['date'],
                          numberOfPassengers: ride['passengers'].length,
                          totalVacancies: ride['passengersAmount'],
                          numOfRequests: 0
                        ),

                        if(!verifyDriverEqualsToUser())
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              onPressed: creatingRideRequest || rideRequestAlreadyMade ? null : () {
                                createRideRequest();
                              },
                              child: creatingRideRequest
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                                : Text(
                                  rideRequestAlreadyMade
                                    ? 'Você já soliticou uma vaga nessa carona.'
                                    : 'Solicitar carona',
                                  textAlign: TextAlign.center
                                )
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
                        SizedBox(
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