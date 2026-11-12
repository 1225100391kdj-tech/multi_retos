
import 'package:flutter/material.dart';

class PaginaGatos extends StatefulWidget {
  const PaginaGatos({super.key});

  @override
  State<PaginaGatos> createState() => _PaginaGatosState();
}

class _PaginaGatosState extends State<PaginaGatos> {
  final fraseController = TextEditingController();

  String filtro = 'normal';
  String? imagen;

  void generarMeme() {
    final frase = fraseController.text.trim();

    if (frase.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero escribe una frase'),
        ),
      );
      return;
    }

    final parametros = <String, String>{
      'fontSize': '35',
      'fontColor': 'white',
      'v': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    if (filtro != 'normal') {
      parametros['filter'] = filtro;
    }

    final url = Uri.https(
      'cataas.com',
      '/cat/says/${Uri.encodeComponent(frase)}',
      parametros,
    );

    setState(() {
      imagen = url.toString();
    });
  }

  @override
  void dispose() {
    fraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐱 Memes de gatos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Generador de memes de gatos',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: fraseController,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: 'Escribe una frase',
              hintText: 'Ejemplo: Ya quiero vacaciones',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<String>(
            initialValue: filtro,
            decoration: const InputDecoration(
              labelText: 'Selecciona un filtro',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'normal',
                child: Text('Normal'),
              ),
              DropdownMenuItem(
                value: 'mono',
                child: Text('Blanco y negro'),
              ),
              DropdownMenuItem(
                value: 'blur',
                child: Text('Desenfoque'),
              ),
              DropdownMenuItem(
                value: 'negate',
                child: Text('Negativo'),
              ),
            ],
            onChanged: (valor) {
              if (valor != null) {
                setState(() {
                  filtro = valor;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: generarMeme,
            icon: const Icon(Icons.pets),
            label: const Text('Generar meme'),
          ),

          const SizedBox(height: 25),

          if (imagen != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text(
                      'Tu meme generado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Image.network(
                      imagen!,
                      height: 350,
                      fit: BoxFit.contain,
                      loadingBuilder: (
                        context,
                        child,
                        progreso,
                      ) {
                        if (progreso == null) return child;

                        return const SizedBox(
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Text(
                          'No se pudo cargar el meme.',
                        );
                      },
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
