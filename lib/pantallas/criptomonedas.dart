
import 'package:flutter/material.dart';
import '../servicios/api_servicio.dart';

class PaginaCriptomonedas extends StatefulWidget {
  const PaginaCriptomonedas({super.key});

  @override
  State<PaginaCriptomonedas> createState() =>
      _PaginaCriptomonedasState();
}

class _PaginaCriptomonedasState
    extends State<PaginaCriptomonedas> {
  final montoController = TextEditingController(
    text: '100',
  );

  final claveController = TextEditingController();

  Map<String, dynamic>? precios;

  String error = '';
  bool cargando = false;

  Future<void> consultarPrecios() async {
    setState(() {
      cargando = true;
      error = '';
    });

    try {
      final url = Uri.https(
        'api.coingecko.com',
        '/api/v3/simple/price',
        {
          'ids': 'bitcoin,ethereum,solana',
          'vs_currencies': 'usd',
        },
      );

      final clave = claveController.text.trim();

      final datos = await ApiServicio.obtenerDatos(
        url,
        headers: clave.isEmpty
            ? null
            : {'x-cg-demo-api-key': clave},
      );

      if (!mounted) return;

      setState(() {
        precios = datos;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'Error al consultar precios: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Widget crearTarjetaCripto(
    String nombre,
    String identificador,
    String simbolo,
  ) {
    final valor = precios?[identificador]?['usd'];

    if (valor == null) {
      return Card(
        child: ListTile(
          title: Text(nombre),
          subtitle: const Text('Precio no disponible'),
        ),
      );
    }

    final precio = (valor as num).toDouble();

    final monto = double.tryParse(
          montoController.text.replaceAll(',', '.'),
        ) ??
        0;

    final cantidad = precio > 0 ? monto / precio : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$nombre ($simbolo)',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Precio actual: '
              '\$${precio.toStringAsFixed(2)} USD',
            ),

            const SizedBox(height: 10),

            Text(
              'Puedes comprar: '
              '${cantidad.toStringAsFixed(8)} $simbolo',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    montoController.dispose();
    claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🪙 Criptomonedas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Convertidor de criptomonedas',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: montoController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Monto en dólares (USD)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            onChanged: (valor) {
              setState(() {});
            },
          ),

          const SizedBox(height: 15),

          TextField(
            controller: claveController,
            decoration: const InputDecoration(
              labelText: 'Clave Demo CoinGecko (opcional)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: cargando ? null : consultarPrecios,
            icon: const Icon(Icons.currency_bitcoin),
            label: const Text('Consultar precios'),
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

          if (precios != null) ...[
            const SizedBox(height: 20),

            crearTarjetaCripto(
              'Bitcoin',
              'bitcoin',
              'BTC',
            ),

            crearTarjetaCripto(
              'Ethereum',
              'ethereum',
              'ETH',
            ),

            crearTarjetaCripto(
              'Solana',
              'solana',
              'SOL',
            ),
          ],
        ],
      ),
    );
  }
}
