import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  Widget showMessage(BuildContext ctx, String code) {
    if (Platform.isIOS) {
      print('TestIOS');
      return CupertinoAlertDialog(
        title: new Text('Do you wanna delete this item?'),
        content: new Text(
            '`Your order has been completed. You ll recieve it in the next few days.You can track it By the following Code :' +
                code),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
      );
    } else {
      print('TestOther');
      return AlertDialog(
        title: new Text('Do you wanna delete this item?'),
        content: new Text(
            '`Your order has been completed. You ll recieve it in the next few days.You can track it By the following Code :' +
                code),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.purple, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Text(
                'My Cart',
                style: TextStyle(
                  color: Colors.purple,
                  fontFamily: 'Avenir Next',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                cart.items.length.toString() + ' Items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.deepPurple[300],
                ),
              )
            ],
          ),
        ),
        body: Container(
          color: Colors.grey[50],
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      final cartItem = cart.items.values.toList()[index];
                      final cartKey = cart.items.keys.toList()[index];
                      return CartItemCard(cartItem: cartItem, cartKey: cartKey);
                    },
                    itemCount: cart.items.length,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.13,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        top: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Amount :',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          ),
                          Text(
                            '\$${cart.totalAmount}',
                            style: TextStyle(
                                color: Colors.deepPurple[400], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 25),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.deepPurple[400]),
                        ),
                        color: Colors.deepPurple[400],
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.06,
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<Orders>(context, listen: false)
                              .addOrder(cart.items.values.toList(),
                                  cart.totalAmount, context)
                              .then((response) {
                            cart.clear();
                            print(json.decode(response.body)['name']);
                            showMessage(
                                context, json.decode(response.body)['name']);
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        child: _isLoading
                            ? Platform.isIOS
                                ? CupertinoActivityIndicator()
                                : CircularProgressIndicator()
                            : Text(
                                'Order Now',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
