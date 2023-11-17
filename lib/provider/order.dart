// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './carts_structure.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartStructure> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authtoken;
  final String userId;
  List<OrderItem> _order = [];

  Orders(this.authtoken, this.userId, this._order);
  List<OrderItem> get orders {
    return [..._order];
  }

//  fetch data from the web

  Future<void> FetchandSetO() async {
    final url = Uri.parse(
        'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/order/$userId.json?auth=$authtoken');
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extracteddata = json.decode(response.body) as Map<String, dynamic>;
    if (extracteddata == null) {
      return;
    }
    extracteddata.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: orderData['datetime'] != null
              ? DateTime.parse(orderData['datetime'])
              : DateTime.now(),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartStructure(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  //  add all the content of the card into one order
  Future<void> addOrder(List<CartStructure> cartproducts, double total) async {
    final url = Uri.parse(
        'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/order/$userId.json?auth=$authtoken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartproducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _order.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartproducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
