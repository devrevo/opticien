import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/restored_item.dart';

import 'edit_screen_product.dart';

class DeletedItemsScreen extends StatelessWidget {
  static String routeName = '/deleted';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Deleted Products'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => null,
          child: productsData.removedItems.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No deleted items'),
                        ],
                      ),
                    ),
                  ))
              : Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          RestoredItem(
                            id: productsData.removedItems[index].id,
                            name: productsData.removedItems[index].name,
                            imageUrl: productsData.removedItems[index].imageUrl,
                          ),
                          Divider(),
                        ],
                      );
                    },
                    itemCount: productsData.removedItems.length,
                  ),
                ),
        ));
  }
}
