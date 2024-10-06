import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class Weather {
  final int id;
  final String name;
  final double log;
  final double lat;
  final double presion;
  final double altitud;
  final double humedad;

  Weather(this.id, this.name, this.log, this.lat,this.presion, this.altitud, this.humedad);

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
