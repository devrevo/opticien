import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class RestoredItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;

  RestoredItem({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  Provider.of<Products>(context, listen: false).restoreItem(id);
                  Navigator.of(context).pushNamed('/');
                }),
          ],
        ),
      ),
    );
  }
}
