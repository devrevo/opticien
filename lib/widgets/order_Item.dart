import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as o;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final o.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacityTitleAnimation;
  Animation<Offset> _slideAnimation;

  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _opacityTitleAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          constraints: BoxConstraints(
            maxHeight: _expanded
                ? max(widget.order.products.length * 60.0 + 20,
                    widget.order.products.length * 60.0 + 140)
                : 120,
          ),
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 4,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('dd').format(widget.order.datetime),
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateFormat('EEEE').format(widget.order.datetime),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: MediaQuery.of(context).size.height * 0.1 - 20,
                      color: Colors.grey[400],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      height: 100,
                      width: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).size.width / 4) -
                          30,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                '\$${(widget.order.amount)}',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(widget.order.id),
                              trailing: IconButton(
                                icon: _expanded
                                    ? Icon(Icons.expand_less)
                                    : Icon(Icons.expand_more),
                                onPressed: () {
                                  setState(() {
                                    _expanded = !_expanded;
                                    if (_expanded) {
                                      _controller.reverse();
                                    } else {
                                      _controller.forward();
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_expanded)
                  Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    height: min(widget.order.products.length * 60.0 + 20,
                        widget.order.products.length * 60.0 + 140),
                    child: FadeTransition(
                      alwaysIncludeSemantics: true,
                      opacity: _opacityTitleAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: ListView(
                          children: widget.order.products.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          NetworkImage(product.imageUrl),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontFamily: 'Avenir Light',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          ' \$${product.price} x${product.quantity}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
//  ListTile(
//                 title: Text('\$${(widget.order.amount)}'),
//                 subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
//                     .format(widget.order.datetime)),
//                 trailing: IconButton(
//                   icon: _expanded
//                       ? Icon(Icons.expand_less)
//                       : Icon(Icons.expand_more),
//                   onPressed: () {
//                     setState(() {
//                       _expanded = !_expanded;
//                     });
//                   },
//                 ),
//               ),
