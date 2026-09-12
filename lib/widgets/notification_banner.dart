import 'package:flutter/material.dart';

/// Widget y función para desplegar una notificación visual interactiva
/// que simula la recepción de una notificación de sistema / Push Notification
/// tras completar el registro exitosamente.
class NotificationBanner {
  static OverlayEntry? _entryActual;

  /// Muestra una notificación flotante en la parte superior de la pantalla.
  static void mostrar(
    BuildContext context, {
    String titulo = 'Registro completado',
    String mensaje = 'Tu cuenta ha sido creada correctamente.',
    Duration duracion = const Duration(seconds: 4),
  }) {
    // Si ya hay una visible, removerla
    _entryActual?.remove();
    _entryActual = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _NotificationBannerWidget(
        titulo: titulo,
        mensaje: mensaje,
        duracion: duracion,
        onDismiss: () {
          entry.remove();
          if (_entryActual == entry) _entryActual = null;
        },
      ),
    );

    _entryActual = entry;
    overlay.insert(entry);
  }
}

class _NotificationBannerWidget extends StatefulWidget {
  final String titulo;
  final String mensaje;
  final Duration duracion;
  final VoidCallback onDismiss;

  const _NotificationBannerWidget({
    required this.titulo,
    required this.mensaje,
    required this.duracion,
    required this.onDismiss,
  });

  @override
  State<_NotificationBannerWidget> createState() =>
      _NotificationBannerWidgetState();
}

class _NotificationBannerWidgetState extends State<_NotificationBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Auto-cierre
    Future.delayed(widget.duracion, () {
      if (mounted) {
        _descartar();
      }
    });
  }

  void _descartar() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Dark slate elegante
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.35 * 255).round()),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.teal.withAlpha((0.2 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.teal.shade400.withAlpha((0.6 * 255).round()),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono estilo Push Notification de Bethel
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade600,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withAlpha((0.5 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Contenido de la notificación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'ORDERTRACKER • NOTIFICACIÓN',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: Colors.tealAccent,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Ahora',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.titulo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.mensaje,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade300,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botón cerrar
                  GestureDetector(
                    onTap: _descartar,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
