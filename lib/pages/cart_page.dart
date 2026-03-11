import 'package:flutter/material.dart';
import 'package:hololive_id_cards/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Cart'),
    );
  }

  Widget _buildUI() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        cartProvider.removeItem(item);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }
    );
  }
}