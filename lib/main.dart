import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/deleted_items_screen.dart';
import 'package:shop_app/screens/edit_screen_product.dart';
import 'package:shop_app/screens/settings_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/welcome_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> loadImages(BuildContext context) async {
    await precacheImage(
        AssetImage('assets/images/shapes/shop-signup-logo.jpg'), context);
    await precachePicture(
        ExactAssetPicture(
            (SvgPicture.svgStringDecoder), 'assets/images/shapes/login-1.svg'),
        context);
    await precacheImage(
        AssetImage('assets/images/shapes/shop-logo-3.png'), context);
  }

  @override
  void initState() {
    super.initState();

    precacheImage(AssetImage('assets/images/shapes/shop-logo.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    var _isloading = false;
    final response = loadImages(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                  auth.token,
                  auth.userId,
                  previousProducts == null ? [] : previousProducts.items,
                )),
        ChangeNotifierProxyProvider<Auth, Cart>(
            update: (ctx, auth, previousProducts) => Cart(
                  auth.token,
                  previousProducts == null ? {} : previousProducts.items,
                )),
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousProducts) => Orders(
                  auth.token,
                  auth.userId,
                  previousProducts == null ? [] : previousProducts.orders,
                )),
      ],
      child: Consumer<Auth>(builder: (context, authData, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(240, 241, 241, 1),
            primarySwatch: Colors.purple,
            accentColor: Colors.purple[200],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: authData.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState.toString());
                    if (snapshot.connectionState == ConnectionState.done) {
                      _isloading = true;
                    } else {
                      _isloading = false;
                    }
                    return _isloading ? WelcomeScreen() : SplashScreen();
                  },
                ),
          // home: authData.isAuth
          //     ? ProductOverViewScreen()
          //     : FutureBuilder(
          //         future: authData.tryAutoLogin(),
          //         builder: (context, snapshot) {
          //           return snapshot.connectionState == ConnectionState.waiting
          //               ? SplashScreen()
          //               : AuthScreen();
          //         },
          //       ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            DeletedItemsScreen.routeName: (context) => DeletedItemsScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductOverViewScreen.routeName: (context) =>
                ProductOverViewScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
          },
        );
      }),
    );
  }
}
