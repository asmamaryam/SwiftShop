import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart';
import 'dart:math';

class OrderItemm extends StatefulWidget {
  final OrderItem order;
  OrderItemm(this.order);

  @override
  State<OrderItemm> createState() => _OrderItemmState();
}

class _OrderItemmState extends State<OrderItemm> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      // take expanded as trigger
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 500) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 10, 180)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${e.quantity} X \$${e.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
