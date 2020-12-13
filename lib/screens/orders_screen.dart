import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/order_Item.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
      Provider.of<Orders>(context, listen: false).loadOrders(context).then((_) {
        setState(() {
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctx) {
    final orderData = Provider.of<Orders>(context);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () =>
              Provider.of<Orders>(context, listen: false).loadOrders(ctx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return OrderItem(orderData.orders[index]);
                        },
                        itemCount: orderData.orders.length,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
