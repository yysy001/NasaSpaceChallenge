import 'dart:math';
import 'package:latlong2/latlong.dart';

// Función para calcular el área
double calculateArea(List<LatLng> points) {
  double area = 0.0;
  int j = points.length - 1;

  for (int i = 0; i < points.length; i++) {
    area += (points[j].longitude + points[i].longitude) * (points[j].latitude - points[i].latitude);
    j = i; // j es el último vértice
  }

  return (area.abs() / 2.0); // Área en grados cuadrados
}

// Función para calcular distancia
double calculateDistance(LatLng point1, LatLng point2) {
  var p = 0.017453292519943295; // Pi/180
  var a = 0.5 - cos((point2.latitude - point1.latitude) * p) / 2 +
      cos(point1.latitude * p) * cos(point2.latitude * p) *
      (1 - cos((point2.longitude - point1.longitude) * p)) / 2;

  return 12742 * asin(sqrt(a)) * 1000; // Distancia en metros
}

// Función para calcular el ángulo
double calculateAngle(LatLng point1, LatLng point2, LatLng point3) {
  double angle1 = atan2(point2.longitude - point1.longitude, point2.latitude - point1.latitude);
  double angle2 = atan2(point3.longitude - point2.longitude, point3.latitude - point2.latitude);

  double angle = (angle2 - angle1) * (180 / pi); // Convertir a grados
  return angle.abs() > 180 ? 360 - angle.abs() : angle.abs(); // Asegura que el giro esté en el rango [0, 180]
}

// Función para calcular la ruta
void calculateRoute(List<LatLng> points) {
  if (points.length < 3) return; // Se necesita al menos 3 puntos para calcular ángulos y distancias

  for (int i = 0; i < points.length; i++) {
    // Se conecta al siguiente punto, considerando que el último punto conecta al primero
    double distance = calculateDistance(points[i], points[(i + 1) % points.length]); 
    print("Distancia entre punto ${i + 1} y punto ${(i + 2) % points.length + 1}: ${distance.toStringAsFixed(2)} metros");

    if (i < points.length - 2) {
      double angle = calculateAngle(points[i], points[i + 1], points[(i + 2) % points.length]);
      print("Giro entre puntos ${i + 1}, ${i + 2}, ${i + 3}: ${angle.toStringAsFixed(2)} grados");
    }
  }

  // Cierre del polígono: distancia de regreso al punto inicial
  double returnDistance = calculateDistance(points.last, points.first);
  print("Distancia de regreso al punto inicial: ${returnDistance.toStringAsFixed(2)} metros");

  // Calcular área total
  double area = calculateArea(points);
  print("Área total del polígono: ${area.toStringAsFixed(2)} m²");
}