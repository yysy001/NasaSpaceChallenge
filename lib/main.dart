import 'package:flutter/material.dart';
import 'package:nasachallenge/screen/map_screen.dart';
import 'package:nasachallenge/weatherapi/homepage.dart';
import 'package:nasachallenge/witgests/crop_card.dart';
import 'package:nasachallenge/witgests/custon_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vhdoekfqjwwvsklzhzca.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZoZG9la2Zxand3dnNrbHpoemNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc2MzA3MTcsImV4cCI6MjA0MzIwNjcxN30.PKihHezo0djNd1_XNEqeWDwYaxMsESOSN7w4DXGgXhM',
  );
  runApp(MyApp());
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
      home: DashboardScreen(key: DashboardScreen.dashboardKey),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  static final GlobalKey<_DashboardScreenState> dashboardKey = GlobalKey();

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

  void updateValues(String newAreaTotal, String newTiempoTotal,
      String newViento, String newEstadoBateria) {
    setState(() {
      areaTotal = newAreaTotal;
      tiempoTotal = newTiempoTotal;
      viento = newViento;
      estadoBateria = newEstadoBateria;
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
                    ],
                  ),
                ),
                // Parte inferior
                Expanded(
                  flex: 1,
                  child: Stack(
                  children: [
                    const Homepage(),
                  ],
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
                // Parte superior con los CropCard
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "PRODUCTOS",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Para poner el texto en negrita
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      CropCard(
                        imagePath: 'assets/images/ajo.jpeg',
                        name: 'Ajo',
                        use: 'Condimento y alimento',
                        msnm: '0 - 3000 msnm',
                        temperature: '12 a 20 °C',
                        humidity: '60% - 80%',
                      ),
                      CropCard(
                        imagePath: 'assets/images/cebolla.jpeg',
                        name: 'Cebolla',
                        use: 'Condimento y alimento',
                        msnm: '0 - 3500 msnm',
                        temperature: '18 a 23 °C',
                        humidity: '65% - 80%',
                      ),
                      CropCard(
                        imagePath: 'assets/images/algodon.jpeg',
                        name: 'Algodón',
                        use: 'Textil',
                        msnm: '0 - 2000 msnm',
                        temperature: '20 a 30 °C',
                        humidity: '55% - 70%',
                      ),
                      CropCard(
                        imagePath: 'assets/images/choclo.jpeg',
                        name: 'Choclo',
                        use: 'Alimento',
                        msnm: '0 - 2800 msnm',
                        temperature: '15 a 25 °C',
                        humidity: '50% - 80%',
                      ),
                      // Agrega más CropCard aquí según sea necesario...
                    ],
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
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
