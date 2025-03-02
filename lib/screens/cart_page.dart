import 'package:flutter/material.dart';

// Página secundaria que muestra la lista de productos en el carrito de compras
class CartPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>> cart; // Mapa que almacena los productos añadidos al carrito

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    // Calcula el total a pagar sumando el precio de cada producto por su cantidad
    double total = cart.values.fold<double>(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de Compra')), // Barra de navegación con título
      body: cart.isEmpty
          ? const Center(child: Text('El carrito está vacío')) // Muestra un mensaje si el carrito está vacío
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: cart.values.map((product) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.asset(product['image'], width: 50), // Imagen del producto
                          title: Text(product['name']), // Nombre del producto
                          subtitle: Text('${product['price']}€ \nUnidades: ${product['quantity']}'), // Precio y cantidad
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove), // Botón para disminuir cantidad
                                onPressed: () {
                                  if (product['quantity'] > 1) {
                                    product['quantity']--; // Reduce la cantidad si es mayor a 1
                                  } else {
                                    cart.remove(product['name']); // Elimina el producto si la cantidad es 1
                                  }
                                  (context as Element).markNeedsBuild(); // Fuerza la actualización de la UI
                                },
                              ),
                              Text('${product['quantity']}'), // Muestra la cantidad actual del producto
                              IconButton(
                                icon: const Icon(Icons.add), // Botón para aumentar cantidad
                                onPressed: () {
                                  product['quantity']++; // Aumenta la cantidad del producto
                                  (context as Element).markNeedsBuild(); // Refresca la UI
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Sección que muestra el total a pagar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.blue.shade100, // Color de fondo del total a pagar
                    elevation: 3, // Sombra del card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bordes redondeados
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            '${total.toStringAsFixed(2)}€', // Muestra el total con 2 decimales
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