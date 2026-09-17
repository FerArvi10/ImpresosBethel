import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/pedido.dart';
import '../models/carrito_item.dart';

/// Servicio para la generación de Facturas Fiscales SAR en formato PDF.
/// Cumple con la normativa tributaria hondureña y permite previsualizar,
/// imprimir o exportar el documento desde cualquier dispositivo Android o Web.
class FacturaPdfService {
  // Datos fiscales de la empresa
  static const String empresaNombre = 'IMPRESOS BETHEL S. DE R.L.';
  static const String empresaLema = 'Artes Gráficas, Talonarios SAR y Publicidad';
  static const String empresaRtn = '05011998012345';
  static const String empresaDireccion = 'Barrio El Centro, 3ra Ave, 4ta Calle, San Pedro Sula, Cortés';
  static const String empresaTelefono = '+504 9876-5432 / +504 2550-1234';
  static const String empresaEmail = 'facturacion@bethel.hn';

  // Datos de autorización SAR
  static const String cai = '2F89A1-34B87C-901D23-EF4567-89A012-34';
  static const String rangoAutorizado = '000-001-01-00001001 a 000-001-01-00005000';
  static const String fechaLimiteEmision = '31/12/2026';

  /// Genera los bytes del documento PDF con la factura fiscal.
  static Future<Uint8List> generarPdf({
    required Pedido pedido,
    List<CarritoItem>? items,
  }) async {
    final pdf = pw.Document();

    // Cálculos económicos
    final double total = pedido.total;
    final double subtotal = total / 1.15;
    final double isv = total - subtotal;

    final String numeroFactura = '000-001-01-${pedido.codigo.replaceAll('BET-', '').padLeft(8, '0')}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // 1. ENCABEZADO INSTITUCIONAL
              // ===============================================================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        empresaNombre,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal900,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(empresaLema, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.Text('RTN: $empresaRtn', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(empresaDireccion, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      pw.Text('Tel: $empresaTelefono | Email: $empresaEmail', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.teal, width: 1.5),
                      borderRadius: pw.BorderRadius.circular(6),
                      color: PdfColors.teal50,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('FACTURA FISCAL', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                        pw.SizedBox(height: 4),
                        pw.Text('No. $numeroFactura', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
                        pw.Text('Orden: ${pedido.codigo}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 6),

              // ===============================================================
              // 2. DATOS DEL CLIENTE Y FECHA
              // ===============================================================
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Cliente: ${pedido.cliente}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 2),
                        pw.Text('RTN / ID: Consumidor Final', style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Fecha de Emisión: ${pedido.fecha}', style: const pw.TextStyle(fontSize: 9)),
                        pw.SizedBox(height: 2),
                        pw.Text('Estado: ${pedido.estadoTexto.toUpperCase()}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal700)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // ===============================================================
              // 3. TABLA DE PRODUCTOS / SERVICIOS
              // ===============================================================
              pw.Text('DETALLE DE ARTÍCULOS Y SERVICIOS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
              pw.SizedBox(height: 6),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: const pw.FixedColumnWidth(40),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FixedColumnWidth(80),
                  3: const pw.FixedColumnWidth(80),
                },
                children: [
                  // Fila de encabezados
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.teal800),
                    children: [
                      _celdaHeader('CANT'),
                      _celdaHeader('DESCRIPCIÓN DEL TRABAJO / PRODUCTO', alinear: pw.TextAlign.left),
                      _celdaHeader('PRECIO UNIT.'),
                      _celdaHeader('TOTAL (L.)'),
                    ],
                  ),
                  // Filas de productos reales
                  if (items != null && items.isNotEmpty)
                    ...items.map((item) => pw.TableRow(
                          children: [
                            _celdaFila('${item.cantidad}'),
                            _celdaFila(
                              item.personalizacion.isNotEmpty
                                  ? '${item.producto.nombre}\nPersonalización: ${item.personalizacion}'
                                  : item.producto.nombre,
                              alinear: pw.TextAlign.left,
                            ),
                            _celdaFila('L ${item.producto.precio.toStringAsFixed(2)}'),
                            _celdaFila('L ${item.subtotal.toStringAsFixed(2)}'),
                          ],
                        ))
                  else
                    pw.TableRow(
                      children: [
                        _celdaFila('${pedido.cantidad}'),
                        _celdaFila('${pedido.tipoTrabajo}: ${pedido.descripcion}', alinear: pw.TextAlign.left),
                        _celdaFila('L ${(pedido.total / pedido.cantidad).toStringAsFixed(2)}'),
                        _celdaFila('L ${pedido.total.toStringAsFixed(2)}'),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 14),

              // ===============================================================
              // 4. DESGLOSE DE TOTALES E IMPUESTO SAR
              // ===============================================================
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Datos de autorización fiscal
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('DATOS FISCALES SAR:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                          pw.SizedBox(height: 2),
                          pw.Text('CAI: $cai', style: const pw.TextStyle(fontSize: 7)),
                          pw.Text('Rango Autorizado: $rangoAutorizado', style: const pw.TextStyle(fontSize: 7)),
                          pw.Text('Fecha Límite de Emisión: $fechaLimiteEmision', style: const pw.TextStyle(fontSize: 7)),
                          pw.SizedBox(height: 4),
                          pw.Text('Modalidad: Factura Electrónica / Preimpresa', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  // Cuadro de totales
                  pw.Container(
                    width: 190,
                    child: pw.Column(
                      children: [
                        _filaTotal('Importe Gravado 15%:', 'L ${subtotal.toStringAsFixed(2)}'),
                        _filaTotal('ISV (15%):', 'L ${isv.toStringAsFixed(2)}'),
                        _filaTotal('Importe Exonerado:', 'L 0.00'),
                        _filaTotal('Importe Exento:', 'L 0.00'),
                        pw.Divider(thickness: 1, color: PdfColors.teal),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('TOTAL A PAGAR:', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                            pw.Text('L ${total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // ===============================================================
              // 5. PIE DE PÁGINA OBLIGATORIO SAR
              // ===============================================================
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('“LA FACTURA ES BENEFICIO DE TODOS, ¡EXÍJALA!”', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
                    pw.SizedBox(height: 2),
                    pw.Text('ORIGINAL: CLIENTE  •  COPIA: EMISOR', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text('Documento emitido por Impresos Bethel OrderTracker App • Comprobante Válido', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Imprime o abre el diálogo nativo para guardar como PDF en Android/Web/Windows.
  static Future<void> imprimirOCompartirPdf({
    required Pedido pedido,
    List<CarritoItem>? items,
  }) async {
    final pdfBytes = await generarPdf(pedido: pedido, items: items);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Factura_${pedido.codigo}.pdf',
    );
  }

  // Helpers de celdas
  static pw.Widget _celdaHeader(String texto, {pw.TextAlign alinear = pw.TextAlign.center}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: pw.Text(
        texto,
        textAlign: alinear,
        style: pw.TextStyle(color: PdfColors.white, fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _celdaFila(String texto, {pw.TextAlign alinear = pw.TextAlign.center}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: pw.Text(
        texto,
        textAlign: alinear,
        style: const pw.TextStyle(fontSize: 8),
      ),
    );
  }

  static pw.Widget _filaTotal(String etiqueta, String valor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(etiqueta, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Text(valor, style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
        ],
      ),
    );
  }
}
