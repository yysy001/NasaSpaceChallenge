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