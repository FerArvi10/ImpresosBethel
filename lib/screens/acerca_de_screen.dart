import 'package:flutter/material.dart';

/// Pantalla informativa con datos de la empresa y créditos del equipo.
class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: const Text('Acerca de'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera institucional
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.print, size: 54, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Impresos Bethel',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text(
                'Crecemos gracias a su preferencia',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            // Tarjeta de Misión y Servicios
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuestros Servicios',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Especialistas en artes gráficas, talonarios membretados autorizados por SAR, serigrafía y bordados industriales, rotulación, sellos y papelería corporativa.',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Créditos del Equipo
            const Text(
              'Equipo de Desarrollo — Actividad 4.2',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: const Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text('YA', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    title: Text('Yerson Alvarenga', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Desarrollador Flutter • UI & Navegación'),
                  ),
                  Divider(height: 1, indent: 64),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text('GE', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    title: Text('Gabriel Escalante', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Desarrollador Flutter • Layouts & Responsive'),
                  ),
                  Divider(height: 1, indent: 64),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text('FA', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    title: Text('Fernando Arvizu', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Desarrollador Flutter • Modelos & Análisis'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Versión 1.4.0 • Build 2026.08',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
