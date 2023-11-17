// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../provider/cart.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../provider/product_provider.dart';

//  datatype represent number of constant value
enum fiterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFAv = false;
  var _isIn = true;
  var _isloading = false;

  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).fetchset();
    // Future.delayed(Duration: zero).then((_) {
    //   Provider.of<ProductsProvider>(context).fetchset();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isIn) {
      setState(() {
        _isloading = true;
      });

      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isloading = false;
        });
      }).catchError((error) {
        setState(() {
          _isloading = false;
        });
        // Handle the error here (e.g., show an error message)
        print('Error fetching data: $error');
      });
    }
    _isIn = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (fiterOption selectedvalue) {
              setState(() {
                if (selectedvalue == fiterOption.Favorite) {
                  _showFAv = true;
                } else {
                  _showFAv = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text(
                    'Only Favorites',
                  ),
                  value: fiterOption.Favorite),
              PopupMenuItem(
                  child: Text(
                    'Show All',
                  ),
                  value: fiterOption.All),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badgee(
                child: ch as Widget,
                value: cart.itemCount.toString(),
                color: Colors.amber),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routname);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFAv),
    );
  }
}
