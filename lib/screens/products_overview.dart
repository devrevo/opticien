import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductOverViewScreen extends StatefulWidget {
  static String routeName = '/product-overview';
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  List<String> categories = [];
  var _isInit = true;
  var _isLoading = false;
  var _isSearch = false;
  String _searchValue = '';
  final _txtController = TextEditingController();

  Animation<double> _opacityAnimation;
  AnimationController _controller;
  Animation<double> _opacityTitleAnimation;
  Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _opacityTitleAnimation = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.5, 0),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        List<String> cats = ['All'];

        Provider.of<Products>(context).items.forEach((product) {
          cats.add(product.category);
        });
        categories = cats.toSet().toList();
        Provider.of<Products>(context).loadCategories(categories);
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              _isSearch
                  ? Text('')
                  : AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: FadeTransition(
                          opacity: _opacityTitleAnimation,
                          child: Text(
                            'My Shop App',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Avenir Next',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 0.5,
                constraints: BoxConstraints(minHeight: _isSearch ? 40 : 0),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 241, 241, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            _searchValue = value;
                          });
                        },
                        controller: _txtController,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(bottom: 8, top: 15, right: 15),
                            hintText: 'Search'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                setState(() {
                  _isSearch = !_isSearch;
                  if (_isSearch) {
                    _controller.forward();
                  } else {
                    _searchValue = '';
                    _controller.reverse();
                  }
                });
              }),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              if (value == FilterOptions.Favorites) {
                productsData.showFavoritesOnly();
              } else {
                productsData.showAll();
              }
              print(value);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              child: child,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
        // title: Text(
        //   'My Shop App',
        //   style: TextStyle(fontFamily: 'Avenir Next Medium'),
        // ),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    padding: EdgeInsets.only(top: 20),
                    child: _isLoading
                        ? Center(
                            child: Platform.isIOS
                                ? CupertinoActivityIndicator()
                                : CircularProgressIndicator(),
                          )
                        : (_isSearch && _searchValue != '')
                            ? ProductsGrid(
                                _searchValue, true, categories[selectedIndex])
                            : ProductsGrid(
                                '', false, categories[selectedIndex]),
                  ),
                ),
              ),
            ],
          ),
          _isLoading
              ? Container()
              : Container(
                  color: Colors.white,
                  child: SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          print(selectedIndex.toString());
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.only(right: 50, top: 5, left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categories[index].toString(),
                                style: TextStyle(
                                    color: index == selectedIndex
                                        ? Colors.deepPurple[400]
                                        : Colors.deepPurple[100],
                                    fontFamily: 'Avenir Next'),
                              ),
                              index == selectedIndex
                                  ? Container(
                                      height: 2,
                                      width: 30,
                                      color: Colors.deepPurple[400],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
