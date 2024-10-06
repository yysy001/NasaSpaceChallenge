import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:nasachallenge/weatherapi/constants.dart';
import 'package:nasachallenge/weatherapi/weathermodel.dart';


class WeatherApi {
  final String baseURL = "http://api.weatherapi.com/v1/current.json";

  Future<ApiResponse> getCurrentWeather(String location) async {
    String apiUrl = "$baseURL?key=$apikey&q=$location";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(response.body);
        return ApiResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load weather");
      }
    } catch (e) {
      throw Exception("Failed to load weather: $e");
    }
  }
}
