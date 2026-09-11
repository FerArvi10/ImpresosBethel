import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/proveedor.dart';
import '../services/proveedor_service.dart';
import '../widgets/proveedor_card.dart';
import '../widgets/proveedor_destacado_card.dart';

/// Pantalla para listar y explorar proveedores consumidos desde la API REST.
class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  late Future<List<Proveedor>> _proveedoresFuture;
  String _busqueda = '';
  bool _soloVerificados = false;
  bool _soloDestacados = false;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  void _cargarProveedores() {
    setState(() {
      _proveedoresFuture = ProveedorService.obtenerProveedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final esOscuro = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio de Proveedores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar de la API',
            onPressed: _cargarProveedores,
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner indicador del Endpoint conectado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.teal.withAlpha((0.1 * 255).round()),
            child: Row(
              children: [
                const Icon(Icons.cloud_sync, size: 18, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'API: ${ApiConfig.proveedores}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Buscador y filtros rápidos
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, ciudad o producto...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: esOscuro ? const Color(0xFF1E1E1E) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.withAlpha((0.3 * 255).round()),
                  ),
                ),
              ),
              onChanged: (val) {
                setState(() => _busqueda = val.toLowerCase());
              },
            ),
          ),

          // Filtros tipo Chip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Verificados'),
                  selected: _soloVerificados,
                  onSelected: (val) => setState(() => _soloVerificados = val),
                  avatar: const Icon(Icons.verified, size: 16, color: Colors.blue),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Destacados'),
                  selected: _soloDestacados,
                  onSelected: (val) => setState(() => _soloDestacados = val),
                  avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Lista de proveedores obtenida de la API
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _cargarProveedores(),
              child: FutureBuilder<List<Proveedor>>(
                future: _proveedoresFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.teal),
                          SizedBox(height: 16),
                          Text('Consultando API de proveedores...'),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 54, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            const Text(
                              'Error al conectar con la API',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _cargarProveedores,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar conexión'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final todos = snapshot.data ?? [];
                  final filtrados = todos.where((p) {
                    final coincideBusqueda = _busqueda.isEmpty ||
                        p.nombreNegocio.toLowerCase().contains(_busqueda) ||
                        (p.ciudad != null &&
                            p.ciudad!.toLowerCase().contains(_busqueda)) ||
                        (p.departamento != null &&
                            p.departamento!.toLowerCase().contains(_busqueda)) ||
                        (p.descripcion != null &&
                            p.descripcion!.toLowerCase().contains(_busqueda));

                    final coincideVerificado = !_soloVerificados || p.verificado;
                    final coincideDestacado = !_soloDestacados || p.destacado;

                    return coincideBusqueda &&
                        coincideVerificado &&
                        coincideDestacado;
                  }).toList();

                  if (filtrados.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store_mall_directory_outlined,
                              size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No se encontraron proveedores',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final proveedor = filtrados[index];
                      void accionTap() {
                        Navigator.pushNamed(
                          context,
                          '/proveedor-detalle',
                          arguments: proveedor,
                        );
                      }

                      if (proveedor.destacado) {
                        return ProveedorDestacadoCard(
                          proveedor: proveedor,
                          onTap: accionTap,
                          onContactar: accionTap,
                        );
                      }

                      return ProveedorCard(
                        proveedor: proveedor,
                        onTap: accionTap,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


