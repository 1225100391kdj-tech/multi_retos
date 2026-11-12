
import 'dart:math';
import 'package:flutter/material.dart';
import '../servicios/api_servicio.dart';

class PaginaPeliculas extends StatefulWidget {
  const PaginaPeliculas({super.key});

  @override
  State<PaginaPeliculas> createState() =>
      _PaginaPeliculasState();
}

class _PaginaPeliculasState extends State<PaginaPeliculas> {
  final claveController = TextEditingController();

  String estado = 'Feliz';
  String mensaje = '';
  bool cargando = false;

  Map<String, dynamic>? pelicula;

  final Map<String, List<String>> recomendaciones = {
    'Feliz': [
      'Toy Story',
      'Shrek',
      'Finding Nemo',
    ],
    'Triste': [
      'Inside Out',
      'Coco',
      'Up',
    ],
    'Emocionado': [
      'Avengers: Endgame',
      'Jurassic Park',
      'Iron Man',
    ],
    'Romántico': [
      'Titanic',
      'The Notebook',
      'La La Land',
    ],
  };

  Future<void> buscarPelicula() async {
    final clave = claveController.text.trim();

    if (clave.isEmpty) {
      setState(() {
        mensaje = 'Ingresa tu API Key de OMDb.';
      });
      return;
    }

    setState(() {
      cargando = true;
      mensaje = '';
      pelicula = null;
    });

    try {
      final lista = recomendaciones[estado]!;
      final titulo = lista[Random().nextInt(lista.length)];

      final url = Uri.https(
        'www.omdbapi.com',
        '/',
        {
          'apikey': clave,
          't': titulo,
          'plot': 'short',
        },
      );

      final datos = await ApiServicio.obtenerDatos(url);

      if (datos['Response'] == 'False') {
        throw Exception(
          datos['Error'] ?? 'Película no encontrada',
        );
      }

      if (!mounted) return;

      setState(() {
        pelicula = datos;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = 'Error al consultar la película: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Películas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '¿Cómo te sientes hoy?',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            initialValue: estado,
            decoration: const InputDecoration(
              labelText: 'Estado de ánimo',
              border: OutlineInputBorder(),
            ),
            items: recomendaciones.keys.map((opcion) {
              return DropdownMenuItem(
                value: opcion,
                child: Text(opcion),
              );
            }).toList(),
            onChanged: (valor) {
              if (valor != null) {
                setState(() => estado = valor);
              }
            },
          ),

          const SizedBox(height: 15),

          TextField(
            controller: claveController,
            decoration: const InputDecoration(
              labelText: 'API Key de OMDb',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: cargando ? null : buscarPelicula,
            child: const Text('Recomendar película'),
          ),

          if (cargando)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (mensaje.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(mensaje),
            ),

          if (pelicula != null)
            Card(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(
                      pelicula!['Title'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (pelicula!['Poster'] != null &&
                        pelicula!['Poster'] != 'N/A')
                      Image.network(
                        pelicula!['Poster'],
                        height: 270,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons.movie,
                            size: 90,
                          );
                        },
                      ),

                    const SizedBox(height: 15),

                    Text('Año: ${pelicula!['Year']}'),
                    Text('Género: ${pelicula!['Genre']}'),
                    Text(
                      'Calificación: ${pelicula!['imdbRating']}',
                    ),

                    const SizedBox(height: 15),

                    Text(
                      pelicula!['Plot'] ?? '',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
