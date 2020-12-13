import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController backgroundController = ScrollController();
  final ScrollController containerController = ScrollController();
  var _reached = false;
  var quantity = 1;
  @override
  void initState() {
    super.initState();
    containerController.addListener(
      () {
        backgroundController.jumpTo(containerController.offset);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final loadedProduct = Provider.of<Products>(context, listen: false);
    final id = ModalRoute.of(context).settings.arguments as String;

    Product selectedProduct = loadedProduct.findById(id);
    bool fav = selectedProduct.isFavorite;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(selectedProduct.name),
        elevation: 0.0,
      ),
      body: Stack(
        overflow: Overflow.clip,
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.network(
                      selectedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(bottom: 4, left: 20),
                              child: Text(
                                selectedProduct.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 20),
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                selectedProduct.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              color: Colors.white,
                            ),
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        fav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          fav = !fav;
                                        });
                                        selectedProduct.toggleFavoriteStatus(
                                            selectedProduct,
                                            auth.token,
                                            auth.userId,
                                            context);
                                      }),
                                  Divider(),
                                  IconButton(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () {
                                        cart.addItem(
                                            selectedProduct.id,
                                            selectedProduct.price,
                                            selectedProduct.name,
                                            quantity,
                                            selectedProduct.quantity,
                                            selectedProduct.imageUrl);
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$ ' + selectedProduct.price.toString(),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                minWidth: 10,
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (quantity > 0) {
                                    setState(() {
                                      _reached = false;
                                      quantity--;
                                    });
                                  }
                                },
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    color: Colors.white,
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
                                minWidth: 10,
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (quantity <=
                                      selectedProduct.quantity - 1) {
                                    setState(() {
                                      _reached = false;
                                      quantity++;
                                    });
                                  } else {
                                    setState(() {
                                      _reached = true;
                                    });
                                  }
                                },
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _reached
                      ? Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'Only ${selectedProduct.quantity} left ,if you want more please contact the seller.',
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          ),
                        )
                      : Text('',
                          style: TextStyle(color: Colors.red, fontSize: 10)),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 35, right: 35),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Category : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                            Text(
                                              selectedProduct.category,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Product Description',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8),
                                          child: ListView(children: [
                                            Text(
                                              selectedProduct.description,
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      height: MediaQuery.of(context).size.height * 0.05,
                      minWidth: MediaQuery.of(context).size.width * 0.7,
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        cart.addItem(
                            selectedProduct.id,
                            selectedProduct.price,
                            selectedProduct.name,
                            quantity,
                            selectedProduct.quantity,
                            selectedProduct.imageUrl);
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      child: Text(
                        'Shop Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
