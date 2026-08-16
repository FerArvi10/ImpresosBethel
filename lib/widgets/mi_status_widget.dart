import 'package:flutter/material.dart';

/// Widget Personalizado 2 — Estado/Resumen (Parte C)
///
/// Lógica condicional que cambia color, ícono y progreso según el estado.
/// Usa Chip, LinearProgressIndicator, RichText (no usados en Widget 1).
class MiStatusWidget extends StatelessWidget {
  final String estado;
  final String? detalles;
  final double progreso;

  const MiStatusWidget({
    super.key,
    required this.estado,
    this.detalles,
    this.progreso = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    Color colorEstado;
    IconData iconoEstado;
    String textoEstado;

    switch (estado.toLowerCase()) {
      case 'pendiente':
        colorEstado = Colors.amber.shade800;
        iconoEstado = Icons.timer_outlined;
        textoEstado = 'Pendiente';
        break;
      case 'en proceso':
        colorEstado = Colors.blue.shade700;
        iconoEstado = Icons.autorenew;
        textoEstado = 'En Proceso';
        break;
      case 'completado':
        colorEstado = Colors.green.shade700;
        iconoEstado = Icons.check_circle_outline;
        textoEstado = 'Completado';
        break;
      case 'urgente':
        colorEstado = Colors.red.shade700;
        iconoEstado = Icons.warning_amber_rounded;
        textoEstado = '¡URGENTE!';
        break;
      case 'activo':
        colorEstado = Colors.teal.shade700;
        iconoEstado = Icons.storefront;
        textoEstado = 'Activo';
        break;
      default:
        colorEstado = Colors.grey.shade700;
        iconoEstado = Icons.help_outline;
        textoEstado = estado;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: colorEstado.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colorEstado.withAlpha((0.4 * 255).round()),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                avatar: Icon(iconoEstado, size: 18, color: Colors.white),
                label: Text(
                  textoEstado,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: colorEstado,
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                visualDensity: VisualDensity.compact,
              ),
              RichText(
                text: TextSpan(
                  style:
                      TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  children: [
                    const TextSpan(text: 'Progreso: '),
                    TextSpan(
                      text: '${(progreso * 100).toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorEstado,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (detalles != null && detalles!.isNotEmpty) ...[
            const SizedBox(height: 6.0),
            Text(
              detalles!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: progreso.clamp(0.0, 1.0),
              backgroundColor: colorEstado.withAlpha((0.2 * 255).round()),
              valueColor: AlwaysStoppedAnimation<Color>(colorEstado),
              minHeight: 6.0,
            ),
          ),
        ],
      ),
    );
  }
}
