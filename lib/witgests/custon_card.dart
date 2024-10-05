import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color iconColor;

  const CustomCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 57, 107, 58),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Título en blanco
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 80.0), // Espacio debajo del título
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea ícono a la izquierda y texto a la derecha
            children: [
              Row(
                children: [
                  Icon(icon, size: 80, color: iconColor), // Ícono a la izquierda, en blanco
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 40, // Aumenta el tamaño del valor
                  color: Colors.white, // Cambia el color del valor a blanco
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
