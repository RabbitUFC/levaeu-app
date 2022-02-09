import 'package:dio/dio.dart';
import 'package:levaeu_app/services/utils.dart';

class RidesRequestsService {
  final String _baseUrl = '$apiBaseUrl/rides-requests';

  create({required Map data, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.post(_baseUrl, data: data);
      return response.data;
    } on DioError catch (err) {
      handleError(err, err.response?.statusCode, context);
    }
  }

  update({required String rideID, required Map data, required context}) async {
    var dio = Dio();
    try {
      final response = await dio.put('$_baseUrl/$rideID', data: data);
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