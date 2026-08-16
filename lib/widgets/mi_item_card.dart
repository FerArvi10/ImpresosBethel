import 'package:flutter/material.dart';

/// Widget Personalizado 1 — Presentación de Datos (Parte C)
///
/// Recibe 4 datos required, 2 callbacks required, 2 opcionales con default,
/// Card con elevation y borderRadius, y widget condicional (badge).
class MiItemCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final double valor;
  final String estado;
  final VoidCallback onTap;
  final VoidCallback onAccionSecundaria;

  // Parámetros opcionales con valor por defecto
  final Color colorAccento;
  final bool mostrarBadge;

  const MiItemCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.estado,
    required this.onTap,
    required this.onAccionSecundaria,
    this.colorAccento = Colors.teal,
    this.mostrarBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: colorAccento.withAlpha((0.3 * 255).round()),
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: colorAccento,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Widget condicional: badge si mostrarBadge es true
                  if (mostrarBadge)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.orange.shade400),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.brush, size: 14, color: Colors.orange),
                          SizedBox(width: 2),
                          Text(
                            'PERSONALIZABLE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                subtitulo,
                style: TextStyle(fontSize: 14.0, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: colorAccento.withAlpha((0.12 * 255).round()),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'L ${valor.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: colorAccento,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        size: 18, color: colorAccento),
                    tooltip: 'Ver detalle',
                    onPressed: onAccionSecundaria,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
