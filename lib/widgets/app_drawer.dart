import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/deleted_items_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/settings_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AppBar(
                backgroundColor: Theme.of(context).accentColor,
                title: Text('My Shop APP'),
                automaticallyImplyLeading: false,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('Shop'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Orders'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.local_mall),
                title: Text('Products'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductsScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Deleted items'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(DeletedItemsScreen.routeName);
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, SettingsScreen.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    final prov = Provider.of<Auth>(context, listen: false);
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/');
                    prov.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
