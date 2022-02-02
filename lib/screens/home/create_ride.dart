import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levaeu_app/utils/keyboard.dart';
import 'package:mime/mime.dart';

import 'package:levaeu_app/screens/auth/confirm_account.dart';
import 'package:levaeu_app/screens/auth/sign_in.dart';

import 'package:levaeu_app/components/profile_image_picker.dart';
import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/form_error.dart';
import 'package:levaeu_app/components/gradient_button.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/errors.dart';
import 'package:levaeu_app/utils/helpers.dart';
import 'package:levaeu_app/utils/toast.dart';

import 'package:levaeu_app/services/auth.dart';
import 'package:levaeu_app/services/general.dart';

class CreateRide extends StatefulWidget {
  const CreateRide({Key? key}) : super(key: key);
  static String routeName = "/rides/create";

  @override
  State<CreateRide> createState() => _CreateRideState();
}

class _CreateRideState extends State<CreateRide> {
  final _formKey = GlobalKey<FormState>();

  Map ride = {
  };

  bool loading = false;
  final List<String> errors = [];

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void create() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Cadastrar carona',
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
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: (ScreenUtil().screenWidth - appComponentsWidth)/2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: appComponentsWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: buildNameFormField(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: buildCollegeEnrollmentFormField(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: buildEmailFormField(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: buildAboutFormField(),
                        ),
                      ]
                    )
                  ),
                ),
                SizedBox(height: 10.h),
                FormError(errors: errors),
                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(appSecondaryColor),
                  ),
                  onPressed: loading 
                  ? null
                  : () {
                    var isValid = _formKey.currentState?.validate();
                    if(isValid == true) {
                      _formKey.currentState?.save();
                      KeyboardUtil.hideKeyboard(context);
                      create();
                    }
                  },
                  child: loading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                  : const Text('Criar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (value) {
        setState(() {
          ride['name'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: nameNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: nameNullError);
          return "";
        }
      },
      decoration: AppTheme.textFieldStyle(
        labelTextStr: 'Nome completo',
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }

  TextFormField buildCollegeEnrollmentFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (value) {
        setState(() {
          ride['collegeEnrollment'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: collegeEnrollmentNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: collegeEnrollmentNullError);
          return "";
        }
      },
      decoration: AppTheme.textFieldStyle(
        labelTextStr: 'Matrícula UFC',
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        setState(() {
          ride['email'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: emailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: invalidEmailError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: emailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: invalidEmailError);
          return "";
        }
      },
      decoration: AppTheme.textFieldStyle(
        labelTextStr: 'Email',
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }

  TextFormField buildAboutFormField() {
    OutlineInputBorder normalBorder = OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: appInputTextColor),
      borderRadius: BorderRadius.circular(11),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: appPrimaryColor),
      borderRadius: BorderRadius.circular(11),
    );

    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      onSaved: (value) {
        setState(() {
          ride['about'] = value;
        });
      },
      decoration: InputDecoration(
        fillColor: appInputBackground,
        constraints: BoxConstraints(
          minHeight: 64.h,
          minWidth: 300.w,
        ),
        label: Text(
          'Sobre mim',
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w500,
            color: appInputTextColor
          ),
        ),
        
        focusedBorder: focusedBorder,
        enabledBorder: normalBorder,
        // errorBorder: errorBorder,
        // focusedErrorBorder: errorBorder,
        errorStyle: const TextStyle(height: 0)
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  } 
}