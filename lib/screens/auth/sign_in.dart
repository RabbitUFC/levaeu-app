import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/form_error.dart';
import 'package:levaeu_app/components/gradient_button.dart';
import 'package:levaeu_app/components/logo.dart';
import 'package:levaeu_app/screens/auth/reset_password.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/errors.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static String routeName = "/auth/sign-in";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  Map user = {
    'email': '',
    'password': '',
  };

  bool showPassword = false;
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
                  const Logo(),
                  SizedBox(height: 50.h),
                  SizedBox(
                    width: appComponentsWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: buildEmailFormField(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: buildPasswordFormField(),
                          ),
                        ]
                      )
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FormError(errors: errors),
                  SizedBox(height: 30.h),
                  GradientButton(
                    onPressed: () {
                      var isValid = _formKey.currentState?.validate();
                    },
                    child: const Text('Entrar'),
                    borderRadius: BorderRadius.circular(50),
                    height: appButtonHeight,
                    gradient: appGradient,
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ResetPassword.routeName);
                    },
                    child: const Text('Esqueceu a sua senha?'),
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: !showPassword,
      onSaved: (value) {
        setState(() {
          user['password'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: passwordNullError);
        }
        if (value.length >= 8) {
          removeError(error: shortPasswordError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: passwordNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: shortPasswordError);
          return "";
        }
      },
      decoration: AppTheme.textFieldStyle(
        labelTextStr: 'Senha',
        icon: CustomIcon(
          icon: showPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
          color: appInputTextColor
        ),
        press: () {
          setState(() {
            showPassword = !showPassword;
          });
        }
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }
}