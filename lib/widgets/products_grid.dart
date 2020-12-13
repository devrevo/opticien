import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final String cat;
  final String value;
  final bool _isSearch;

  ProductsGrid(this.value, this._isSearch, this.cat);
  Future<void> _refreshProduct(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<Products>(context);
    List<Product> products = [];
    List<Product> productSearch = [];
    List<Product> catProducts = [];

    if (cat == 'All') {
      catProducts = productList.items;
    } else {
      catProducts = productList.items.where((element) {
        print(element.category);
        if (element.category == '' || element.category == null) {
          return false;
        } else {
          return cat.toLowerCase() == element.category.toLowerCase();
        }
      }).toList();
    }
    if (value == '') {
      productSearch = productList.items;
    } else {
      productSearch = productList.items.where((element) {
        var productTitle = element.name.toLowerCase();
        return productTitle.startsWith(value.toLowerCase());
      }).toList();
    }
    productSearch.forEach((element) {
      catProducts.forEach((catElement) {
        if (catElement == element) {
          products.add(element);
        }
      });
    });
    return RefreshIndicator(
      onRefresh: () => _refreshProduct(context),
      child: products.length != 0
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: products[index],
                  child: ProductItem(),
                );
              })
          : Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Card(
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            'No items matching your search keyword : ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            value,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
