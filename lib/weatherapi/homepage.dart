import 'package:flutter/material.dart';
import 'package:nasachallenge/weatherapi/api.dart';
import 'package:nasachallenge/weatherapi/weathermodel.dart';
import 'package:nasachallenge/witgests/weathercard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ApiResponse? response;
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    // Llama automáticamente al clima de Arequipa al iniciar la app
    _getWeatherData("Arequipa");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //_buildSearchWidget(),
            if (inProgress)
              CircularProgressIndicator()
            else
              _buildWeatherWidget(),
          ],
        ),
      ),
    ));
  }

  Widget _buildSearchWidget() {
    return SearchBar(
      hintText: "search any location",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
      print("Location: ${response?.location?.name}");
      print("Current weather: ${response?.current}");
    } catch (e) {
      print("Error fetching weather: $e");
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
Widget _buildWeatherWidget() {
  if (response == null || response!.location == null) {
    return Text("Search for the location to get weather data");
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CLIMA DE HOY",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.green, // Color verde para hacer énfasis
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.location_on,
              size: 50,
              color: Colors.green, // Color verde para ícono
            ),
            Text(
              response!.location!.name ?? "",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 30), // Espacio entre nombre y país
            Text(
              response!.location!.country ?? "",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20), // Espacio debajo del nombre y país

        // Usamos un Row para crear dos columnas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Columna izquierda
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  child: WeatherCard(
                    icon: Icons.thermostat_outlined,
                    label: "Temperatura",
                    value: "${response!.current!.tempC?.toStringAsFixed(1)} °C",
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: WeatherCard(
                    icon: Icons.water_drop,
                    label: "Humedad",
                    value: "${response!.current!.humidity}%",
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: WeatherCard(
                    icon: Icons.speed,
                    label: "Presión",
                    value: "${response!.current!.pressureMb?.toStringAsFixed(1)} hPa",
                  ),
                ),
              ],
            ),

            // Columna derecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  child: WeatherCard(
                    icon: Icons.air,
                    label: "Viento",
                    value: "${response!.current!.windKph?.toStringAsFixed(1)} km/h (${response!.current!.windDir})",
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: WeatherCard(
                    icon: Icons.cloud,
                    label: "Precipitación",
                    value: "${response!.current!.precipMm?.toStringAsFixed(1)} mm",
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: WeatherCard(
                    icon: Icons.thermostat,
                    label: "Sensación Térmica",
                    value: "${response!.current!.feelslikeC?.toStringAsFixed(1)} °C",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}


}
