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

class RideDriverScreen extends StatefulWidget {
  const RideDriverScreen({
    Key? key,
    required this.rideID
  }) : super(key: key);

  final String rideID;

  @override
  State<RideDriverScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideDriverScreen> {
  var box = Hive.box(userBox);

  bool loadingRideData = true;
  bool updatingRequest = false;
  bool rideRequestAlreadyMade = false;

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

  void updateRideRequest(requestIndex, status) async {
    var rideRequest = ride['requests'][requestIndex];

    var data = {
      'ride': rideRequest['ride'],
      'passenger': rideRequest['passenger']['_id'],
      'status': status,
    };
    setState(() {
      ride['requests'][requestIndex]['loading'] = true;
    });

    var response = await RidesRequestsService().update(
      rideID: rideRequest['_id'],
      data: data,
      context: context
    );

    setState(() {
      ride['requests'][requestIndex]['loading'] = false;
    });

    if (response != null && response['success']) {
      var type = status == 'denied'
        ? 'negada'
        : 'aceita'; 
      toast(
        message: 'Solicitação $type com sucesso.',
        context: context,
        type: 'success'
      );
      reloadScreen();
    } else {
      toast(
        message: 'Algo de errado aconteceu. Tente novamente.',
        context: context,
        type: 'error'
      );
    }
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
                        if (ride['requests'].length > 0)
                          Container(
                            width: appComponentsWidth,
                            margin: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              'Solicitações de carona',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp
                              ),
                            )
                          ),
                        for (var requestIndex = 0; requestIndex < ride['requests'].length; requestIndex++)
                          Stack(
                            children: [
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
                                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                                            image: ride['requests'][requestIndex]['passenger']['photo'] != null
                                              ? DecorationImage(
                                                image: NetworkImage( ride['requests'][requestIndex]['passenger']['photo']),
                                                fit: BoxFit.cover,
                                              )
                                              : null
                                          ),
                                          child: ride['requests'][requestIndex]['passenger']['photo'] == null
                                            ? const Icon(
                                              Icons.person,
                                              color: appTextLightColor,
                                            )
                                            : null,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 10, left: 10),
                                            child: Text(
                                              ride['requests'][requestIndex]['passenger']['name'],
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: appTextLightColor
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 10, left: 10),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: ride['requests'][requestIndex]['loading'] != null && ride['requests'][requestIndex]['loading'] ? null : () {
                                                    updateRideRequest(requestIndex, 'denied');
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(25),
                                                      border: Border.all(color: appSecondaryColor, width: 2)
                                                    ),
                                                    child: const Text(
                                                      'Recusar',
                                                      style: TextStyle(
                                                        color: appSecondaryColor,
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    )
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: ride['requests'][requestIndex]['loading'] != null && ride['requests'][requestIndex]['loading'] ? null : () {
                                                    updateRideRequest(requestIndex, 'accepted');
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    margin: const EdgeInsets.only(left: 10),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: appSecondaryColor,
                                                      borderRadius: BorderRadius.circular(25),
                                                      border: Border.all(color: appSecondaryColor, width: 2)
                                                    ),
                                                    child: const Text(
                                                      'Aceitar',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ]
                                  )
                                ),
                              ),
                              if (ride['requests'][requestIndex]['loading'] != null && ride['requests'][requestIndex]['loading'])
                                Positioned.fill(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                                    color: Colors.black26,
                                    child: const Center(
                                      child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                      ),
                                    ),
                                  )
                                ),
                              ]
                          ),
                        Container(
                          width: appComponentsWidth,
                          margin: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Rota da carona',
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
                                  content: const Text('')
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
                        SizedBox(
                          width: appComponentsWidth,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var passengerIndex = 0; passengerIndex < ride['passengers'].length; passengerIndex++)
                                  Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 20, right: 10),
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
                                            width: 35.0.w,
                                            child: Container(
                                              width: 35.0.w,
                                              height: 35.0.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                image: ride['passengers'][passengerIndex]['photo'] != null
                                                  ? DecorationImage(
                                                    image: NetworkImage( ride['passengers'][passengerIndex]['photo']),
                                                    fit: BoxFit.cover,
                                                  )
                                                  : null
                                              ),
                                              child: ride['passengers'][passengerIndex]['photo'] == null
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
                                              ride['passengers'][passengerIndex]['name'],
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: appTextLightColor
                                              ),
                                            ),
                                          ),
                                        ]
                                      )
                                    )
                                  ),

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
                          ),
                        ),
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