import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget principal de la aplicación
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductListPage(),
    );
  }
}

// Página principal con la lista de productos
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

// Lista de productos disponibles en la tienda
class _ProductListPageState extends State<ProductListPage> {
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

  // Lista con los elementos en el carrito de compar
  final Map<String, Map<String, dynamic>> _cart = {};
  String _searchQuery = '';

  // Método parta agregar un producto al carrito, si ya esta solo suma a la cantidad, sino añade el producto
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      if (_cart.containsKey(product['name'])) {
        _cart[product['name']]!['quantity'] += 1;
      } else {
        _cart[product['name']] = {
          'name': product['name'],
          'image': product['image'],
          'price': product['price'],
          'quantity': 1,
        };
      }
    });
  }

  // Build de la página principal de la tienda con una app bar y grid de objetos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 117, 174, 221),
        title: TextField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.search),
            hintText: 'Buscar productos...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cart: _cart),
                    ),
                  );
                },
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: _products
              .where((product) =>
                  product['name'].toLowerCase().contains(_searchQuery))
              .length,
          itemBuilder: (context, index) {
            final filteredProducts = _products
                .where((product) =>
                    product['name'].toLowerCase().contains(_searchQuery))
                .toList();
            final product = filteredProducts[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10)),
                      child: Image.asset(
                        product['image'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${product['price']}€',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product),
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

// Página secundaria con la lista de productos comprados, sus unidades y precio total
class CartPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.values.fold<double>(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de Compra')),
      body: cart.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: cart.values.map((product) {
                      return Card(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.asset(product['image'], width: 50),
                          title: Text(product['name']),
                          subtitle: Text('${product['price']}€ \nUnidades: ${product['quantity']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (product['quantity'] > 1) {
                                    product['quantity']--;
                                  } else {
                                    cart.remove(product['name']);
                                  }
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                              Text('${product['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  product['quantity']++;
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.blue.shade100,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          const Text(
                            'Total a Pagar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${total.toStringAsFixed(2)}€',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}