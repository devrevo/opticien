import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final String authToken;
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  Cart(this.authToken, this._items);
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double updateTotalAmount() {
    notifyListeners();
    return totalAmount;
  }

  void addItem(String id, double price, String name, int quantity,
      int productQuantity, String productImage) {
    if (_items.containsKey(id)) {
      _items.update(id, (existinfCartItem) {
        if (existinfCartItem.quantity + quantity <= productQuantity) {
          return CartItem(
              id: id,
              name: existinfCartItem.name,
              quantity: existinfCartItem.quantity + quantity,
              price: existinfCartItem.price,
              imageUrl: existinfCartItem.imageUrl);
        } else {
          return CartItem(
            id: id,
            name: existinfCartItem.name,
            quantity: productQuantity,
            price: existinfCartItem.price,
            imageUrl: existinfCartItem.imageUrl,
          );
        }
      });
    } else {
      if (quantity == 0) {
        _items.putIfAbsent(
          id,
          () => CartItem(
              id: id,
              name: name,
              quantity: 1,
              price: price,
              imageUrl: productImage),
        );
      } else {
        _items.putIfAbsent(
          id,
          () => CartItem(
              id: id,
              name: name,
              quantity: quantity,
              price: price,
              imageUrl: productImage),
        );
      }
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            name: value.name,
            price: value.price,
            quantity: value.quantity - 1,
            imageUrl: value.imageUrl),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String name;
  int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.name,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
  });

  void update(int quantity) {
    this.quantity = quantity;
  }
}
