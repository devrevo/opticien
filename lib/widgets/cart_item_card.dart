import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final String cartKey;
  const CartItemCard({this.cartItem, this.cartKey});

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Products>(context)
        .items
        .firstWhere((element) => element.id == widget.cartKey);
    var quantity = widget.cartItem.quantity;
    return Dismissible(
      key: ValueKey(widget.cartItem.id),
      background: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.red),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        width: 100,
        height: 50,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                    title: new Text("Are you sure ?"),
                    content: new Text(
                        "Do you want to remove the item from the cart ?"),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: new Text("No"),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      CupertinoDialogAction(
                        child: new Text("Yes"),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                    ]);
              } else {
                return AlertDialog(
                  title: Text('Are you sure ?'),
                  content:
                      Text('Do you want to remove the item from the cart ?'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes')),
                  ],
                );
              }
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.cartKey);
      },
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.35,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FittedBox(
                      child: Image.network(widget.cartItem.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.width * 0.32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Avenir Light',
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "\$${widget.cartItem.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.deepPurple[300],
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                              text: " x ${widget.cartItem.quantity}",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 13)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\$${widget.cartItem.price * widget.cartItem.quantity}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepPurple[300],
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        MaterialButton(
                          minWidth: 5,
                          color: Colors.grey[100],
                          onPressed: () {
                            setState(() {
                              if (quantity != 0) {
                                quantity--;
                                widget.cartItem.update(quantity);
                              }
                            });
                            cart.notifyListeners();
                          },
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 10),
                        MaterialButton(
                          minWidth: 5,
                          color: Colors.grey[100],
                          onPressed: () {
                            if (widget.cartItem.quantity <=
                                product.quantity - 1) {
                              setState(() {
                                quantity++;
                                widget.cartItem.update(quantity);
                              });
                              cart.notifyListeners();
                            }
                          },
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
