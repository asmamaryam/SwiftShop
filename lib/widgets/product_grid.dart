import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../provider/product_provider.dart';

class ProductGrid extends StatelessWidget {
  // get argument from product_overview
  final bool showfav;
  ProductGrid(this.showfav);

  @override
  Widget build(BuildContext context) {
    // provide connection to main changenotiy... to rebuid this function
    final productdata = Provider.of<ProductsProvider>(context);
    final productss = showfav ? productdata.favitem : productdata.item;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productss.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: productss[i],
        child: ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
