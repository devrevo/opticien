import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  String category;
  bool isFavorite;
  String authToken;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.quantity,
    @required this.imageUrl,
    this.category = '',
    this.isFavorite = false,
  });
  void _setFavValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(Product product, String token,
      String userId, BuildContext context) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url =
          'https://my-first-project-6223d.firebaseio.com/userFavorites/$userId/${product.id}.json?auth=$token';
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
