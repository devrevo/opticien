import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'dart:io';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String name;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.price,
    @required this.quantity,
    @required this.name,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
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
        color: Colors.red,
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
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('\$$price'),
                    ),
                  ),
                ),
                title: Text(name),
                subtitle: Text('Total: \$${(price * quantity)}'),
                trailing: Text('$quantity x'),
              )),
        ),
      ),
    );
  }
}
