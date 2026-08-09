import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductosData {
  static const List<Producto> listaProductos = [
    Producto(
      id: 'prod_01',
      nombre: 'Baleada con huevo',
      descripcion:
          'Deliciosa tortilla de harina de trigo recién hecha a la plancha, rellena con cremosos frijoles refritos estilo casero, mantequilla suelta, queso duro espolvoreado y jugoso huevo picado al gusto.',
      precio: 20.10,
      categoria: 'Desayunos & Típicos',
      ingredientes: [
        'Tortilla de harina artesanal',
        'Frijoles refritos negros/rojos',
        'Huevo revuelto',
        'Mantequilla suelta',
        'Queso duro rallado'
      ],
      calorias: 380,
      tiempoPreparacion: '5-8 min',
      icono: Icons.breakfast_dining,
    ),
    Producto(
      id: 'prod_02',
      nombre: 'Arroz con pollo',
      descripcion:
          'Plato fuerte tradicional preparado con arroz sazonado con sofrito de verduras (zanahoria, chícharos, chile dulce y cebolla), pechuga de pollo desmenuzada y especias de la casa. Incluye tajadas o ensalada de la casa.',
      precio: 50.00,
      categoria: 'Platos Fuertes',
      ingredientes: [
        'Arroz blanco sazonado',
        'Pechuga de pollo desmenuzada',
        'Zanahoria picada',
        'Chile dulce y cebolla',
        'Especias de la casa'
      ],
      calorias: 520,
      tiempoPreparacion: '10-15 min',
      icono: Icons.dinner_dining,
    ),
    Producto(
      id: 'prod_03',
      nombre: 'Agua embotellada',
      descripcion:
          'Agua purificada y mineralizada de 500ml, completamente helada y purificada mediante filtrado por ósmosis inversa. Ideal para acompañar tus comidas.',
      precio: 20.00,
      categoria: 'Bebidas',
      ingredientes: ['Agua purificada', 'Minerales añadidos'],
      calorias: 0,
      tiempoPreparacion: 'Inmediato',
      icono: Icons.water_drop,
    ),
    Producto(
      id: 'prod_04',
      nombre: 'Cafe',
      descripcion:
          'Café 100% tinto puro cosechado en las montañas de Honduras. Servido bien caliente, con aroma intenso y opción de acompañar con leche o azúcar al gusto.',
      precio: 35.00,
      categoria: 'Bebidas',
      ingredientes: [
        'Grano de café hondureño tostado',
        'Agua caliente',
        'Leche/Azúcar (Opcional)'
      ],
      calorias: 15,
      tiempoPreparacion: '2-3 min',
      icono: Icons.coffee,
    ),
    Producto(
      id: 'prod_05',
      nombre: 'Snack',
      descripcion:
          'Empaque individual de tajaditas crujientes (plátano verde, chicharrones o papas fritas saladas). El complemento perfecto para un antojito rápido.',
      precio: 25.00,
      categoria: 'Snacks',
      ingredientes: ['Plátano / Papa / Maíz', 'Aceite vegetal', 'Sal fina'],
      calorias: 210,
      tiempoPreparacion: 'Inmediato',
      icono: Icons.fastfood,
    ),
    Producto(
      id: 'prod_06',
      nombre: 'Pastelitos de pollo',
      descripcion:
          'Crujientes pastelitos dorados de maíz fritos al instante, rellenos de un suculento guiso de pollo con papas finamente sazonadas con hierbas y especias.',
      precio: 10.00,
      categoria: 'Antojitos',
      ingredientes: [
        'Masa de maíz sazonada',
        'Pollo desmenuzado',
        'Papas en cubos',
        'Cebolla y cilantro'
      ],
      calorias: 240,
      tiempoPreparacion: '5-7 min',
      icono: Icons.bakery_dining,
    ),
    Producto(
      id: 'prod_07',
      nombre: 'Pollo chuco',
      descripcion:
          'Auténtico pollo frito estilo sazonado al estilo norteño, empanizado y dorado hasta quedar súper crujiente. Servido sobre una abundante cama de tajadas de guineo verde frito, encurtido de cebolla morada, repollo fresco y la emblemática aderezo salsa rosa especial.',
      precio: 100.00,
      categoria: 'Platos Fuertes',
      ingredientes: [
        'Piezas de pollo marinado y empanizado',
        'Tajadas de guineo verde',
        'Repollo rallado fresco',
        'Encurtido de cebolla morada',
        'Salsa aderezo especial'
      ],
      calorias: 750,
      tiempoPreparacion: '12-15 min',
      icono: Icons.kebab_dining,
    ),
    Producto(
      id: 'prod_08',
      nombre: 'Coca Cola Personal',
      descripcion:
          'Bebida gaseosa refrescante Coca Cola helada en presentación personal de 500ml. Perfecta para extinguir el calor.',
      precio: 25.00,
      categoria: 'Bebidas',
      ingredientes: ['Agua carbonatada', 'Azúcar', 'Saborizantes naturales'],
      calorias: 180,
      tiempoPreparacion: 'Inmediato',
      icono: Icons.local_drink,
    ),
  ];

  static Producto? obtenerPorNombre(String nombre) {
    final nombreLimpio = nombre.trim().toLowerCase();
    for (final prod in listaProductos) {
      if (prod.nombre.toLowerCase() == nombreLimpio) {
        return prod;
      }
    }
    // Intenta coincidencia parcial
    for (final prod in listaProductos) {
      if (nombreLimpio.contains(prod.nombre.toLowerCase()) ||
          prod.nombre.toLowerCase().contains(nombreLimpio)) {
        return prod;
      }
    }
    return null;
  }
}
