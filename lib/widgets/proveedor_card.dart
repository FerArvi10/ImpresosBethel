import 'package:flutter/material.dart';
import '../models/proveedor.dart';


class ProveedorCard extends StatelessWidget {
 
  final Proveedor proveedor;

 
  final VoidCallback onTap;

 
  final Color colorAccento;

 
  final bool mostrarDescripcion;

  const ProveedorCard({
    super.key,
    required this.proveedor,
    required this.onTap,
    this.colorAccento = Colors.teal,
    this.mostrarDescripcion = true,
  });

 
  Widget _buildEstrellas(double calificacion) {
    final int llenas = calificacion.floor();
    final bool tienMedia = (calificacion - llenas) >= 0.5;
    final int vacias = 5 - llenas - (tienMedia ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < llenas; i++)
          const Icon(Icons.star, size: 16, color: Colors.amber),
        if (tienMedia)
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

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: colorAccento.withAlpha((0.25 * 255).round()),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colorAccento.withAlpha((0.15 * 255).round()),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        proveedor.nombreNegocio.isNotEmpty
                            ? proveedor.nombreNegocio[0].toUpperCase()
                            : 'P',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorAccento,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                proveedor.nombreNegocio,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: esOscuro ? Colors.white : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                           
                            if (proveedor.verificado)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(Icons.verified,
                                    size: 18, color: Colors.blue.shade600),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),

                     
                        Row(
                          children: [
                            _buildEstrellas(proveedor.calificacion),
                            const SizedBox(width: 6),
                            Text(
                              proveedor.calificacion.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${proveedor.totalResenas})',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color ??
                                    Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (proveedor.destacado || !proveedor.disponible) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    if (proveedor.destacado)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              'DESTACADO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!proveedor.disponible)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.do_not_disturb,
                                size: 14, color: Colors.red),
                            SizedBox(width: 4),
                            Text(
                              'NO DISPONIBLE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],

             
              if (mostrarDescripcion &&
                  proveedor.descripcion != null &&
                  proveedor.descripcion!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  proveedor.descripcion!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: esOscuro
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
              ],

              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: Colors.grey.withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(height: 12),

            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 16, color: colorAccento),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            proveedor.ciudad != null
                                ? '${proveedor.ciudad}, ${proveedor.departamento ?? ''}'
                                : 'Honduras',
                            style: TextStyle(
                              fontSize: 12,
                              color: esOscuro
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorAccento.withAlpha((0.12 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      proveedor.precioDesdeTexto,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorAccento,
                      ),
                    ),
                  ),
                ],
              ),

              
              if (proveedor.telefono != null &&
                  proveedor.telefono!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      proveedor.telefono!,
                      style: TextStyle(
                        fontSize: 12,
                        color: esOscuro
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                   
                    if (proveedor.categoria != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(proveedor.categoria!.icono,
                              size: 14, color: colorAccento),
                          const SizedBox(width: 4),
                          Text(
                            proveedor.categoria!.nombre,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorAccento,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
