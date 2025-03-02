import 'package:flutter/material.dart';
import 'package:flutter_first_app/screens/cart_page.dart';

// Página principal que muestra la lista de productos disponibles en la tienda
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

// Clase que maneja el estado de la lista de productos y el carrito de compras
class _ProductListPageState extends State<ProductListPage> {
  // Lista de productos disponibles en la tienda, cada producto tiene un nombre, imagen y precio
  final List<Map<String, dynamic>> _products = [
    {'name': 'Silla de Oficina', 'image': 'assets/chair.png', 'price': 96.0},
    {'name': 'Tenedor de Plata', 'image': 'assets/fork.png', 'price': 3.0},
    {'name': 'Lámpara', 'image': 'assets/lamp.png', 'price': 20.0},
    {'name': 'Lámpara de Pie', 'image': 'assets/standLamp.png', 'price': 65.0},
    {'name': 'Sofá', 'image': 'assets/sofa.png', 'price': 249.99},
    {'name': 'Cuchara de Plata', 'image': 'assets/spoon.png', 'price': 3.0},
    {'name': 'Mesa Rústica', 'image': 'assets/table.png', 'price': 199.95},
    {'name': 'Vasija', 'image': 'assets/vase.png', 'price': 14.0},
  ];

  // Mapa que almacena los productos añadidos al carrito, donde la clave es el nombre del producto
  final Map<String, Map<String, dynamic>> _cart = {};

  // Variable para almacenar el término de búsqueda introducido por el usuario
  String _searchQuery = '';

  // Método para agregar un producto al carrito
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      if (_cart.containsKey(product['name'])) {
        // Si el producto ya está en el carrito, se incrementa su cantidad
        _cart[product['name']]!['quantity'] += 1;
      } else {
        // Si el producto no está en el carrito, se añade con cantidad 1
        _cart[product['name']] = {
          'name': product['name'],
          'image': product['image'],
          'price': product['price'],
          'quantity': 1,
        };
      }
    });
  }

  // Método que construye la interfaz de la pantalla de productos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 117, 174, 221),
        title: TextField(
          decoration: const InputDecoration(
            icon: Icon(Icons.search), // Ícono de búsqueda
            hintText: 'Buscar productos...',
            border: InputBorder.none, // Sin borde para un diseño limpio
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase(); // Actualiza la consulta de búsqueda
            });
          },
        ),
        actions: [
          Stack(
            children: [
              // Icono del carrito de compras en la esquina superior derecha
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cart: _cart), // Navega a la página del carrito
                    ),
                  );
                },
              ),
              // Muestra un indicador con la cantidad total de productos en el carrito si no está vacío
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red, // Color rojo para resaltar el indicador
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cart.values.fold<int>(0, (sum, item) => sum + (item['quantity'] as int))}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          // Define la estructura del grid con 2 columnas
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Cantidad de columnas
            crossAxisSpacing: 10, // Espacio horizontal entre elementos
            mainAxisSpacing: 10, // Espacio vertical entre elementos
            childAspectRatio: 0.75, // Relación de aspecto para el tamaño de los elementos
          ),
          // Filtra los productos según la búsqueda
          itemCount: _products
              .where((product) =>
                  product['name'].toLowerCase().contains(_searchQuery))
              .length,
          itemBuilder: (context, index) {
            // Genera la lista filtrada de productos
            final filteredProducts = _products
                .where((product) =>
                    product['name'].toLowerCase().contains(_searchQuery))
                .toList();
            final product = filteredProducts[index];

            // Tarjeta que representa un producto individual
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              elevation: 3, // Sombra para darle efecto elevado
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del producto
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.asset(
                        product['image'],
                        width: double.infinity,
                        fit: BoxFit.cover, // Ajusta la imagen al contenedor
                      ),
                    ),
                  ),
                  // Nombre del producto
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Precio del producto
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${product['price']}€',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ),
                  // Botón para añadir el producto al carrito
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity, // Botón ocupa todo el ancho del card
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product), // Llama a la función para agregar al carrito
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Añadir al carrito'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
