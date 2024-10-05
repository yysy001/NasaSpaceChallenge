/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoieWVyc29uMDAwMSIsImEiOiJjbTFyYm1hYW0wOXNxMmtvdmJ4MTV0OHNiIn0.gb9tiE445yQhLTWJWo_cGA';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myPosition = LatLng(-16.388377, -71.52548); // Posición inicial
  String currentStyle = 'mapbox/streets-v11'; // Estilo de mapa inicial
  List<Marker> markers = []; // Arreglo para almacenar los marcadores
  List<LatLng> points = []; // Lista para almacenar puntos seleccionados
  int? movingMarkerIndex; // Índice del marcador que se está moviendo

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
    // Agregar el marcador inicial del dron
    addMarker(myPosition, 'drone'); // Marcador inicial en la posición
  }

  void changeMapStyle(String style) {
    setState(() {
      currentStyle = style; // Cambia el estilo del mapa
    });
  }

  // Método para agregar un marcador en una posición específica
  void addMarker(LatLng position, String type) {
    setState(() {
      markers.add(
        Marker(
          point: position, // Coloca el marcador en la posición especificada
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              startMovingMarker(markers.length - 1); // Iniciar el movimiento
            },
            child: type == 'drone'
                ? Image.asset(
                    'assets/images/drone.png', // Ruta de la imagen del dron
                    width: 40,
                    height: 40,
                  )
                : Icon(
                    Icons.location_on, // Icono para los puntos de ubicación
                    size: 40,
                    color: Colors.red,
                  ),
          ),
        ),
      );
      points.add(position); // Agregar la posición a la lista de puntos
    });
  }

  // Método para agregar un nuevo marcador cerca de myPosition
  void addNewMarker() {
    // Crear una nueva posición aleatoria cerca de myPosition
    LatLng newMarkerPosition = LatLng(
      myPosition.latitude + (0.0001 * markers.length), // Mover hacia el norte
      myPosition.longitude + (0.0001 * markers.length), // Mover hacia el este
    );
    addMarker(newMarkerPosition, 'location'); // Agregar un nuevo marcador de ubicación
  }

  // Método para limpiar los marcadores
  void clearMarkers() {
    setState(() {
      // Mantener solo el marcador del dron
      markers = [markers.first]; // Mantener el marcador del dron
      points.clear(); // Limpiar la lista de puntos
      points.add(myPosition); // Agregar la posición del dron
    });
  }

  // Método para iniciar el movimiento del marcador
  void startMovingMarker(int index) {
    setState(() {
      movingMarkerIndex = index; // Establecer el índice del marcador en movimiento
    });
  }

  // Método para mover el marcador
  void moveMarker(LatLng newPosition) {
    if (movingMarkerIndex != null) {
      setState(() {
        // Actualizar la posición del marcador existente
        markers[movingMarkerIndex!] = Marker(
          point: newPosition,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              startMovingMarker(movingMarkerIndex!); // Iniciar el movimiento
            },
            child: markers[movingMarkerIndex!].child, // Mantener el tipo de marcador original
          ),
        );
        // Actualizar la posición en la lista de puntos
        points[movingMarkerIndex!] = newPosition; // Actualiza la posición en la lista
      });
    }
  }

  // Método para finalizar el movimiento
  void stopMovingMarker() {
    setState(() {
      movingMarkerIndex = null; // Resetear el índice del marcador en movimiento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          // Menú de botones
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
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
                      title: Text(index == 0 ? 'Dron' : 'Punto ${index}'), // Mostrar 'Dron' en el índice 0
                      subtitle: Text('Lat: ${points[index].latitude}, Lon: ${points[index].longitude}'),
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
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoieWVyc29uMDAwMSIsImEiOiJjbTFyYm1hYW0wOXNxMmtvdmJ4MTV0OHNiIn0.gb9tiE445yQhLTWJWo_cGA';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myPosition = LatLng(-16.388377, -71.52548); // Posición inicial
  String currentStyle = 'mapbox/streets-v11'; // Estilo de mapa inicial
  List<Marker> markers = []; // Arreglo para almacenar los marcadores
  List<LatLng> points = []; // Lista para almacenar puntos seleccionados
  int? movingMarkerIndex; // Índice del marcador que se está moviendo

  // Puntos que definen el recorrido
  List<LatLng> pathPoints = [
    LatLng(-16.388377, -71.52548), // Punto 1
    LatLng(-16.389000, -71.52500), // Punto 2
    LatLng(-16.389500, -71.52600), // Punto 3
    LatLng(-16.388000, -71.52650), // Punto 4
  ];

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
    // Agregar el marcador inicial del dron
    addMarker(myPosition, 'drone'); // Marcador inicial en la posición
  }

  void changeMapStyle(String style) {
    setState(() {
      currentStyle = style; // Cambia el estilo del mapa
    });
  }

  // Método para agregar un marcador en una posición específica
  void addMarker(LatLng position, String type) {
    setState(() {
      markers.add(
        Marker(
          point: position, // Coloca el marcador en la posición especificada
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              startMovingMarker(markers.length - 1); // Iniciar el movimiento
            },
            child: type == 'drone'
                ? Image.asset(
                    'assets/images/drone.png', // Ruta de la imagen del dron
                    width: 40,
                    height: 40,
                  )
                : Icon(
                    Icons.location_on, // Icono para los puntos de ubicación
                    size: 40,
                    color: Colors.red,
                  ),
          ),
        ),
      );
      points.add(position); // Agregar la posición a la lista de puntos
    });
  }

  // Método para limpiar los marcadores
  void clearMarkers() {
    setState(() {
      // Mantener el marcador del dron
      Marker droneMarker = markers.firstWhere((marker) => marker.child is Image); // Obtener el marcador del dron
      markers.clear(); // Limpiar todos los marcadores
      markers.add(droneMarker); // Reagregar el marcador del dron
      points.clear(); // Limpiar la lista de puntos
    });
  }

  // Método para iniciar el movimiento del marcador
  void startMovingMarker(int index) {
    setState(() {
      movingMarkerIndex = index; // Establecer el índice del marcador en movimiento
    });
  }

  // Método para mover el marcador
  void moveMarker(LatLng newPosition) {
    if (movingMarkerIndex != null) {
      setState(() {
        // Actualizar la posición del marcador existente
        markers[movingMarkerIndex!] = Marker(
          point: newPosition,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              startMovingMarker(movingMarkerIndex!); // Iniciar el movimiento
            },
            child: markers[movingMarkerIndex!].child, // Mantener el tipo de marcador original
          ),
        );
        // Actualizar la posición en la lista de puntos
        points[movingMarkerIndex!] = newPosition; // Actualiza la posición en la lista
      });
    }
  }

  // Método para finalizar el movimiento
  void stopMovingMarker() {
    setState(() {
      movingMarkerIndex = null; // Resetear el índice del marcador en movimiento
    });
  }

  // Método para calcular distancias y giros
  void calculatePath() {
    for (int i = 0; i < pathPoints.length - 1; i++) {
      LatLng point1 = pathPoints[i];
      LatLng point2 = pathPoints[i + 1];

      // Calcular distancia
      double distance = calculateDistance(point1, point2);
      print("Distancia entre Punto ${i + 1} y Punto ${i + 2}: ${distance.toStringAsFixed(2)} metros");

      // Si no es el último punto, calcular el giro
      if (i < pathPoints.length - 2) {
        LatLng point3 = pathPoints[i + 2];
        String turnDirection = determineTurn(point1, point2, point3);
        print("Desde Punto ${i + 2} girar a la $turnDirection");
      }
    }

    // Mostrar la ventana emergente con el gráfico
    showGraphDialog();
  }

  // Método para mostrar la ventana emergente con el gráfico
  void showGraphDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ruta del Dron'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(show: false), // Ocultar títulos
                borderData: FlBorderData(show: true), // Mostrar borde
                gridData: FlGridData(show: true), // Mostrar cuadrícula
                lineBarsData: [
                  LineChartBarData(
                    spots: pathPoints
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.value.longitude, e.value.latitude)) // Convertir puntos a FlSpot
                        .toList(),
                    isCurved: true,
                    //spots: [Colors.blue],
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  // Método para calcular la distancia entre dos puntos
  double calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371000; // Radio de la Tierra en metros
    double dLat = (point2.latitude - point1.latitude) * math.pi / 180;
    double dLon = (point2.longitude - point1.longitude) * math.pi / 180;
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(point1.latitude * math.pi / 180) * math.cos(point2.latitude * math.pi / 180) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c; // Distancia en metros
  }

  // Método para determinar la dirección del giro
  String determineTurn(LatLng p1, LatLng p2, LatLng p3) {
    double angle = (p2.longitude - p1.longitude) * (p3.latitude - p2.latitude) -
                   (p2.latitude - p1.latitude) * (p3.longitude - p2.longitude);
    return angle > 0 ? 'izquierda' : 'derecha';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del Dron'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              changeMapStyle(currentStyle == 'mapbox/streets-v11' ? 'mapbox/dark-v10' : 'mapbox/streets-v11');
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: myPosition, // Centrar el mapa en la posición del dron
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            addMarker(point, 'point'); // Agregar un marcador en la posición seleccionada
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.mapbox.com/styles/v1/$MAPBOX_ACCESS_TOKEN/{z}/{x}/{y}?access_token=$MAPBOX_ACCESS_TOKEN',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: markers), // Mostrar los marcadores en el mapa
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: calculatePath, // Calcular la ruta
            tooltip: 'Calcular Ruta',
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: clearMarkers, // Limpiar marcadores
            tooltip: 'Limpiar Marcadores',
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
*/