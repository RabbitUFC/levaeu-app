import 'package:dio/dio.dart';
import 'package:levaeu_app/services/utils.dart';

class PickupPointsService {
  final String _baseUrl = '$apiBaseUrl/pickup-points';

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