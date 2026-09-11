import 'package:flutter/material.dart';
import '../models/proveedor.dart';


class ProveedorDestacadoCard extends StatelessWidget {
 
  final Proveedor proveedor;

 
  final VoidCallback onTap;

 
  final VoidCallback? onContactar;

 
  final double? ancho;

  
  final Color colorDestacado;

  const ProveedorDestacadoCard({
    super.key,
    required this.proveedor,
    required this.onTap,
    this.onContactar,
    this.ancho,
    this.colorDestacado = Colors.amber,
  });

 
  Widget _buildEstrellas(double calificacion) {
    final int llenas = calificacion.floor();
    final bool tieneMedia = (calificacion - llenas) >= 0.5;
    final int vacias = (5 - llenas - (tieneMedia ? 1 : 0)).clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < llenas; i++)
          const Icon(Icons.star, size: 16, color: Colors.amber),
        if (tieneMedia)
          const Icon(Icons.star_half, size: 16, color: Colors.amber),
        for (int i = 0; i < vacias; i++)
          Icon(Icons.star_border, size: 16, color: Colors.amber.shade200),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final esOscuro = theme.brightness == Brightness.dark;

    Widget tarjeta = Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
          color: Colors.amber.withAlpha((0.5 * 255).round()),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: esOscuro
                  ? [
                      const Color(0xFF242014),
                      const Color(0xFF1E1E1E),
                    ]
                  : [
                      Colors.amber.shade50.withAlpha((0.6 * 255).round()),
                      Colors.white,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
             
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade700,
                      Colors.orange.shade800,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.stars, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'PROVEEDOR DESTACADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    if (proveedor.verificado)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.25 * 255).round()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Verificado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

           
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade600,
                                Colors.orange.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withAlpha((0.35 * 255).round()),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              proveedor.nombreNegocio.isNotEmpty
                                  ? proveedor.nombreNegocio[0].toUpperCase()
                                  : 'P',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                      
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                proveedor.nombreNegocio,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: esOscuro ? Colors.white : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (proveedor.categoria != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withAlpha(
                                        (esOscuro ? 0.25 : 0.12 * 255).round()),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    proveedor.categoria!.nombre,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: esOscuro
                                          ? Colors.tealAccent
                                          : Colors.teal.shade800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ─── Estrellas + Calificación ───
                    Row(
                      children: [
                        _buildEstrellas(proveedor.calificacion),
                        const SizedBox(width: 8),
                        Text(
                          proveedor.calificacion.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          ' (${proveedor.totalResenas} reseñas)',
                          style: TextStyle(
                            color: esOscuro ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    // ─── Descripción breve (si existe) ───
                    if (proveedor.descripcion != null &&
                        proveedor.descripcion!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        proveedor.descripcion!,
                        style: TextStyle(
                          fontSize: 12,
                          color: esOscuro ? Colors.grey.shade300 : Colors.grey.shade700,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // ─── Fila inferior: Ubicación + Precio ───
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ubicación
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: esOscuro ? Colors.tealAccent : Colors.teal,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${proveedor.ciudad ?? "Honduras"}, ${proveedor.departamento ?? ""}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: esOscuro
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Precio desde
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.amber.withAlpha(
                                (esOscuro ? 0.25 : 0.15 * 255).round()),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.amber.shade700,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            proveedor.precioDesdeTexto,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: esOscuro
                                  ? Colors.amber.shade200
                                  : Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ─── Botón de contacto / cotización opcional ───
                    if (onContactar != null ||
                        (proveedor.telefono != null &&
                            proveedor.telefono!.isNotEmpty)) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.phone, size: 16),
                          label: Text(
                            proveedor.telefono != null &&
                                    proveedor.telefono!.isNotEmpty
                                ? 'Contactar: ${proveedor.telefono}'
                                : 'Solicitar Cotización',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: onContactar ?? onTap,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (ancho != null) {
      return SizedBox(width: ancho, child: tarjeta);
    }

    return tarjeta;
  }
}
