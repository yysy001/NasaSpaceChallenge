// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['log'] as num).toDouble(),
      (json['lat'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'log': instance.log,
      'lat': instance.lat,
    };
