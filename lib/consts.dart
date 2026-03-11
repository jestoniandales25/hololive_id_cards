import 'package:flutter/material.dart';

final List<Product> PRODUCTS = [
  Product(id: '1', name: 'Product 1', price: 10.0, color: Colors.red),
  Product(id: '2', name: 'Product 2', price: 20.0, color: Colors.blue),
  Product(id: '3', name: 'Product 3', price: 30.0, color: Colors.green),
];

class Product {
  final String id;
  final String name;
  final double price;
  final Color color;

  Product({required this.id, required this.name, required this.price, required this.color});
}
