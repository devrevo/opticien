import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/style/text_field_container.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/editproduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  List<DropdownMenuItem> drops = [];
  String selectedCategory = "All";
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    name: '',
    price: 0,
    description: '',
    imageUrl: '',
    quantity: 0,
  );
  var _initValues = {
    'name': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'quantity': '',
  };
  var _isInit = true;
  var isLoading = false;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        Provider.of<Products>(context).fetchAndSetProducts(true);
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'quantity': _editedProduct.quantity.toString(),
        };
        selectedCategory = _editedProduct.category;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    buildDropDown();
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final _isvalid = _form.currentState.validate();
    if (!_isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    _editedProduct = Product(
        id: _editedProduct.id,
        name: _editedProduct.name,
        description: _editedProduct.description,
        price: _editedProduct.price,
        category: selectedCategory,
        quantity: _editedProduct.quantity,
        imageUrl: _editedProduct.imageUrl);
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct);
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
        Navigator.of(context).pop();
      } catch (error) {
        if (Platform.isIOS) {
          await showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: new Text('An error occurred !'),
              content: new Text('Something went wrong!'),
              actions: [
                CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('I get it!'))
              ],
            ),
          );
        } else {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('An error occurred !'),
              content: Text('Something went wrong!'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('I get it!'))
              ],
            ),
          );
        }
      }
      //finally {
      //   Navigator.of(context).pop();
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    }
    setState(() {
      isLoading = false;
    });
  }

  List<DropdownMenuItem> buildDropDown() {
    List<DropdownMenuItem> dropdown = [];
    Provider.of<Products>(context).categories.forEach((element) {
      setState(() {
        dropdown.add(DropdownMenuItem(
          value: element,
          child: Text(element),
        ));
      });
    });
    drops = dropdown;
    return drops;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.69,
                      child: ListView(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Container(
                                width: 150,
                                height: 150,
                                margin: EdgeInsets.only(top: 8, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(150),
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colors.deepPurple,
                                    ),
                                    image: DecorationImage(
                                      image: _imageUrlController.text.isEmpty
                                          ? AssetImage(
                                              'assets/images/placeholders/image-placeholder.png',
                                            )
                                          : NetworkImage(
                                              _imageUrlController.text),
                                    )),
                              ),
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Image URL',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              controller: _imageUrlController,
                              focusNode: _imageFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_titleFocusNode);
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    quantity: _editedProduct.quantity,
                                    imageUrl: newValue);
                              },
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              initialValue: _initValues['name'],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Title',
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_priceFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a title for your product.';
                                }
                                return null;
                              },
                              focusNode: _titleFocusNode,
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: newValue,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    quantity: _editedProduct.quantity,
                                    imageUrl: _editedProduct.imageUrl);
                              },
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              initialValue: _initValues['price'],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Price',
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false, signed: true),
                              focusNode: _priceFocusNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_quantityFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a price for your product.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please provide a price for your product.';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Please provide a price greater than 0.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: double.parse(newValue),
                                    quantity: _editedProduct.quantity,
                                    imageUrl: _editedProduct.imageUrl);
                              },
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              initialValue: _initValues['quantity'],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Quantity',
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false, signed: true),
                              focusNode: _quantityFocusNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_descriptionFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a quantity for your product.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please provide a quantity for your product.';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    quantity: int.parse(newValue),
                                    imageUrl: _editedProduct.imageUrl);
                              },
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              initialValue: _initValues['description'],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Description',
                                border: InputBorder.none,
                              ),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              focusNode: _descriptionFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a description for your product.';
                                }
                                if (value.length < 10) {
                                  return 'Should be at least 10 characters long.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: newValue,
                                    price: _editedProduct.price,
                                    quantity: _editedProduct.quantity,
                                    imageUrl: _editedProduct.imageUrl);
                              },
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.deepPurple[100],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                elevation: 10,
                                dropdownColor: Colors.white,
                                value: selectedCategory,
                                items: drops,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: MaterialButton(
                              color: Colors.deepPurple[400],
                              minWidth: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.06,
                              onPressed: _saveForm,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
