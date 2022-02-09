import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/form_error.dart';
import 'package:levaeu_app/components/gradient_button.dart';
import 'package:levaeu_app/components/logo.dart';
import 'package:levaeu_app/hive/user.dart';
import 'package:levaeu_app/screens/auth/recover_password.dart';
import 'package:levaeu_app/screens/home/home_pageview.dart';

import 'package:levaeu_app/services/auth.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/errors.dart';
import 'package:levaeu_app/utils/hive.dart';
import 'package:levaeu_app/utils/keyboard.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static String routeName = "/auth/sign-in";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  var box = Hive.box(userBox);

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

  void signIn() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await AuthService().signIn(data: user, context: context);

      if (response != null && response['success'] == true) {
        setState(() {
          loading = false;
        });

        User _user = User(
          id: response['data']['_id'],
          jwtToken: response['data']['token'],
          name: response['data']['name'],
          photo: response['data']['photo'],
          selectedType: response['data']['userTypePreference'],
          isSignedIn: true,
        );
        box.put('user', _user);

        Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePageView.routeName, (Route<dynamic> route) => false);
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (err) {
      setState(() {
        loading = false;
      });
    }
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(
            color: appPrimaryColor,
            strokeWidth: 2,
          ),
        );
      },
      context: context,
    );
  }

  verifyIfIsAuthenticated () async {
    await Future.delayed(const Duration(seconds: 1));
    var user = box.get('user');
    Navigator.of(context, rootNavigator: true).pop();
    if(user != null && user.jwtToken != '' && user.isSignedIn) {
      await Future.delayed(const Duration(milliseconds: 50));
      Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePageView.routeName, (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _showDialog();
    verifyIfIsAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
                    onPressed: loading
                    ? null
                    : () {
                      var isValid = _formKey.currentState?.validate();
                      if(isValid == true) {
                        _formKey.currentState?.save();
                        KeyboardUtil.hideKeyboard(context);
                        signIn();
                      }
                    },
                    child: loading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                    : const Text('Entrar'),
                    borderRadius: BorderRadius.circular(50),
                    height: appButtonHeight,
                    gradient: appGradient,
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RecoverPassword.routeName);
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
      keyboardType: TextInputType.emailAddress,
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