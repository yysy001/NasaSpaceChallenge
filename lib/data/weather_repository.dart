import 'package:nasachallenge/data/weather_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class WeatherRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<Weather>> getAllStudents() {
    return _client.from('weatherdata').stream(primaryKey: ['id']).map((event) {
      return event.map((e) {
        return Weather.fromJson(e);
      }).toList();
    });
  }
}
