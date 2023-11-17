import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/user_product';

  Future<void> _refreshproduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productdata = Provider.of<ProductsProvider>(context);
    print('rebuilding....');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products!'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routname);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshproduct(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshproduct(context),
                      child: Consumer<ProductsProvider>(
                        builder: (ctx, productdata, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productdata.item.length,
                            itemBuilder: (_, index) => Column(
                              children: [
                                UserProductItem(
                                  productdata.item[index].id,
                                  productdata.item[index].title,
                                  productdata.item[index].imageUrl,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
    );
  }
}
