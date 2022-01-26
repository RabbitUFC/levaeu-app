import 'package:dio/dio.dart';
import 'package:levaeu_app/screens/auth/confirm_account.dart';
import 'package:levaeu_app/services/utils.dart';

class AuthService {
  final String _baseUrl = '$apiBaseUrl/auth';

  signUp({required Map data, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.post('$_baseUrl/sign-up', data: data);
      return response.data;
    } on DioError catch (err) {
      handleError(err, err.response?.statusCode, context);
    }
  }

  signIn({required Map data, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.post('$_baseUrl/sign-in', data: data);
      return response.data;
    } on DioError catch (err) {
      handleError(err, err.response?.statusCode, context);
    }
  }

  confirmAccount({required Map data, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.post('$_baseUrl/confirm-account', data: data);
      return response.data;
    } on DioError catch (err) {
      handleError(err, err.response?.statusCode, context);
    }
  }
}