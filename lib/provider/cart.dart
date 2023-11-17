// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './carts_structure.dart';

class Cart with ChangeNotifier {
  Map<String, CartStructure> _items = {};

  Map<String, CartStructure> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItemValue) {
      total += cartItemValue.price * cartItemValue.quantity;
      // total += double.parse(cartItemValue.price as String) *
    });
    return total;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      // update quantity
      _items.update(
        productId,
        (existingCartStructure) => CartStructure(
          id: existingCartStructure.id,
          title: existingCartStructure.title,
          price: existingCartStructure.price,
          quantity: existingCartStructure.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartStructure(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removesingleItem(String productId) {
    // check if  item is 0
    if (!_items.containsKey(productId)) {
      return;
    }
    // check if item is present
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingItem) => CartStructure(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity - 1,
              price: existingItem.price));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }
}
