import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this.authToken, this.userId, this._orders);
  loadOrders(BuildContext context) async {
    var url =
        'https://my-first-project-6223d.firebaseio.com/orders/$userId.json?auth=$authToken';
    var urlProducts =
        'https://my-first-project-6223d.firebaseio.com/orderProducts.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final response2 = await http.get(urlProducts);
      List<OrderItem> loadedOrders = [];
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;
      print(response.body);
      final extractedProducts =
          json.decode(response2.body) as Map<String, dynamic>;
      print(response2.body);
      extractedOrders.forEach((orderId, value) {
        List<CartItem> orderProducts = [];
        extractedProducts.forEach((productId, value) {
          if (value['idOrder'] == orderId) {
            Product pr = Provider.of<Products>(context, listen: false)
                .items
                .firstWhere((element) {
              return element.id == value['idProduct'];
            });
            CartItem item = new CartItem(
                id: pr.id,
                price: pr.price,
                quantity: value['quantity'],
                name: pr.name,
                imageUrl: pr.imageUrl);
            orderProducts.add(item);
          }
        });
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: value['amount'],
          datetime: DateTime.parse(value['date']),
          products: orderProducts,
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<http.Response> addOrder(
      List<CartItem> cartProducts, double total, BuildContext context) async {
    var url =
        'https://my-first-project-6223d.firebaseio.com/orders/$userId.json?auth=$authToken';
    var url2 =
        'https://my-first-project-6223d.firebaseio.com/orderProducts.json?auth=$authToken';
    if (cartProducts.length > 0) {
      var responseId;
      try {
        final response = await http.post(
          url,
          body: json.encode({
            'amount': total,
            'numberOfProducts': cartProducts.length,
            'date': DateTime.now().toString(),
          }),
        );
        final products = Provider.of<Products>(context);
        for (int i = 0; i < cartProducts.length; i++) {
          responseId = await http.post(
            url2,
            body: json.encode({
              'idOrder': json.decode(response.body)['name'],
              'idProduct': cartProducts[i].id,
              'quantity': cartProducts[i].quantity,
            }),
          );
          await http.patch(
            'https://my-first-project-6223d.firebaseio.com/products/${cartProducts[i].id}.json?auth=$authToken',
            body: json.encode(
              {
                'quantity': (products.items
                        .firstWhere(
                            (element) => element.id == cartProducts[i].id)
                        .quantity -
                    cartProducts[i].quantity),
              },
            ),
          );
        }
        _orders.insert(
          0,
          OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            datetime: DateTime.now(),
          ),
        );
        products.fetchAndSetProducts();
        notifyListeners();
        return responseId;
      } catch (error) {
        print(error);
      }
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Order failed'),
            content: Text(
                'There is no product in your wish list. Please add products before ordering.'),
            actions: [
              CupertinoDialogAction(
                child: Text('Okey'),
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(false),
              )
            ],
          );
        },
      );
    }
  }
}
