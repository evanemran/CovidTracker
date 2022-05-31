import 'package:covid_tracker/Models/GlobalData.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: "https://disease.sh/v3/covid-19/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('all')
  Future<GlobalData> getGlobalData();
}