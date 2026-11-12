
import 'package:flutter/material.dart';

import 'peliculas.dart';
import 'memes_gatos.dart';
import 'clima.dart';
import 'criptomonedas.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiRetos'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          const Text(
            'Bienvenido a MultiRetos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Selecciona uno de los cuatro retos',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),

          crearTarjeta(
            context,
            '🎬',
            'Películas',
            'Recomendaciones según tu estado de ánimo',
            const PaginaPeliculas(),
          ),

          crearTarjeta(
            context,
            '🐱',
            'Memes de gatos',
            'Genera memes personalizados',
            const PaginaGatos(),
          ),

          crearTarjeta(
            context,
            '🌤️',
            'Clima',
            'Consulta el clima actual',
            const PaginaClima(),
          ),

          crearTarjeta(
            context,
            '🪙',
            'Criptomonedas',
            'Consulta precios y convierte dólares',
            const PaginaCriptomonedas(),
          ),
        ],
      ),
    );
  }

  Widget crearTarjeta(
    BuildContext context,
    String emoji,
    String titulo,
    String descripcion,
    Widget pagina,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: Text(
          emoji,
          style: const TextStyle(fontSize: 35),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(descripcion),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pagina,
            ),
          );
        },
      ),
    );
  }
}
