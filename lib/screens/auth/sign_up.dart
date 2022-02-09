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

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static String routeName = "/auth/sign-up";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  var photo = null;
  var userTypePreference = -1;

  Map user = {
    'imageType': '',
    'name': '',
    'collegeEnrollment': '',
    'gender': null,
    'email': '',
    'password': '',
    // 'about': '',
    'userTypePreference': ''
  };

  List<DropdownMenuItem<String>> genders = [
    const DropdownMenuItem(child: Text("Masculino"), value: "male"),
    const DropdownMenuItem(child: Text("Feminino"), value: "female"),
    const DropdownMenuItem(child: Text("Não informar"), value: "other"),
  ];

  bool showPassword = false;
  bool loading = false;
  final List<String> errors = [];
  final List<String> userTypePreferences = [
    'passenger',
    'driver'
  ];

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

  void handlePickedImage (XFile image) async {
    String? filetype = lookupMimeType(image.path);

    if (!isImage(filetype!)) {
      return toast(
        message: 'Selecione uma imagem, por favor',
        type: 'warning'
      );
    } else {
      setState(() {
        photo = image;
        user['imageType'] = filetype;
      });

      Navigator.of(context).pop();
    }
  }

  void signUp() async {
    try {
      if (userTypePreference == -1) {
        setState(() {
          userTypePreference = 1;
        });
      }
      setState(() {
        loading = true;
        user['userTypePreference'] = userTypePreferences[userTypePreference-1];
      });
      var response = await AuthService().signUp(data: user, context: context);

      if (response != null) {
        if (response['putUrl'] != null) {
          await GeneralService()
            .uploadToSignedUrl(
              file: photo,
              signedUrl: response['putUrl'],
              imageType: user['imageType']
            );
        }
        toast(
          message: 'A sua conta foi criada com sucesso.\nVocê só precisa confirmar o seu email.',
          type: 'success',
        );
        setState(() {
          loading = false;
        });
        Navigator.pushNamed(context, ConfirmAccount.routeName);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Criar conta',
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
                  ProfileImagePicker(
                    image: photo,
                    callback: handlePickedImage,
                  ),
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
                            margin: const EdgeInsets.only(top: 10.0),
                            child: buildGenderFormField(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: buildPasswordFormField(),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                          //   child: buildAboutFormField(),
                          // ),
                        ]
                      )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Preferência de uso",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: appTextColor
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListTile(
                            horizontalTitleGap: 0,
                            title: const Text("Passageiro"),
                            leading: Radio(
                              value: 1,
                              groupValue: userTypePreference,
                              activeColor: appPrimaryColor,
                              onChanged: (int? value) {
                                setState(() {
                                  userTypePreference = value ?? -1;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            horizontalTitleGap: 0,
                            title: const Text("Motorista"),
                            leading: Radio(
                              value: 2,
                              groupValue: userTypePreference,
                              activeColor: appPrimaryColor,
                              onChanged: (int? value) {
                                setState(() {
                                  userTypePreference = value ?? -1;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FormError(errors: errors),
                  SizedBox(height: 20.h),
                  GradientButton(
                    onPressed: loading 
                    ? null
                    : () {
                      var isValid = _formKey.currentState?.validate();
                      if(isValid == true) {
                        _formKey.currentState?.save();
                        KeyboardUtil.hideKeyboard(context);
                        signUp();
                      }
                    },
                    child: loading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                    : const Text('Finalizar cadastro'),
                    borderRadius: BorderRadius.circular(50),
                    height: appButtonHeight,
                    gradient: appGradient,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignIn.routeName);
                      },
                      child: const Text('Já tem uma conta? Faça login!'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ConfirmAccount.routeName);
                      },
                      child: const Text('Já possui um código de confirmação? Clique aqui!'),
                    ),
                  ),
                ],
              ),
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
          user['name'] = value;
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
          user['collegeEnrollment'] = value;
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

  DropdownButtonFormField buildGenderFormField() {
    return DropdownButtonFormField(
      items: genders,
      dropdownColor: Colors.white,
      value: user['gender'],
      onSaved: (value) {
        setState(() {
          user['gender'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: genderNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: genderNullError);
          return "";
        }
      },
      decoration: AppTheme.textFieldStyle(
        labelTextStr: 'Gênero',
        // icon: transparentIcon,
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
        color: appTextColor
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
          user['about'] = value;
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