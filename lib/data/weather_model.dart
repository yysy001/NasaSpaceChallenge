import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class Weather {
  final int id;
  final String name;
  final double log;
  final double lat;

  Weather(this.id, this.name, this.log, this.lat);

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
