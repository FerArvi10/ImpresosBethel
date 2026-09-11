import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/api_config.dart';
import '../models/proveedor.dart';
import '../services/proveedor_service.dart';

/// Pantalla de detalle de un proveedor del directorio.
/// Muestra información completa del negocio obtenida de la API REST
/// (GET /api/proveedores/:id) o recibida por argumentos de navegación.
class ProveedorDetalleScreen extends StatefulWidget {
  final Proveedor? proveedor;
  final int? proveedorId;

  const ProveedorDetalleScreen({
    super.key,
    this.proveedor,
    this.proveedorId,
  });

  @override
  State<ProveedorDetalleScreen> createState() => _ProveedorDetalleScreenState();
}

class _ProveedorDetalleScreenState extends State<ProveedorDetalleScreen> {
  Proveedor? _proveedor;
  int? _proveedorId;
  bool _cargando = false;
  String? _error;
  bool _esFavorito = false;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      _inicializado = true;
      _extraerArgumentosYCargar();
    }
  }

  void _extraerArgumentosYCargar() {
    // 1. Argumentos directos del constructor
    if (widget.proveedor != null) {
      _proveedor = widget.proveedor;
      _proveedorId = widget.proveedor!.id;
      return;
    }

    if (widget.proveedorId != null) {
      _proveedorId = widget.proveedorId;
      _cargarProveedorDesdeApi(_proveedorId!);
      return;
    }

    // 2. Argumentos de la ruta (Navigator.pushNamed con arguments)
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Proveedor) {
      _proveedor = args;
      _proveedorId = args.id;
    } else if (args is int) {
      _proveedorId = args;
      _cargarProveedorDesdeApi(args);
    } else if (args is Map<String, dynamic>) {
      if (args['proveedor'] is Proveedor) {
        _proveedor = args['proveedor'] as Proveedor;
        _proveedorId = _proveedor!.id;
      } else if (args['id'] != null) {
        _proveedorId = int.tryParse(args['id'].toString());
        if (_proveedorId != null) {
          _cargarProveedorDesdeApi(_proveedorId!);
        }
      }
    }
  }

  Future<void> _cargarProveedorDesdeApi(int id) async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resultado = await ProveedorService.obtenerProveedorPorId(id);
      if (mounted) {
        setState(() {
          _proveedor = resultado;
          _cargando = false;
          if (resultado == null) {
            _error = 'No se encontró el proveedor con ID #$id';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cargando = false;
          _error = 'Error al cargar proveedor: $e';
        });
      }
    }
  }

  Widget _buildEstrellas(double calificacion) {
    final int llenas = calificacion.floor();
    final bool tieneMedia = (calificacion - llenas) >= 0.5;
    final int vacias = (5 - llenas - (tieneMedia ? 1 : 0)).clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < llenas; i++)
          const Icon(Icons.star, size: 20, color: Colors.amber),
        if (tieneMedia)
          const Icon(Icons.star_half, size: 20, color: Colors.amber),
        for (int i = 0; i < vacias; i++)
          Icon(Icons.star_border, size: 20, color: Colors.amber.shade200),
      ],
    );
  }

  void _copiarAlPortapapeles(String texto, String mensaje) {
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mostrarDialogoCotizacion(Proveedor prov) {
    final cantidadCtrl = TextEditingController(text: '100');
    final detalleCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cotizar con ${prov.nombreNegocio}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Envía una solicitud rápida a este proveedor asociado.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad estimada',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detalleCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Especificaciones o trabajo requerido',
                  hintText: 'Ej: 100 camisetas sublimadas a full color...',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Enviar Solicitud de Cotización',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Solicitud enviada exitosamente a ${prov.nombreNegocio}',
                        ),
                        backgroundColor: Colors.teal.shade700,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final esOscuro = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _proveedor?.nombreNegocio ?? 'Detalle del Proveedor',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_proveedorId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Recargar de la API',
              onPressed: () => _cargarProveedorDesdeApi(_proveedorId!),
            ),
          IconButton(
            icon: Icon(
              _esFavorito ? Icons.favorite : Icons.favorite_border,
              color: _esFavorito ? Colors.red : null,
            ),
            tooltip: 'Guardar en Favoritos',
            onPressed: () {
              setState(() => _esFavorito = !_esFavorito);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _esFavorito
                        ? 'Agregado a proveedores guardados'
                        : 'Eliminado de guardados',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(esOscuro, theme),
    );
  }

  Widget _buildBody(bool esOscuro, ThemeData theme) {
    if (_cargando) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Cargando información del proveedor...',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            if (_proveedorId != null) ...[
              const SizedBox(height: 8),
              Text(
                'GET ${ApiConfig.proveedorDetalle(_proveedorId!)}',
                style: const TextStyle(fontSize: 12, color: Colors.teal),
              ),
            ],
          ],
        ),
      );
    }

    if (_error != null && _proveedor == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'No se pudo cargar el proveedor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _proveedorId != null
                    ? () => _cargarProveedorDesdeApi(_proveedorId!)
                    : () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al Directorio'),
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

    final p = _proveedor;
    if (p == null) {
      return const Center(
        child: Text('No hay información disponible del proveedor.'),
      );
    }

    final accentColor = p.destacado ? Colors.amber : Colors.teal;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Banner de Conexión a la API ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.teal.withAlpha((0.1 * 255).round()),
            child: Row(
              children: [
                const Icon(Icons.cloud_done, size: 16, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Endpoint: ${ApiConfig.proveedorDetalle(p.id)}',
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

          // ─── Hero Header del Proveedor ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: esOscuro
                    ? [
                        p.destacado
                            ? const Color(0xFF2E2410)
                            : const Color(0xFF162B28),
                        const Color(0xFF1E1E1E),
                      ]
                    : [
                        p.destacado
                            ? Colors.amber.shade50
                            : Colors.teal.shade50,
                        Colors.white,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Avatar / Ícono de la empresa
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: p.destacado
                          ? [Colors.amber.shade600, Colors.orange.shade700]
                          : [Colors.teal.shade600, Colors.teal.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (p.destacado ? Colors.amber : Colors.teal)
                            .withAlpha((0.35 * 255).round()),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      p.nombreNegocio.isNotEmpty
                          ? p.nombreNegocio[0].toUpperCase()
                          : 'P',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Nombre del Negocio
                Text(
                  p.nombreNegocio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Badges: Verificado, Destacado, Disponibilidad
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    if (p.verificado)
                      Chip(
                        avatar: const Icon(Icons.verified,
                            size: 16, color: Colors.blue),
                        label: const Text('Verificado'),
                        backgroundColor: Colors.blue.withAlpha((0.12 * 255).round()),
                        side: BorderSide(color: Colors.blue.shade200),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    if (p.destacado)
                      Chip(
                        avatar: const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                        label: const Text('Destacado'),
                        backgroundColor: Colors.amber.withAlpha((0.15 * 255).round()),
                        side: BorderSide(color: Colors.amber.shade300),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    Chip(
                      avatar: Icon(
                        p.disponible ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: p.disponible ? Colors.green : Colors.red,
                      ),
                      label: Text(
                        p.disponible ? 'Disponible' : 'No disponible',
                        style: TextStyle(
                          color: p.disponible ? Colors.green : Colors.red,
                        ),
                      ),
                      backgroundColor: (p.disponible ? Colors.green : Colors.red)
                          .withAlpha((0.12 * 255).round()),
                      side: BorderSide(
                        color: p.disponible
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Calificación en Estrellas
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEstrellas(p.calificacion),
                    const SizedBox(width: 8),
                    Text(
                      p.calificacion.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${p.totalResenas} reseñas)',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodySmall?.color ?? Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Tarjetas de Información Rápida (Stats) ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Precio base
                Expanded(
                  child: Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.payments_outlined,
                                  size: 16, color: accentColor),
                              const SizedBox(width: 4),
                              const Text(
                                'Tarifa Base',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.precioDesdeTexto,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Categoría
                Expanded(
                  child: Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.category_outlined,
                                  size: 16, color: Colors.teal),
                              SizedBox(width: 4),
                              Text(
                                'Categoría',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.categoria?.nombre ?? 'General',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Ubicación
                Expanded(
                  child: Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_city,
                                  size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                'Ubicación',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.ciudad ?? 'Honduras',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Sección: Descripción del Negocio ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.teal, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Descripción del Negocio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p.descripcion != null && p.descripcion!.isNotEmpty
                          ? p.descripcion!
                          : 'Este proveedor aún no ha agregado una descripción detallada de sus servicios.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: esOscuro
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Sección: Datos de Contacto y Ubicación ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.contact_phone_outlined,
                            color: Colors.teal, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Contacto y Ubicación',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Teléfono
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.withAlpha((0.15 * 255).round()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.phone, color: Colors.teal),
                      ),
                      title: const Text('Teléfono de Contacto'),
                      subtitle: Text(
                        p.telefono != null && p.telefono!.isNotEmpty
                            ? p.telefono!
                            : 'No disponible',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: p.telefono != null && p.telefono!.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              tooltip: 'Copiar número',
                              onPressed: () => _copiarAlPortapapeles(
                                p.telefono!,
                                'Teléfono copiado: ${p.telefono}',
                              ),
                            )
                          : null,
                    ),

                    const Divider(height: 1),

                    // Dirección / Región
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha((0.15 * 255).round()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.place, color: Colors.blue),
                      ),
                      title: const Text('Zona de Cobertura'),
                      subtitle: Text(
                        '${p.ciudad ?? "Honduras"}, ${p.departamento ?? "Nacional"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Sección: Garantías y Ventajas ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beneficios y Garantías',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBeneficioItem(
                      Icons.verified_user_outlined,
                      'Proveedor Certificado',
                      'Registrado y validado en la plataforma de Impresos Bethel.',
                    ),
                    const SizedBox(height: 8),
                    _buildBeneficioItem(
                      Icons.local_shipping_outlined,
                      'Envíos y Entregas',
                      'Coordinación directa de entrega en el taller o envío.',
                    ),
                    const SizedBox(height: 8),
                    _buildBeneficioItem(
                      Icons.request_quote_outlined,
                      'Cotizaciones Formales',
                      'Precios transparentes y emisión de comprobantes fiscales.',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Botones de Acción Inferior ───
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text(
                      'Solicitar Cotización',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _mostrarDialogoCotizacion(p),
                  ),
                ),
                const SizedBox(height: 10),
                if (p.telefono != null && p.telefono!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.teal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.phone, color: Colors.teal),
                      label: Text(
                        'Llamar: ${p.telefono}',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        _copiarAlPortapapeles(
                          p.telefono!,
                          'Marcando a ${p.nombreNegocio} (${p.telefono})',
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBeneficioItem(IconData icono, String titulo, String subtitulo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 18, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitulo,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
