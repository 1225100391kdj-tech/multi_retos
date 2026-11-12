
import 'package:flutter/material.dart';
import '../servicios/api_servicio.dart';

class PaginaClima extends StatefulWidget {
  const PaginaClima({super.key});

  @override
  State<PaginaClima> createState() => _PaginaClimaState();
}

class _PaginaClimaState extends State<PaginaClima> {
  final ciudadController = TextEditingController(
    text: 'Dolores Hidalgo',
  );

  Map<String, dynamic>? clima;

  String ubicacion = '';
  String error = '';
  bool cargando = false;

  String descripcionClima(int codigo) {
    if (codigo == 0) return 'Despejado';
    if (codigo <= 3) return 'Parcialmente nublado';
    if (codigo == 45 || codigo == 48) return 'Niebla';
    if (codigo >= 51 && codigo <= 67) return 'Lluvia';
    if (codigo >= 71 && codigo <= 77) return 'Nieve';
    if (codigo >= 80 && codigo <= 82) return 'Chubascos';
    if (codigo >= 95) return 'Tormenta';

    return 'Clima variable';
  }

  Future<void> consultarClima() async {
    final ciudad = ciudadController.text.trim();

    if (ciudad.isEmpty) {
      setState(() {
        error = 'Escribe el nombre de una ciudad.';
      });
      return;
    }

    setState(() {
      cargando = true;
      error = '';
      clima = null;
    });

    try {
      // Buscar las coordenadas de la ciudad.
      final geoUrl = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': ciudad,
          'count': '1',
          'language': 'es',
          'format': 'json',
        },
      );

      final geoDatos =
          await ApiServicio.obtenerDatos(geoUrl);

      final resultados = geoDatos['results'] as List?;

      if (resultados == null || resultados.isEmpty) {
        throw Exception('Ciudad no encontrada');
      }

      final lugar = resultados.first;
      final latitud = lugar['latitude'].toString();
      final longitud = lugar['longitude'].toString();

      // Obtener los datos del clima.
      final climaUrl = Uri.https(
        'api.open-meteo.com',
        '/v1/forecast',
        {
          'latitude': latitud,
          'longitude': longitud,
          'current':
              'temperature_2m,relative_humidity_2m,'
              'apparent_temperature,weather_code,wind_speed_10m',
          'timezone': 'auto',
        },
      );

      final datos =
          await ApiServicio.obtenerDatos(climaUrl);

      if (!mounted) return;

      setState(() {
        clima = datos['current'];
        ubicacion =
            '${lugar['name']}, ${lugar['country']}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'Error al consultar el clima: $e';
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
    ciudadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Clima'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Consulta el clima actual',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: ciudadController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la ciudad',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: cargando ? null : consultarClima,
            icon: const Icon(Icons.search),
            label: const Text('Consultar clima'),
          ),

          if (cargando)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),

          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(error),
            ),

          if (clima != null)
            Card(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Icon(
                      Icons.wb_sunny,
                      size: 90,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      ubicacion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      '${clima!['temperature_2m']} °C',
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      descripcionClima(
                        (clima!['weather_code'] as num).toInt(),
                      ),
                    ),

                    const Divider(height: 35),

                    Text(
                      'Sensación térmica: '
                      '${clima!['apparent_temperature']} °C',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Humedad: '
                      '${clima!['relative_humidity_2m']}%',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Velocidad del viento: '
                      '${clima!['wind_speed_10m']} km/h',
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
