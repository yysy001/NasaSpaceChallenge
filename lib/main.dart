import 'package:flutter/material.dart';
import 'package:nasachallenge/screen/map_screen.dart';
import 'package:nasachallenge/witgests/custon_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variables para los valores de las tarjetas
  String areaTotal = '80m²';
  String tiempoTotal = '120 min';
  String viento = '15 km/h';
  String estadoBateria = '60%';

  void updateValues() {
    // Actualiza los valores aquí, por ejemplo:
    setState(() {
      areaTotal = '100m²';
      tiempoTotal = '150 min';
      viento = '20 km/h';
      estadoBateria = '80%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Row(
        children: [
          // Columna 1 - 4 Card con datos
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.shade300, // Fondo para la columna 1
              child: Column(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: 'Área Total',
                      icon: Icons.square_foot,
                      value: areaTotal,
                      iconColor: Colors.yellow,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CustomCard(
                      title: 'Tiempo Total',
                      icon: Icons.access_time,
                      value: tiempoTotal,
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CustomCard(
                      title: 'Viento',
                      icon: Icons.waves,
                      value: viento,
                      iconColor: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CustomCard(
                      title: 'Estado de Batería',
                      icon: Icons.battery_full,
                      value: estadoBateria,
                      iconColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Columna 2 - Dividida en dos partes
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Parte superior
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      const MapScreen(),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: ElevatedButton(
                          onPressed: updateValues,
                          child: const Text('Actualizar Valores'),
                        ),
                      ),
                    ],
                  ),
                ),
                // Parte inferior
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue.shade400,
                    child: const Center(
                      child: Text(
                        'Parte inferior columna 2',
                        style: TextStyle(fontSize: 18, color: Colors.white), // Cambié a blanco
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Columna 3 - Dividida en dos partes
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Parte superior
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green.shade200,
                    child: const Center(
                      child: Text(
                        'Parte superior columna 3',
                        style: TextStyle(fontSize: 18, color: Colors.white), // Cambié a blanco
                      ),
                    ),
                  ),
                ),
                // Parte inferior
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green.shade400,
                    child: const Center(
                      child: Text(
                        'Parte inferior columna 3',
                        style: TextStyle(fontSize: 18, color: Colors.white), // Cambié a blanco
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
