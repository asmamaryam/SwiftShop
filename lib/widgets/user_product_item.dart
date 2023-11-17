// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../provider/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final sacfflods = ScaffoldMessenger.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routname, arguments: id);
                },
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                onPressed: () async {
                  bool deletionSuccessful = false;
                  try {
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .deleteProduct(id);
                    deletionSuccessful = true;
                  } catch (error) {
                    // Handle specific error, if needed
                  }

                  if (deletionSuccessful) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Item successfully deleted!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ));
  }
}
