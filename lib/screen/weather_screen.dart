import 'package:flutter/material.dart';
import 'package:nasachallenge/data/weather_model.dart';
import 'package:nasachallenge/data/weather_repository.dart';

class WeatherDataState extends StatefulWidget {
  const WeatherDataState({super.key});

  @override
  State<WeatherDataState> createState() => _WeatherDataState();
}

class _WeatherDataState extends State<WeatherDataState> {
  WeatherRepository _repository = WeatherRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Weather>>(
        stream: _repository.getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Weather> weathers = snapshot.data ?? [];
            return ListView.builder(
              itemCount: weathers.length,
              itemBuilder: (context, index) {
                Weather wt = weathers[index];
                return Column(
                  children: [
                    Text('Name: ${wt.name}'),
                    Text('Log: ${wt.log}'),
                    Text('Lat: ${wt.lat}'),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
