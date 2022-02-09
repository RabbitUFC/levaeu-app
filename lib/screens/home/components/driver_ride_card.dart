import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:levaeu_app/screens/rides/ride_driver_screen.dart';
import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/helpers.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DriverRideCard extends StatelessWidget {
  const DriverRideCard({
    Key? key,
    required this.rideID,
    required this.startLocation,
    required this.endLocation,
    required this.date,
    required this.numberOfPassengers,
    required this.totalVacancies,
    required this.numOfRequests,
  }) : super(key: key);

  final String rideID;
  final String startLocation;
  final String endLocation;
  final String date;
  final int numberOfPassengers;
  final int totalVacancies;
  final int numOfRequests;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: RideDriverScreen(rideID: rideID),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 45.0.w,
                      height: 45.0.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: appSecondaryColor, width: 2),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: const Icon(
                        Icons.place_outlined,
                        color: appSecondaryColor,
                      )
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                child: const VerticalDivider(
                  thickness: 1,
                  color: appDividerColor,
                )
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormat.format(
                            DateTime
                              .parse(date)
                              .subtract(const Duration(hours: 3))
                          ),
                          style: TextStyle(
                            color: appTextLightColor,
                            fontSize: 12.sp
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                startLocation,
                                style: TextStyle(
                                  color: appTextLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.arrow_right_alt,
                                  size: 20.sp,
                                  color: appTextLightColor,
                                ),
                              ),
                              Text(
                                endLocation,
                                style: TextStyle(
                                  color: appTextLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: appTextLightColor,
                                  fontSize: 12.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: "$numberOfPassengers",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green
                                    ),
                                  ),
                                  TextSpan(
                                    text: "/$totalVacancies",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            const Icon(
                              Icons.person_pin_circle,
                              color: Colors.green
                            ),
                          ],
                        ),
                        if (numOfRequests > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${numOfRequests < 10 ? '0$numOfRequests' : numOfRequests } solicitaç${numOfRequests > 1 ? 'ões' : 'ão'} pendente${numOfRequests > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appTextLightColor,
                                fontSize: 12.sp,
                              )
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}