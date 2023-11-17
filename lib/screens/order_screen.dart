// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_items.dart';
import '../provider/order.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routname = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderfuture;
  Future _obtainorerfuture() {
    return Provider.of<Orders>(context, listen: false).FetchandSetO();
  }

  @override
  void initState() {
    _orderfuture = _obtainorerfuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orderfuture,
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (datasnapshot.error != null) {
              print(
                  datasnapshot.error); // Print the error for debugging purposes
              return Center(
                child: Text('Error occurred while fetching orders.'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderdata, child) => ListView.builder(
                  itemBuilder: (context, Index) =>
                      OrderItemm(orderdata.orders[Index]),
                  itemCount: orderdata.orders.length,
                ),
              );
            }
          },
        ));
  }
}
