import 'package:flutter/material.dart';
import '../models/pedido.dart';

/// Pantalla de Historial de Pedidos (Layout obligatorio 1: ListView.builder con separatorBuilder).
class HistorialScreen extends StatefulWidget {
  final bool mostrarAppBar;

  const HistorialScreen({super.key, this.mostrarAppBar = true});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final List<Pedido> _pedidos = List.from(historialPedidosDemo);
  String _filtroEstado = 'Todos';

  List<Pedido> get _pedidosFiltrados {
    if (_filtroEstado == 'Todos') return _pedidos;
    return _pedidos.where((p) => p.estadoTexto == _filtroEstado).toList();
  }

  void _verDetallePedido(Pedido pedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pedido.codigo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: pedido.estadoColor.withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: pedido.estadoColor),
                  ),
                  child: Text(
                    pedido.estadoTexto,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: pedido.estadoColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _infoFila(Icons.person_outline, 'Cliente', pedido.cliente),
            const SizedBox(height: 8),
            _infoFila(Icons.calendar_today_outlined, 'Fecha de registro', pedido.fecha),
            const SizedBox(height: 8),
            _infoFila(Icons.print_outlined, 'Tipo de trabajo', pedido.tipoTrabajo),
            const SizedBox(height: 8),
            _infoFila(Icons.format_list_numbered, 'Cantidad', '${pedido.cantidad} unidades'),
            const SizedBox(height: 8),
            _infoFila(Icons.payments_outlined, 'Total facturado', 'L ${pedido.total.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            const Text(
              'Descripción técnica:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              pedido.descripcion,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoFila(IconData icono, String etiqueta, String valor) {
    return Row(
      children: [
        Icon(icono, size: 18, color: Colors.teal),
        const SizedBox(width: 8),
        Text(
          '$etiqueta: ',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Expanded(
          child: Text(
            valor,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final contenido = Column(
      children: [
        // Selector de filtro rápido por estado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 20, color: Colors.teal),
              const SizedBox(width: 8),
              const Text(
                'Filtrar por estado:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _filtroEstado,
                    items: const [
                      DropdownMenuItem(value: 'Todos', child: Text('Todos (12)')),
                      DropdownMenuItem(value: 'Pendiente', child: Text('Pendientes')),
                      DropdownMenuItem(value: 'En Proceso', child: Text('En Proceso')),
                      DropdownMenuItem(value: 'Listo para Entrega', child: Text('Listos')),
                      DropdownMenuItem(value: 'Entregado', child: Text('Entregados')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _filtroEstado = val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // 5.2 Layout Obligatorio: ListView.separated con más de 10 items
        Expanded(
          child: _pedidosFiltrados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No hay pedidos con estado "$_filtroEstado"',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _pedidosFiltrados.length,
                  separatorBuilder: (context, index) => const Divider(height: 8, indent: 64),
                  itemBuilder: (context, index) {
                    final pedido = _pedidosFiltrados[index];

                    return Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(pedido.icono, color: Colors.teal, size: 24),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pedido.codigo,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: pedido.estadoColor.withAlpha((0.15 * 255).round()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                pedido.estadoTexto,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: pedido.estadoColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              '${pedido.cliente} • ${pedido.tipoTrabajo}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Fecha: ${pedido.fecha} • Cant: ${pedido.cantidad}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'L ${pedido.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.teal,
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                          ],
                        ),
                        onTap: () => _verDetallePedido(pedido),
                      ),
                    );
                  },
                ),
        ),
      ],
    );

    if (!widget.mostrarAppBar) {
      return contenido;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: const Text('Historial de Pedidos'),
        centerTitle: true,
      ),
      body: contenido,
    );
  }
}
