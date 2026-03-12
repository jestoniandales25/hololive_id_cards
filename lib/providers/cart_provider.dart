import 'package:flutter/material.dart';
import 'package:hololive_id_cards/consts.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];
 
  List<Product> get items => _items;

  void addItem(Product item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Product item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (total, item) => total + item.price);
  }
}