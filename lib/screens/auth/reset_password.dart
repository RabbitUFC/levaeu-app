import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:levaeu_app/components/custom_suffix_icon.dart';
import 'package:levaeu_app/components/form_error.dart';
import 'package:levaeu_app/components/gradient_button.dart';
import 'package:levaeu_app/screens/auth/sign_in.dart';
import 'package:levaeu_app/services/auth.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/errors.dart';
import 'package:levaeu_app/utils/keyboard.dart';
import 'package:levaeu_app/utils/toast.dart';
import 'package:pinput/pin_put/pin_put.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);
  static String routeName = "/auth/reset-password";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinPutController = TextEditingController();
  
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: appPrimaryColor, width: 4.0),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Map resetPasswordData = {
    'email': '',
    'code': '',
    'password': '',
  };

  bool loading = false;
  bool showPassword = false;
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

  void resetPassword() async {
    try {
      if (_pinPutController.text == '' || _pinPutController.text.length != 6) {
        toast(
          message: 'Informe um código de confirmação válido.',
          type: 'warning'
        );
      } else {
        setState(() {
          loading = true;
          resetPasswordData['code'] = _pinPutController.text;
        });
        var response = await AuthService().resetPassword(data: resetPasswordData, context: context);

        if (response != null && response['success'] == true) {
          toast(
            message: 'A sua senha foi alterada com sucesso.',
            type: 'success',
          );
          // @ToDo save token in Hive
          Navigator.pushNamed(context, SignIn.routeName);
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
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
                  SizedBox(
                    width: 150.w,
                    child: Image.asset('assets/logos/logo-2x.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.h),
                    width: appComponentsWidth,
                    child: Text(
                      'Resetar senha',
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
                      'Informe o seu email, o código recebido e a sua nova senha',
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
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: buildPasswordFormField(),
                          ),
                        ]
                      )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: appComponentsWidth,
                      child: PinPut(
                        fieldsCount: 6,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: appPrimaryColor,
                            width: 2.0
                          ),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          border: Border.all(
                            color: appPrimaryColor.withOpacity(.9),
                            width: 2.0
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.h),
                    child: FormError(errors: errors)
                  ),
                  GradientButton(
                    onPressed: loading
                    ? null
                    : () {
                      var isValid = _formKey.currentState?.validate();
                      if(isValid == true) {
                        _formKey.currentState?.save();
                        KeyboardUtil.hideKeyboard(context);
                        resetPassword();
                      }
                    },
                    child: loading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                    : const Text('Salvar'),
                    borderRadius: BorderRadius.circular(50),
                    height: appButtonHeight,
                    gradient: appGradient,
                  ),
                  SizedBox(height: 20.h),
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
          resetPasswordData['email'] = value;
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
          resetPasswordData['password'] = value;
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
        labelTextStr: 'Nova senha',
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