import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../models/carrito_item.dart';
import '../services/factura_pdf_service.dart';

/// Pantalla visual de Factura Fiscal Electrónica con opción de exportar/imprimir PDF.
class FacturaScreen extends StatelessWidget {
  final Pedido pedido;
  final List<CarritoItem>? items;

  const FacturaScreen({
    super.key,
    required this.pedido,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;
    final total = pedido.total;
    final subtotal = total / 1.15;
    final isv = total - subtotal;
    final numeroFactura = '000-001-01-${pedido.codigo.replaceAll('BET-', '').padLeft(8, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Factura Fiscal SAR'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Imprimir o Guardar PDF',
            onPressed: () => _generarPdf(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===============================================================
            // TARJETA PRINCIPAL DE FACTURA
            // ===============================================================
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.teal.shade200, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado de la Empresa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'IMPRESOS BETHEL S. DE R.L.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'RTN: 05011998012345',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                              Text(
                                'Barrio El Centro, San Pedro Sula',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                              Text(
                                'Tel: +504 9876-5432',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'FACTURA FISCAL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pedido.codigo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    // Datos de Emisión y Cliente
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Factura No:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(numeroFactura, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            const Text('Cliente:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(pedido.cliente, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Fecha:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(pedido.fecha, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            const Text('Estado:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: pedido.estadoColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
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
                      ],
                    ),

                    const Divider(height: 24),

                    // Detalle de Ítems
                    const Text(
                      'Detalle de la Orden',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    if (items != null && items!.isNotEmpty)
                      ...items!.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text('${item.cantidad}x', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.teal)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.producto.nombre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                      if (item.personalizacion.isNotEmpty)
                                        Text('Nota: ${item.personalizacion}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                    ],
                                  ),
                                ),
                                Text('L ${item.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ],
                            ),
                          ))
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text('${pedido.cantidad}x', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.teal)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('${pedido.tipoTrabajo}: ${pedido.descripcion}', style: const TextStyle(fontSize: 13)),
                            ),
                            Text('L ${pedido.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                      ),

                    const Divider(height: 24),

                    // Totales e Impuesto SAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal Gravado (15%):', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text('L ${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('I.S.V. (15%):', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text('L ${isv.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL A PAGAR:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          'L ${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Bloque SAR
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: esOscuro ? Colors.grey.shade900 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RÉGIMEN DE FACTURACIÓN SAR:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal)),
                          const SizedBox(height: 2),
                          Text('CAI: ${FacturaPdfService.cai}', style: const TextStyle(fontSize: 9)),
                          Text('Rango: ${FacturaPdfService.rangoAutorizado}', style: const TextStyle(fontSize: 9)),
                          Text('Límite de Emisión: ${FacturaPdfService.fechaLimiteEmision}', style: const TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===============================================================
            // BOTONES DE ACCIÓN
            // ===============================================================
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text(
                'Generar e Imprimir Factura PDF',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _generarPdf(context),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Volver al Inicio'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _generarPdf(BuildContext context) async {
    try {
      await FacturaPdfService.imprimirOCompartirPdf(pedido: pedido, items: items);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
