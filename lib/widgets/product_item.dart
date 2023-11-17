// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final productvariable = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    // getting token from authdata
    final authdata = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(productvariable.isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              productvariable.toggleFavoriteStatus(
                  authdata.token.toString(), authdata.userId);
            },
          ),
          title: Text(
            productvariable.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(productvariable.id, productvariable.title,
                  productvariable.price as double);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added to the Cart!',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removesingleItem(productvariable.id);
                  },
                ),
              ));
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.rotename,
              arguments: productvariable.id,
            );
          },
          child: Hero(
            tag: productvariable.id,
            child: FadeInImage(
              placeholder:
                  AssetImage('assests/images/289 product-placeholder.png'),
              image: NetworkImage(productvariable.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
