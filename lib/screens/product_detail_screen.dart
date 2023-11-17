import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const rotename = '/Product-detail';

  @override
  Widget build(BuildContext context) {
    final ProductId = ModalRoute.of(context)!.settings.arguments as String;
    // Getting data from productprovider
    final loadedproduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findbyId(ProductId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedproduct.title),
      // ),

      body: CustomScrollView(
        // slivers are scrollable area on the screen
        slivers: <Widget>[
          SliverAppBar(
            // it is given if appbar is image
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedproduct.title),
              background: Hero(
                tag: loadedproduct.id,
                child: Image.network(
                  loadedproduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            //  delegatr tells how to shown the content of list
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  // '\$${double.parse(loadedproduct.price as String)}',
                  '\$${loadedproduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedproduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
