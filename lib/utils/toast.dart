import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void toast({message, type, position, context}) {
  showToast(
    message,
    context: context,
    animation: StyledToastAnimation.slideFromTopFade,
    reverseAnimation: StyledToastAnimation.fade,
    position: position ?? StyledToastPosition.top,
    animDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 7),
    curve: Curves.fastOutSlowIn,
    reverseCurve: Curves.linear,
    backgroundColor: toastColorsByType[type],
    isHideKeyboard: true,
    textStyle: TextStyle(
      fontSize: 14.sp,
      color: Colors.white
    ),
  );
}

Map toastColorsByType = {
  'success': Colors.green[700],
  'error': Colors.red[700],
  'warning': Colors.amber[700]
};