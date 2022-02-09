import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:levaeu_app/components/custom_suffix_icon.dart';

const appPrimaryColor     = Color(0xFF189ED8);
const appPrimaryDarkColor = Color(0xFF158BBD);
const appPrimaryOverlay   = Color.fromRGBO(24, 158, 216, 0.4);

const appSecondaryColor     = Color(0xFF6D36C8);
const appSecondaryDarkColor = Color(0xFF582D9F);
const appSecondaryOverlay   = Color.fromRGBO(109, 54, 200, 0.4);

const appTextColor = Color(0xFF101010);
const appTextLightColor = Color(0xFF5E5E5E);

const appBackgroundColor     = Color(0xFFF8F8F8);
const appBlackOverlay        = Color.fromRGBO(0, 0, 0, 0.3);
const appLighterBlackOverlay = Color.fromRGBO(0, 0, 0, 0.2);

const appInputBackground = Color(0xFFEFF0F6);
const appInputTextColor  = Color(0xFF6E7191);
const appBorderColors    = Color(0xFFE5E5E5);

const appDividerColor = Color(0xFFB4B4B4);
const appBlackIconsColor = Color(0xFF404040);

const appWhiteColor = Color(0xFFF8F8F8);
const appBlackColor = Color(0xFF181818);

const appGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  stops:  [0.0, 1.0],
  colors: [
    appSecondaryColor,
    appPrimaryColor,
  ],
);

var appButtonHeight = 45.0.h;
var appButtonWidth = 280.w;

var appComponentsWidth = 270.w;

ThemeData theme(context) {
  return ThemeData(
    primaryColor: appPrimaryColor,
    scaffoldBackgroundColor: appBackgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size?>(Size(appButtonWidth, appButtonHeight)),
        backgroundColor: MaterialStateProperty.all<Color>(appPrimaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        )),
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0.sp
        )),
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(
          width: 2.0,
          color: appPrimaryColor
        )),
        fixedSize: MaterialStateProperty.all<Size?>(Size(appButtonWidth, appButtonHeight)),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        )),
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0.sp
        ))
      )
    ),
    fontFamily: 'Inter'
  );
}

class AppTheme {
  static InputDecoration textFieldStyle({
    required String labelTextStr,
    String hintTextStr = "",
    CustomIcon? icon,
    GestureTapCallback? press,
  }) {
    // OutlineInputBorder normalBorder = OutlineInputBorder(
    //   borderSide: const BorderSide(width: .5, color: appPrimaryDarkColor),
    //   borderRadius: BorderRadius.circular(11),
    // );

    // OutlineInputBorder errorBorder = OutlineInputBorder(
    //   borderSide: const BorderSide(color: Colors.red, width: 1),
    //   borderRadius: BorderRadius.circular(11),
    // );

    return InputDecoration(
      hintText: hintTextStr,
      suffixIcon: icon != null ? GestureDetector(
        onTap: press,        
        child: icon,
      ) : null,
      fillColor: appInputBackground,
      constraints: BoxConstraints(
        minHeight: 64.h,
        minWidth: 300.w,
      ),
      label: Text(
        labelTextStr,
        style: TextStyle(
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w500,
          color: appInputTextColor
        ),
      ),
      
      // focusedBorder: normalBorder,
      // enabledBorder: normalBorder,
      // errorBorder: errorBorder,
      // focusedErrorBorder: errorBorder,
      errorStyle: const TextStyle(height: 0)
    );
  }
}
