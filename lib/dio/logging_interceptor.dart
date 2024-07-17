import 'package:dio/dio.dart';

import '../utils/print_util.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    PrintUtil.printImportant(
        "--> ${options.method} ${options.baseUrl}${options.path}");
    /* PrintUtil.printImportant("Headers ->  ${options.headers.toString()}");
    PrintUtil.printImportant("Data -> ${options.data}");
    PrintUtil.printImportant("<-- END HTTP");*/

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    PrintUtil.printImportant(
        "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");

    String responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        PrintUtil.printImportant(
            responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      PrintUtil.printImportant(response.data);
    }
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    PrintUtil.printImportant(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    if (err.response?.statusCode == 401) {
      //var context = NavigationService.navigatorKey.currentState!.context;
      //Navigator.pushAndRemoveUntil(context, SlideRightRoute(page: const LogoutScreen()), (route) => false);
    } else {
      return super.onError(err, handler);
    }
  }
}
