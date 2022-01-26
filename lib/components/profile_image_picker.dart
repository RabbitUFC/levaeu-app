import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levaeu_app/theme.dart';


class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({
    Key? key,
    required this.image,
    required this.callback
  }) : super(key: key);

  final dynamic image;
  final dynamic callback;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: imageProfile(widget.image),
    );
  }

  Widget imageProfile(image) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet())
        );
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: 100.w,
            child: image == null ? ClipOval(
              child: Container(
                color: appInputBackground,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          size: 40.w,
                          color: appTextLightColor,
                        ),
                      ),
                      const Text(
                        'Foto de perfil',
                        style: TextStyle(
                          color: appTextLightColor,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ): null,
            backgroundImage: image != null
              ? image.runtimeType == String
                ? Image.network(image).image
                : FileImage(File(image.path))
              : null,
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: const FaIcon(FontAwesomeIcons.upload, size: 15,)
            ),
          )
        ],
      )
    );
  }

  Widget bottomSheet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      width: ScreenUtil().screenWidth,
      height: 100,
      child: Column(
        children: [
          Text(
            'Escolha uma foto de perfil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: FaIcon(
                        FontAwesomeIcons.camera,
                        color: appBlackIconsColor
                      ),
                    ),
                    Text(
                      'Câmera',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: appTextColor
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: FaIcon(
                        FontAwesomeIcons.image,
                        color: appBlackIconsColor
                      ),
                    ),
                    Text(
                      'Galeria',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: appTextColor
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto (ImageSource source) async {
    var pickedFile = await _picker.pickImage(
      source: source
    );

    if (pickedFile != null) {
      widget.callback(pickedFile);
    }
  }
}