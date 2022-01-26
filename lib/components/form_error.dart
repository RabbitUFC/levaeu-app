import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:levaeu_app/theme.dart';

class FormError extends StatelessWidget {
  static const List<String> defaultValue = [];

  const FormError({
    Key? key,
    this.errors = defaultValue,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: appComponentsWidth,
      child: Column(
        children: List.generate(errors.length, (index) {
          return Column(children: [
            const SizedBox(height: 10),
            formErrorText(error: errors[index]),
            const SizedBox(height: 10),
          ]);
        }),
      ),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.redAccent,
          size: 16.sp,
        ),
        SizedBox(
          width: 10.w,
        ),
        Flexible(
          child: Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          )
        )
      ],
    );
  }
}