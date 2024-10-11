import 'package:flutter/material.dart';

class CropCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String use;
  final String msnm;
  final String temperature;
  final String humidity;

  CropCard({
    required this.imagePath,
    required this.name,
    required this.use,
    required this.msnm,
    required this.temperature,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reducido
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reducido
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0), // Reducido
              child: Image.asset(
                imagePath,
                height: 80, // Reducido
                width: 80, // Reducido
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12), // Reducido
            // Column para el nombre y uso
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del cultivo
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16, // Reducido
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4), // Reducido
                  // Botón de uso
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Reducido
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0), // Reducido
                      ),
                    ),
                    onPressed: () {
                      // Acción del botón, puedes definir una función aquí
                    },
                    child: Text(
                      use,
                      style: TextStyle(fontSize: 10), // Reducido
                    ),
                  ),
                ],
              ),
            ),
            // Column para los detalles en botones con íconos
            Column(
              children: [
                // Ficha técnica con icono MSNM
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8), // Reducido
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Reducido
                    ),
                  ),
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Row(
                    children: [
                      Icon(Icons.cloud, color: Colors.white, size: 8), // Tamaño del ícono reducido
                      SizedBox(width: 4),
                      Text(
                        'MSNM: $msnm',
                        style: TextStyle(color: Colors.white, fontSize: 8), // Reducido
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4), // Reducido
                // Ficha técnica con icono Temperatura
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8), // Reducido
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Reducido
                    ),
                  ),
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thermostat, color: Colors.white, size: 8), // Tamaño del ícono reducido
                      SizedBox(width: 4),
                      Text(
                        'Temperatura: $temperature',
                        style: TextStyle(color: Colors.white, fontSize: 8), // Reducido
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4), // Reducido
                // Ficha técnica con icono Humedad
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8), // Reducido
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Reducido
                    ),
                  ),
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Row(
                    children: [
                      Icon(Icons.water, color: Colors.white, size: 8), // Tamaño del ícono reducido
                      SizedBox(width: 4),
                      Text(
                        'Humedad: $humidity',
                        style: TextStyle(color: Colors.white, fontSize: 8), // Reducido
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
