import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_screen_product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  UserProductItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
        height: 100,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(150),
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    )),
              ),
            ),
            Container(
              width: 1,
              height: MediaQuery.of(context).size.height * 0.1 - 20,
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.41,
                    child: Text(
                      name,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      '\$' + price.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EditProductScreen.routeName,
                              arguments: id);
                        }),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<Products>(context, listen: false)
                              .removeProduct(id, context);
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ListTile(
//       title: Text(name),
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(imageUrl),
//       ),
//       trailing: Container(
//         width: 100,
//         child: Row(
//           children: [
//
//           ],
//         ),
//       ),
//     );
