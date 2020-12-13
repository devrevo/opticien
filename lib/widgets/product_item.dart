import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final auth = Provider.of<Auth>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final fav = product.isFavorite;
    final _random = Random();
    final r = 1 + _random.nextInt(6 - 1);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: Container(
        height: 150,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Stack(
            children: [
              Container(
                height: 150,
                width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: FadeInImage(
                    placeholder: AssetImage(
                        'assets/images/placeholders/placeholder-$r.png'),
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeIn,
                    fadeOutCurve: Curves.easeInOut,
                    fadeOutDuration: Duration(milliseconds: 300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 140, bottom: 15),
                child: Container(
                  width: (MediaQuery.of(context).size.width * 0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            product.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 3),
                          product.quantity != null && product.quantity >= 10
                              ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      right: 4,
                                      top: 2,
                                      bottom: 2,
                                    ),
                                    child: Text(
                                      'In stock',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                              : product.quantity == 0
                                  ? Container(
                                      color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          top: 2,
                                          bottom: 2,
                                        ),
                                        child: Text(
                                          'There is no item left.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          top: 2,
                                          bottom: 2,
                                        ),
                                        child: Text(
                                          'only ${product.quantity} remains in the shop',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    IconButton(
                      icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                      onPressed: () {
                        product.toggleFavoriteStatus(
                            product, auth.token, auth.userId, context);
                      },
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        cart.addItem(product.id, product.price, product.name, 1,
                            product.quantity, product.imageUrl);
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Item added to cart!',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                            action: SnackBarAction(
                                label: 'UNDO',
                                textColor: Colors.white,
                                onPressed: () {
                                  cart.removeSingleItem(product.id);
                                }),
                          ),
                        );
                      },
                      color: Theme.of(context).accentColor,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: FadeInImage(
            placeholder:
                AssetImage('assets/images/placeholders/placeholder-$r.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
            fadeInCurve: Curves.easeIn,
            fadeOutCurve: Curves.easeInOut,
            fadeOutDuration: Duration(milliseconds: 300),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavoriteStatus(
                  product, auth.token, auth.userId, context);
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.name);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Item added to cart!',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );*/
