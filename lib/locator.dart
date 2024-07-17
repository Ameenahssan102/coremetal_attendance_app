import 'package:face_app/Values/values.dart';
import 'package:face_app/providers/auth_provider.dart';
import 'package:face_app/providers/employee_provider.dart';
import 'package:face_app/utils/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio/dio_client.dart';
import 'dio/logging_interceptor.dart';
import 'dio/repo.dart';

final loc = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  loc.registerLazySingleton(() => sharedPreferences);
  loc.registerLazySingleton(() => Dio());
  loc.registerLazySingleton(() => LoggingInterceptor());
  loc.registerLazySingleton(() => NavigationService());

  loc.registerLazySingleton(() => DioClient(StringConst.BASE_URL, loc(),
      loggingInterceptor: loc(),
      sharedPreferences: loc(),
      navigationService: loc()));

  // Repository
  loc.registerLazySingleton(
      () => Repo(sharedPreferences: loc(), dioClient: loc()));

  loc.registerFactory(() => LoginProvider(
      repo: loc(), ns: loc(), sharedPreferences: loc(), dioClient: loc()));
  loc.registerFactory(
      () => EmployeeProvider(repo: loc(), ns: loc(), sharedPreferences: loc()));

  // loc.registerFactory(() => UserProvider(repo: loc(), ns: loc(),sharedPreferences:loc(),dioClient:loc()));
}
