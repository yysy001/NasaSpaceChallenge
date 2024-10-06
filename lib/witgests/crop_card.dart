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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Column para el nombre y uso
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del cultivo
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Botón de uso
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Acción del botón, puedes definir una función aquí
                    },
                    child: Text(
                      use,
                      style: TextStyle(fontSize: 16),
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
                    backgroundColor: Colors.blue, // Color del botón
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Row(
                    children: [
                      Icon(Icons.cloud, color: Colors.white), // Ícono para MSNM
                      SizedBox(width: 4),
                      Text(
                        'MSNM: $msnm',
                        style: TextStyle(color: Colors.white), // Color del texto
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Ficha técnica con icono Temperatura
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Color del botón
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thermostat, color: Colors.white), // Ícono para Temperatura
                      SizedBox(width: 4),
                      Text(
                        'Temperatura: $temperature',
                        style: TextStyle(color: Colors.white), // Color del texto
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Ficha técnica con icono Humedad
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Color del botón
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Row(
                    children: [
                      Icon(Icons.water, color: Colors.white), // Ícono para Humedad
                      SizedBox(width: 4),
                      Text(
                        'Humedad: $humidity',
                        style: TextStyle(color: Colors.white), // Color del texto
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
