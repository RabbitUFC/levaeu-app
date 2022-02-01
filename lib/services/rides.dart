import 'package:dio/dio.dart';
import 'package:levaeu_app/services/utils.dart';

class RidesService {
  final String _baseUrl = '$apiBaseUrl/rides';

  create({required Map data, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.post(_baseUrl, data: data);
      return response.data;
    } on DioError catch (err) {
      handleError(err, err.response?.statusCode, context);
    }
  }

  list({query, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.get(_baseUrl, queryParameters: query ?? {} );
      return response.data;
    } on DioError catch (err) {
      handleError(err, err.response?.statusCode, context);
    }
  }
}