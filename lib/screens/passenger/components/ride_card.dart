import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:levaeu_app/theme.dart';

class RideCard extends StatelessWidget {
  const RideCard({
    Key? key,
    required this.ride,
  }) : super(key: key);

  final Map ride;

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
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50.0.w,
                  height: 50.0.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: appBorderColors, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    image: ride['user']['photo'] != null
                      ? DecorationImage(
                        image: NetworkImage( ride['user']['photo']),
                        fit: BoxFit.cover,
                      )
                      : null
                  ),
                  child:  ride['user']['photo'] == null
                    ? const Icon(
                      Icons.person,
                      color: appTextLightColor,
                    )
                    : null,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: const VerticalDivider(
                    thickness: 1,
                    color: appDividerColor,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    ride['startsAt'],
                    style: TextStyle(
                      color: appTextLightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 14.sp,
                  color: appTextLightColor,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    ride['endsAt'],
                    style: TextStyle(
                      color: appTextLightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}