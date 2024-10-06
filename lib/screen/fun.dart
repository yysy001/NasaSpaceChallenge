/*
UPDATE weatherdata
SET lat = -16.38993, log = -71.53513
WHERE id = 1;


UPDATE weatherdata
SET lat = -16.389859, log = -71.535439
WHERE id = 1;
3

UPDATE weatherdata
SET lat = -16.389732, log = -71.535089
WHERE id = 1;

UPDATE weatherdata
SET lat = -16.389519, log = -71.535344
WHERE id = 1;



class _MapScreenState extends State<MapScreen> {
  LatLng myPosition = LatLng(-16.388377, -71.52548); // Posición inicial
  String currentStyle = 'mapbox/streets-v11'; // Estilo de mapa inicial
  List<Marker> markers = []; // Arreglo para almacenar los marcadores
  List<LatLng> points = []; // Lista para almacenar puntos seleccionados
  int? movingMarkerIndex; // Índice del marcador que se está moviendo

  WeatherRepository _repository = WeatherRepository(); // Repositorio de datos

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

  void getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
        print(myPosition);
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    addMarker(myPosition, 'drone'); // Agregar el marcador inicial
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
                : Icon(
                    Icons.location_on, // Icono para las ubicaciones
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
    LatLng newMarkerPosition = LatLng(
      myPosition.latitude + (0.0001 * markers.length),
      myPosition.longitude + (0.0001 * markers.length),
    );
    addMarker(newMarkerPosition, 'location'); // Agregar nuevo marcador
  }

  void clearMarkers() {
    setState(() {
      markers = [markers.first]; // Mantener solo el marcador del dron
      points.clear();
      points.add(myPosition); // Mantener la posición inicial
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
              initialCenter: myPosition,
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
                  onPressed: () {
                    DashboardScreen.dashboardKey.currentState
                        ?.updateValues('100m²', '150 min', '20 km/h', '800%');
                  },
                  tooltip: 'Actualizar Valores',
                  child: const Icon(Icons.update),
                ),
                 SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: addNewMarker,
                  tooltip: 'Agregar Marcador',
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 8), // Espacio entre botones
                FloatingActionButton(
                  onPressed: clearMarkers,
                  tooltip: 'Limpiar Marcadores',
                  child: Icon(Icons.clear),
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                    ),
                    elevation: 5, // Sombra debajo de la tarjeta
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Distribución equitativa en fila
                        children: [
                          Row(
                            children: [
                              Icon(Icons.airplanemode_active,
                                  color: Colors.blue), // Icono para el nombre
                              SizedBox(
                                  width:
                                      8), // Espacio entre el icono y el texto
                              Text(
                                ': ${wt.name}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold), // Texto estilizado
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.map,
                                  color: Colors.red), // Icono para la latitud
                              SizedBox(width: 8),
                              Text(
                                'Lat: ${wt.lat}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color:
                                      Colors.green), // Icono para la longitud
                              SizedBox(width: 8),
                              Text(
                                'Log: ${wt.log}',
                                style: TextStyle(fontSize: 16),
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
                return CircularProgressIndicator();
              },
            ),
          ),
          // Lista de puntos
          Positioned(
            left: 16,
            bottom: 80,
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





















import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nasachallenge/data/weather_model.dart';
import 'package:nasachallenge/data/weather_repository.dart';
import 'package:nasachallenge/main.dart';

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

  // Función para obtener el primer Weather del Stream
void getInitialWeather() async {
  _repository.getAllStudents().listen((weatherList) {
    if (weatherList.isNotEmpty) {
      setState(() {
        initialWeather = weatherList.first; // Guardar el primer Weather
        myPosition = LatLng(initialWeather!.lat, initialWeather!.log); // Actualizar la posición del dron

        // Verificar si ya hay un marcador del dron
        if (markers.isEmpty || markers[0].point != myPosition) {
          addMarker(myPosition!, 'drone'); // Agregar el marcador inicial con la nueva posición
        }
      });
    }
  });
}

  @override
  void initState() {
    super.initState();
    getInitialWeather();
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
                : Icon(
                    Icons.location_on, // Icono para las ubicaciones
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
        if (myPosition != null)
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
                onPressed: () {
                  DashboardScreen.dashboardKey.currentState
                      ?.updateValues('100m²', '150 min', '20 km/h', '800%');
                },
                tooltip: 'Actualizar Valores',
                child: const Icon(Icons.update),
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                onPressed: addNewMarker,
                tooltip: 'Agregar Marcador',
                child: Icon(Icons.add),
              ),
              SizedBox(height: 8), // Espacio entre botones
              FloatingActionButton(
                onPressed: clearMarkers,
                tooltip: 'Limpiar Marcadores',
                child: Icon(Icons.clear),
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
                
                // Define `newPosition` based on the weather data
                LatLng newPosition = LatLng(wt.lat, wt.log);

                // Check if the position has changed
                /*
                if (myPosition != newPosition) {
                  setState(() {
                    myPosition = newPosition;

                    // Update the drone marker with the new position
                    markers[0] = Marker(
                      point: myPosition!,
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'assets/images/drone.png', // Imagen del dron
                        width: 40,
                        height: 40,
                      ),
                    );
                    points[0] = myPosition!; // Actualiza el primer punto
                  });
                }*/

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                  elevation: 5, // Sombra debajo de la tarjeta
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Distribución equitativa
                      children: [
                        Row(
                          children: [
                            Icon(Icons.airplanemode_active,
                                color: Colors.blue), // Icono del dron
                            SizedBox(width: 8), // Espacio entre icono y texto
                            Text(
                              'Dron: ${wt.name}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold), // Texto en negrita
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.map, color: Colors.red), // Icono de latitud
                            SizedBox(width: 8),
                            Text('Lat: ${wt.lat}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.green), // Icono de longitud
                            SizedBox(width: 8),
                            Text('Log: ${wt.log}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ),

        // Lista de puntos
        Positioned(
          left: 16,
          bottom: 80,
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

*/