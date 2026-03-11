import 'package:flutter/material.dart';
import 'package:hololive_id_cards/consts.dart';
import 'package:hololive_id_cards/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _buildUI(context));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Products'),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return ListView.builder(
      itemCount: PRODUCTS.length,
      itemBuilder: (context, index) {
        final product = PRODUCTS[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          trailing: Checkbox(
            value: cartProvider.items.contains(product),
            onChanged: (value) {
              if (value == true) {
                cartProvider.addItem(product);
              } else {
                cartProvider.removeItem(product);
              }
            },
          ),
        );
      },
    );
  }
}
