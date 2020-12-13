import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'auth.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;
  List<String> categories = ['All'];
  List<Product> _removedItems = [];
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   name: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   quantity: 100,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   name: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   quantity: 300,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   name: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   quantity: 170,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   name: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   quantity: 80,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  Products(this.authToken, this.userId, this._items);
  var _showFavoritesOnly = false;
  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((element) => element.isFavorite).toList();
    }
    return [..._items];
  }

  List<Product> get removedItems {
    return [..._removedItems];
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> restoreItem(String id) async {
    final prodIndex = _removedItems.indexWhere((element) => element.id == id);
    Product pr = _removedItems[prodIndex];
    _removedItems.removeAt(prodIndex);
    final url =
        'https://my-first-project-6223d.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': pr.name,
            'description': pr.description,
            'imageUrl': pr.imageUrl,
            'cagegory': pr.category,
            'price': pr.price,
            'quantity': pr.quantity,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        name: pr.name,
        price: pr.price,
        description: pr.description,
        category: pr.category,
        quantity: pr.quantity,
        imageUrl: pr.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    notifyListeners();
  }

  void update(Auth auth) {
    authToken = auth.token;
  }

  Future<void> removeProduct(String id, BuildContext ctx) async {
    final url =
        'https://my-first-project-6223d.firebaseio.com/products/$id.json?auth=$authToken';
    int index = _items.indexWhere((element) => element.id == id);

    await showDialog(
      context: ctx,
      builder: (ctx) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: new Text('Do you wanna delete this item?'),
            content: new Text(
                'This item will be stored in deleted items ,you can restore it before shutting the application.'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text('Yes'),
                onPressed: () {
                  _removedItems.add(_items[index]);
                  final idx = _removedItems.indexOf(_items[index]);
                  _items.removeAt(index);
                  http.delete(url).catchError((_) {
                    _items.insert(index, _removedItems[idx]);
                    _removedItems.removeAt(idx);
                  });
                  Navigator.of(ctx).pop(true);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Cancel'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: new Text('Do you wanna delete this item?'),
            content: new Text(
                'This item will be stored in deleted items ,you can restore it before shutting the application.'),
            actions: [
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  _removedItems.add(_items[index]);
                  http.delete(url);
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
            ],
          );
        }
      },
    );
    notifyListeners();
  }

  editProduct(Product editedProduct) async {
    Product pr = _items.firstWhere((element) => element.id == editedProduct.id);
    int index = _items.indexOf(pr);
    if (index >= 0) {
      final url =
          'https://my-first-project-6223d.firebaseio.com/products/${pr.id}.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': editedProduct.name,
            'description': editedProduct.description,
            'price': editedProduct.price,
            'category': editedProduct.category,
            'quantity': editedProduct.quantity,
            'imageUrl': editedProduct.imageUrl,
          }));
      _items.removeAt(index);
      _items.insert(index, editedProduct);
      notifyListeners();
    }
  }

  Future<void> addProduct(Product pr) async {
    final url =
        'https://my-first-project-6223d.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': pr.name,
            'description': pr.description,
            'imageUrl': pr.imageUrl,
            'category': pr.category,
            'price': pr.price,
            'quantity': pr.quantity,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        name: pr.name,
        price: pr.price,
        description: pr.description,
        category: pr.category,
        quantity: pr.quantity,
        imageUrl: pr.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    // _items.add(value);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://my-first-project-6223d.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://my-first-project-6223d.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((prodId, value) {
        loadedProducts.add(
          Product(
            id: prodId,
            name: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            category: value['category'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            quantity: value['quantity'],
            price: value['price'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void loadCategories(List<String> cats) {
    categories = cats;
  }
}
