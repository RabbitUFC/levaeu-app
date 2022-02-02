import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:levaeu_app/components/form_error.dart';
import 'package:levaeu_app/hive/user.dart';
import 'package:levaeu_app/models/district_model.dart';
import 'package:levaeu_app/models/pickup_point_model.dart';
import 'package:levaeu_app/services/districts.dart';
import 'package:levaeu_app/services/pickup_points.dart';
import 'package:levaeu_app/services/rides.dart';

import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/errors.dart';
import 'package:levaeu_app/utils/hive.dart';
import 'package:levaeu_app/utils/keyboard.dart';
import 'package:levaeu_app/utils/toast.dart';

class CreateRide extends StatefulWidget {
  const CreateRide({Key? key}) : super(key: key);
  static String routeName = "/rides/create";

  @override
  State<CreateRide> createState() => _CreateRideState();
}

class _CreateRideState extends State<CreateRide> {
  final _formKey = GlobalKey<FormState>();
  var box = Hive.box(userBox);

  List<dynamic> districts = [];
  Map ride = {
    'driver': '',
    'startLocation': '',
    'endLocation': '',
    'pickupPoints': [],
    'date': '',
    'passengersAmount': 1,
    'active': true,
    'additionalInformation': ''
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
    User user = box.get('user');
    setState(() {
      ride['driver'] = user.id;
      loading = true;
    });

    var response = await RidesService().create(data: ride, context: context);

    if (response != null && response['success']) {
      toast(
        message: 'Carona criada com sucesso!',
        type: 'success',
        context: context
      );
    }

    setState(() {
      loading = false;
    });
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
                          child: locationDropdown(
                            label: 'Ponto inicial',
                            attribute: 'startLocation',
                            error: startLocationNullError
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: locationDropdown(
                            label: 'Ponto final',
                            attribute: 'endLocation',
                            error: endLocationNullError
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: pickupPointsDropdown(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: dateTimeFormField(),
                        ),
                        Container(
                          width: appComponentsWidth,
                          margin: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vagas disponíveis:',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (ride['passengersAmount'] > 1) {
                                        setState(() {
                                          ride['passengersAmount'] = ride['passengersAmount'] - 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: appSecondaryColor, width: 2.0),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: const Icon(
                                          FontAwesomeIcons.minus,
                                          size: 12,
                                        )
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      '${ride['passengersAmount']}',
                                      style: TextStyle(
                                        fontSize: 16.sp
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (ride['passengersAmount'] < 7) {
                                        setState(() {
                                          ride['passengersAmount'] = ride['passengersAmount'] + 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: appSecondaryColor,
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: const Icon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: 12,
                                        )
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ),
                        Container(
                          width: appComponentsWidth,
                          margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text(
                            'Informações adicionais:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: additionalInformationFormField(),
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

  TextFormField additionalInformationFormField() {
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
          ride['additionalInformation'] = value;
        });
      },
      decoration: InputDecoration(
        fillColor: appInputBackground,
        constraints: BoxConstraints(
          minHeight: 64.h,
          minWidth: 300.w,
        ),
        label: Text(
          'Ex: Gosto de dirigir escutando zeca pagodinho =)',
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

  DropdownSearch locationDropdown({required String label, required String attribute, required String error}) {
    return DropdownSearch<DistrictModel>(
      showSearchBox: true,
      isFilteredOnline: true,
      showClearButton: true,
      mode: Mode.DIALOG,
      
      dropdownBuilder: districtsDropdownSelectedItemBuilder,
      popupItemBuilder: districtsDropdownItemsBuilder,
      onFind: (String? filter) async {
        if (filter != null && filter != '') {
          var response = await DistrictsService().list(context: context, query: {"search": filter});
          var models = DistrictModel.fromJsonList(response['data']);

          KeyboardUtil.hideKeyboard(context);
          return models ;
        }

        return [];
      },
      dropdownSearchDecoration: AppTheme.textFieldStyle(
        labelTextStr: label
      ),
      searchFieldProps: TextFieldProps(
        decoration: AppTheme.textFieldStyle(
          labelTextStr: label
        ),
      ),
      emptyBuilder: (BuildContext context, String? text) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          'Nenhum bairro encontrado, tente mudar a sua busca.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0.sp,
          )
        ),
      ),
      onSaved: (value) {
        setState(() {
          ride[attribute] = value?.id;
        });
      },
      onChanged: (value) {
        if (value != null) {
          removeError(error: error);
        }
      },
      validator: (value) {
        if (value == null) {
          addError(error: error);
          return "";
        }
      },
    );
  }

  DropdownSearch pickupPointsDropdown() {
    return DropdownSearch<PickupPointModel>.multiSelection(
      showSearchBox: true,
      isFilteredOnline: true,
      showClearButton: true,
      mode: Mode.DIALOG,
      dropdownBuilder: pickupPointsDropdownSelectedItemBuilder,
      popupItemBuilder: pickupPointsDropdownItemsBuilder,
      onFind: (String? filter) async {
        if (filter != null && filter != '') {
          var response = await PickupPointsService().list(context: context, query: {"search": filter});
          var models = PickupPointModel.fromJsonList(response['data']);

          KeyboardUtil.hideKeyboard(context);
          return models ;
        }

        return [];
      },
      dropdownSearchDecoration: AppTheme.textFieldStyle(
        labelTextStr: 'Pontos de encontro'
      ),
      searchFieldProps: TextFieldProps(
        decoration: AppTheme.textFieldStyle(
          labelTextStr: 'Pontos de encontro'
        ),
      ),
      emptyBuilder: (BuildContext context, String? text) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          'Nenhum ponto encontrado, tente mudar a sua busca.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0.sp,
          )
        ),
      ),
      onSaved: (List<PickupPointModel>? values) {
        if(values != null) {
          setState(() {
            ride['pickupPoints'] = values.map((item) => item.id).toList();
          });
        }
      },
      onChanged: (List<PickupPointModel> values) {
        if (values.isNotEmpty) {
          removeError(error: pickuptPointNullError);
        }
      },
      validator: (List<PickupPointModel>? values) {
        if (values == null || values.isEmpty) {
          addError(error: pickuptPointNullError);
          return "";
        }
      },
    );
  }

  DateTimePicker dateTimeFormField() {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      locale: const Locale('pt', 'BR'),
      use24HourFormat: true,
      dateMask: 'd MMMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.event),
      dateLabelText: 'Data',
      timeLabelText: "Horário",
      selectableDayPredicate: (date) {
        return true;
      },
      onChanged: (val) {
        setState(() {
          ride['date'] = val;
        });
      },
      onSaved: (val) {
        setState(() {
          ride['date'] = val;
        });
      },
    );
  }

  Widget districtsDropdownSelectedItemBuilder(BuildContext context, DistrictModel? item) {
    return ListTile(
      title: Text(
        item?.name ?? 'Selecione um bairro',
        style: TextStyle(
          fontSize: 14.0.sp,
        )
      ),
    );
  }

  Widget districtsDropdownItemsBuilder (BuildContext context, DistrictModel? item, bool value) {
    return ListTile(
      title: Text(
        item?.name ?? '',
        style: TextStyle(
          fontSize: 14.0.sp,
        )
      ),
    );
  }

  Widget pickupPointsDropdownSelectedItemBuilder(BuildContext context, List<PickupPointModel>? itens) {
    var text = 'Selecione os pontos de encontro';

    if (itens != null && itens.isNotEmpty) {
      text = '';
      var itensName = itens.map((item) => item.name).toList();
      text = itensName.join(', ');
    }
    
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 14.0.sp,
        )
      ),
    );
  }

  Widget pickupPointsDropdownItemsBuilder (BuildContext context, PickupPointModel? item, bool value) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.image == null)
        ? ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(item.name),
          )
        : ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: SizedBox(
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadeInImage.memoryNetwork(
                width: 50.0,
                placeholder: kTransparentImage,
                image: item.image ?? '', 
                fit: BoxFit.cover,
              ),
            )
          ),
          title: Text(item.name),
        )
      );
  }

}