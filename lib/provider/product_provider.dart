// ignore_for_file: non_constant_identifier_names, avoid_print, use_rethrow_when_possible, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl_browser.dart';
import 'dart:convert';

import './products.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _item = [];
  // Get token from auth and productprovider(main) to use in the http request
  final String authtoken;
  final String userId;
  // ProductsProvider(this.authtoken, this.userId, this._item);
  ProductsProvider(this.authtoken, this.userId, List<Product> itemList) {
    _item = List.from(itemList);
  }

  List<Product> get item {
    return [..._item];
  }

/////////////////////////////////
  List<Product> get favitem {
    return _item.where((element) => element.isFavorite).toList();
  }

  Product findbyId(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  // fetch(get) data
  Future<void> fetchAndSetProducts([bool filterbyUser = false]) async {
    final filterString =
        filterbyUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/product_provider.json?auth=$authtoken$filterString');

    try {
      final response = await http.get(url);

      if (response.body == null || response.body.isEmpty) {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url = Uri.parse(
          'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/userfavorite/$userId.json?auth=$authtoken');
      final favoriteResponse = await http.get(url);
      final favoritedata = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            // price: productData['price'],
            price: double.parse(productData['price'].toString()),

            isFavorite:
                favoritedata == null ? false : favoritedata[productId] ?? false,
          ),
        );
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // store(post) data
  Future<void> addProduct(Product PProduct) async {
    final url = Uri.parse(
        'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/product_provider.json?auth=$authtoken');
    try {
      final respone = await http.post(
        url,
        body: json.encode({
          'title': PProduct.title,
          'description': PProduct.description,
          'imageUrl': PProduct.imageUrl,
          'price': PProduct.price,
          'creatorId': userId,
        }),
      );
      final newproduct = Product(
        title: PProduct.title,
        description: PProduct.description,
        imageUrl: PProduct.imageUrl,
        price: PProduct.price,
        id: json.decode(respone.body)['name'],
      );
      _item.add(newproduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // edit product
  Future<void> UpdateProduct(String id, Product newproduct) async {
    final proIndex = _item.indexWhere((element) => element.id == id);

    print('ID to update: $id');
    print('Indexes: $_item.map((e) => e.id).toList()}');
    print('Index found: $proIndex');

    if (proIndex >= 0) {
      final url = Uri.parse(
          'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/product_provider/$id.json?auth=$authtoken');

      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'description': newproduct.description,
            'imageUrl': newproduct.imageUrl,
            'price': newproduct.price,
            'title': newproduct.title,
          }),
        );

        if (response.statusCode == 200) {
          _item[proIndex] = newproduct;
          notifyListeners();
        } else {
          // Handle HTTP request error, if needed
          print('HTTP Request failed with status code: ${response.statusCode}');
        }
      } catch (error) {
        // Handle other errors, if any
        print('Error occurred: $error');
      }
    } else {
      print("product not found");
    }
  }

  // Future<void> UpdateProduct(String id, Product newproduct) async {
  //   final proIndex = _item.indexWhere((element) => element.id == id);
  //   if (proIndex >= 0) {
  //     final url = Uri.parse(
  //         'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/product_provider/$id.json?auth=$authtoken');

  //     await http.patch(url,
  //         body: json.encode({
  //           'description': newproduct.description,
  //           'imageUrl': newproduct.imageUrl,
  //           'price': newproduct.price,
  //           'title': newproduct.title,
  //         }));

  //     _item[proIndex] = newproduct;
  //     notifyListeners();
  //   } else {
  //     print('Product not found');
  //   }
  // }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://fire-flutter-3c59d-default-rtdb.firebaseio.com/product_provider/$id.json?auth=$authtoken');
    final existingPrductIndex = _item.indexWhere((element) => element.id == id);
    Product existingPro = _item[existingPrductIndex];
    _item.removeAt(existingPrductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(existingPrductIndex, existingPro);
      notifyListeners();
      throw HttpException('message');
    }
    existingPro = "delete" as Product;
  }
}
