// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:levaeu_app/utils/toast.dart';

String apiBaseUrl = 'https://glhiilhnuk.execute-api.us-east-1.amazonaws.com/dev';

void handleError(DioError err, int? statusCode, context) {
  var message = '';

  if (err.response != null) {
    message = err.response?.data['message'] ?? messageByStatusCode[statusCode];
  } else {
    // Something happened in setting up or sending the request that triggered an Error
    print(err.message);
    message = err.message;
  }


  toast(
    message: message != '' ? message : 'Algo de errado aconteceu. Tente novamente.',
    type: 'error',
    context: context
  );
}

Map messageByStatusCode = {
  200: 'Salvo com sucesso.',
  400: 'Campos inválidos ou com erros foram enviados. Verifique e tente novamente.',
  401: 'Você não possui autorização para acessar este recurso.',
  404: 'Não encontrado. Tente Novamente.',
  500: 'Erro interno no servidor.'
};
