import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_error_handler.dart';
import 'api_response.dart';
import 'dio_client.dart';

class Repo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  Repo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> postData(String url, {data, isMultipart}) async {
    try {
      if (isMultipart == null) {
        dioClient.dio.options.contentType = "application/json";
      } else {
        dioClient.dio.options.contentType = "multipart/form-data";
      }
      if (kDebugMode) {
        print(dioClient.dio.options.contentType);
      }
      final response = await dioClient.post(
        url,
        data: data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (kDebugMode) {
        print("Repo Error");
      }
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getData(String url, {data}) async {
    try {
      dioClient.dio.options.contentType = "application/json";
      final response = await dioClient.get(url, queryParameters: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> patchData(String url, {queryParameters, data}) async {
    try {
      final response = await dioClient.patch(url,
          queryParameters: queryParameters, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
