import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nasachallenge/data/weather_model.dart';
import 'package:nasachallenge/data/weather_repository.dart';
import 'package:nasachallenge/main.dart';
import 'package:nasachallenge/uilts/uilts.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoieWVyc29uMDAwMSIsImEiOiJjbTFyYm1hYW0wOXNxMmtvdmJ4MTV0OHNiIn0.gb9tiE445yQhLTWJWo_cGA';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? myPosition;
  String currentStyle = 'mapbox/streets-v11'; // Estilo de mapa inicial
  List<Marker> markers = []; // Arreglo para almacenar los marcadores
  List<LatLng> points = []; // Lista para almacenar puntos seleccionados
  int? movingMarkerIndex; // Índice del marcador que se está moviendo

  WeatherRepository _repository = WeatherRepository(); // Repositorio de datos
  Weather? initialWeather; // Para almacenar el primer Weather

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getInitialWeather() async {
    _repository.getAllStudents().listen((weatherList) {
      if (weatherList.isNotEmpty) {
        setState(() {
          initialWeather = weatherList.first; // Guardar el primer Weather
          myPosition = LatLng(initialWeather!.lat,
              initialWeather!.log); // Actualizar la posición del dron

          // Verificar si ya hay un marcador del dron
          if (markers.isEmpty || markers[0].point != myPosition) {
            addMarker(myPosition!,
                'drone'); // Agregar el marcador inicial con la nueva posición
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getInitialWeather();
    //addMarker(myPosition, 'drone'); // Agregar el marcador inicial
  }

  void changeMapStyle(String style) {
    setState(() {
      currentStyle = style; // Cambiar estilo del mapa
    });
  }

  void addMarker(LatLng position, String type) {
    setState(() {
      markers.add(
        Marker(
          point: position,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              startMovingMarker(markers.length - 1);
            },
            child: type == 'drone'
                ? Image.asset(
                    'assets/images/drone.png', // Imagen del dron
                    width: 40,
                    height: 40,
                  )
                : type == 'route'
                    ? const Icon(
                        Icons
                            .circle, // Ícono para la ruta (puedes cambiar el ícono si lo deseas)
                        size: 40,
                        color: Colors.blue, // Color del ícono de ruta
                      )
                    : const Icon(
                        Icons.location_on, // Ícono para las ubicaciones
                        size: 40,
                        color: Colors.red,
                      ),
          ),
        ),
      );
      points.add(position); // Añadir el punto a la lista
    });
  }

  void addNewMarker() {
    if (myPosition != null) {
      LatLng newMarkerPosition = LatLng(
        myPosition!.latitude + (0.0001 * markers.length),
        myPosition!.longitude + (0.0001 * markers.length),
      );
      addMarker(newMarkerPosition, 'location'); // Agregar nuevo marcador
    }
  }

  void showRoute() {
    calculateRoute(points);

    calculateArea(points);

    // Imprimir los puntos
    print("Puntos:");
    for (var point in points) {
      print("Point: ${point.latitude}, ${point.longitude}");
    }
  }

  void addNewMarker2(double latitude, double longitude) {
    LatLng newMarkerPosition = LatLng(latitude, longitude);
    addMarker(newMarkerPosition, 'route'); // Agregar nuevo marcador de ruta
  }

  void clearMarkers() {
    setState(() {
      markers = [markers.first]; // Mantener solo el marcador del dron
      points.clear();
      points.add(myPosition!); // Mantener la posición inicial
    });
  }

  void startMovingMarker(int index) {
    setState(() {
      movingMarkerIndex = index; // Iniciar movimiento de marcador
    });
  }

  void moveMarker(LatLng newPosition) {
    if (movingMarkerIndex != null) {
      setState(() {
        markers[movingMarkerIndex!] = Marker(
          point: newPosition,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              startMovingMarker(movingMarkerIndex!);
            },
            child: markers[movingMarkerIndex!].child,
          ),
        );
        points[movingMarkerIndex!] = newPosition;
      });
    }
  }

  void stopMovingMarker() {
    setState(() {
      movingMarkerIndex = null; // Detener el movimiento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa interactivo
          FlutterMap(
            options: MapOptions(
              initialCenter: myPosition!,
              initialZoom: 18,
              minZoom: 5,
              maxZoom: 25,
              onTap: (tapPosition, point) {
                if (movingMarkerIndex != null) {
                  moveMarker(point);
                  stopMovingMarker();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': currentStyle,
                },
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          // Botones para agregar y limpiar marcadores
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: showRoute,
                  tooltip: 'Crerar Ruta',
                  child: const Icon(Icons.route),
                ),
                FloatingActionButton(
                  onPressed: () {
                    DashboardScreen.dashboardKey.currentState
                        ?.updateValues('100m²', '150 min', '20 km/h', '800%');
                  },
                  tooltip: 'Actualizar Valores',
                  child: const Icon(Icons.start_outlined),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: addNewMarker,
                  tooltip: 'Agregar Marcador',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8), // Espacio entre botones
                FloatingActionButton(
                  onPressed: clearMarkers,
                  tooltip: 'Limpiar Marcadores',
                  child: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          // Mostrar datos del clima en la parte superior
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: StreamBuilder<List<Weather>>(
              stream: _repository.getAllStudents(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Weather wt = snapshot.data!.first; // Muestra el primer dato

                  // Actualiza la posición si ha cambiado
                  LatLng newPosition = LatLng(wt.lat, wt.log);
                  if (myPosition == null ||
                      (myPosition!.latitude != newPosition.latitude ||
                          myPosition!.longitude != newPosition.longitude)) {
                    myPosition = newPosition; // Actualiza la posición actual
                    addNewMarker2(wt.lat, wt.log);
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Centrar verticalmente
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Espacio entre elementos
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.airplanemode_active,
                                  color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                '${wt.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.map, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Lat: ${wt.lat}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Log: ${wt.log}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.water, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Humedad: ${wt.humedad} %',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.thermostat, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Temperatura: ${wt.presion} °C', // Asegúrate de que la temperatura esté en tu modelo
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.check, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Altitud: ${wt.altitud} m',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),

          // Lista de puntos
          Positioned(
            left: 16,
            bottom: -20,
            child: Container(
              width: 280,
              height: 400,
              child: ListView.builder(
                itemCount: points.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(index == 0 ? 'Dron' : 'Punto ${index}'),
                      subtitle: Text(
                          'Lat: ${points[index].latitude}, Lon: ${points[index].longitude}'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
