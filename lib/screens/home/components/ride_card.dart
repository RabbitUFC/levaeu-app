import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/helpers.dart';

class RideCard extends StatelessWidget {
  const RideCard({
    Key? key,
    required this.driver,
    required this.startLocation,
    required this.endLocation,
    required this.date,
    required this.numberOfPassengers,
    required this.totalVacancies,
    required this.pickupPoints,
  }) : super(key: key);

  final Map driver;
  final String startLocation;
  final String endLocation;
  final String date;
  final int numberOfPassengers;
  final int totalVacancies;
  final List<dynamic> pickupPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      border: Border.all(color: appBorderColors, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      image: driver['photo'] != null
                        ? DecorationImage(
                          image: NetworkImage( driver['photo']),
                          fit: BoxFit.cover,
                        )
                        : null
                    ),
                    child:  driver['photo'] == null
                      ? const Icon(
                        Icons.person,
                        color: appTextLightColor,
                      )
                      : null,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      driver['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appTextLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp
                      ),
                    ),
                  )
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
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: appTextLightColor,
                            fontSize: 12.sp,
                          ),
                          children: [
                            const TextSpan(
                              text: "Pontos de encontro: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...[
                              for (var index = 0; index < pickupPoints.length; index++)
                                TextSpan(
                                  text: "${pickupPoints[index]['name']}${index < pickupPoints.length - 1 ? ', ' : ''}",
                                ),
                            ]
                          ]
                        ),
                      )
                    ],
                  ),
                  Column(
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}