import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/form_error.dart';
import 'package:levaeu_app/components/gradient_button.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/errors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);
  static String routeName = "/auth/reset-password";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  Map user = {
    'email': '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(
          margin: const EdgeInsets.only(left: 20),
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
        child: Container (
          padding: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              alignment: FractionalOffset.bottomCenter,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 150.w,
                    child: Image.asset('assets/logos/logo-2x.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.h),
                    width: appComponentsWidth,
                    child: Text(
                      'Qual o e-mail associado à sua conta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    width: appComponentsWidth,
                    child: Text(
                      'Vamos te enviar um link para você redefinir sua senha.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal
                      )
                    ),
                  ),
                  SizedBox(height: 50.h),
                  SizedBox(
                    width: appComponentsWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: buildEmailFormField(),
                          ),
                        ]
                      )
                    ),
                  ),
                  SizedBox(height: 20.h),
                  FormError(errors: errors),
                  SizedBox(height: 20.h),
                  GradientButton(
                    onPressed: () {
                      var isValid = _formKey.currentState?.validate();
                    },
                    child: const Text('Enviar'),
                    borderRadius: BorderRadius.circular(50),
                    height: appButtonHeight,
                    gradient: appGradient,
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Retornar para o Login'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  TextFormField buildEmailFormField() {
    return TextFormField(
      onSaved: (value) {
        setState(() {
          user['email'] = value;
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
        icon: const CustomIcon(
          icon: FontAwesomeIcons.userCircle,
          color: appInputTextColor
        )
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }
}