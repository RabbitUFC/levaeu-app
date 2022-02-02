import 'package:dio/dio.dart';
import 'package:levaeu_app/services/utils.dart';

class DistrictsService {
  final String _baseUrl = '$apiBaseUrl/districts';

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