// ignore_for_file: avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routname = '/edit_product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _isInit = true;
  var _isloading = false;
  final _focusforprice = FocusNode();
  final _focusforDes = FocusNode();
  final _focusforimg = FocusNode();
  final _imageURLcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editproduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var _isValue = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };

  @override
  void initState() {
    _focusforimg.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final arguments = ModalRoute.of(context)?.settings.arguments;

      if (arguments != null) {
        final productId = arguments as String;
        final productProvider =
            Provider.of<ProductsProvider>(context, listen: false);
        _editproduct = productProvider.findbyId(productId);
        // _editproduct = Provider.of<ProductsProvider>(context, listen: false)
        //     .findbyId(productId);
        if (_editproduct.id != null) {
          _isValue = {
            'title': _editproduct.title,
            'description': _editproduct.description,
            'price': _editproduct.price.toString(),
            'imageUrl': '',
          };
          _imageURLcontroller.text = _editproduct.imageUrl;
        } else {
          print("error caused by id");
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusforimg.removeListener(_updateImageURL);
    _focusforDes.dispose();
    _focusforprice.dispose();
    _focusforimg.dispose();
    _imageURLcontroller.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_focusforimg.hasFocus) {
      setState(() {});
    }
  }

  // Future<void> _saveForm() async {
  //   final isvalid = _form.currentState!.validate();
  //   if (!isvalid) {
  //     return;
  //   }
  //   _form.currentState!.save();
  //   setState(() {
  //     _isloading = true;
  //   });

  //   try {
  //     await Provider.of<ProductsProvider>(context, listen: false)
  //         .addProduct(_editproduct);
  //     // On successful addition of the product, you may show a success message or perform other actions if needed.
  //   } catch (error) {
  //     await showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: const Text('An error occurred!'),
  //         content: const Text('Something went wrong!'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(ctx).pop();
  //             },
  //             child: const Text('Okay'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //   setState(() {
  //     _isloading = false;
  //   });

  //   Navigator.of(context).pop(); // Go back to the previous page.
  // }

  Future<void> _saveForm() async {
    final isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isloading = true;
    });
    if (_editproduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .UpdateProduct(_editproduct.id, _editproduct);
    } else {
      try {
        // get data from productProvider and update editproduct define above
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editproduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An erroe occured!'),
            content: const Text('Something went wrong!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isloading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isloading = false;
    });

    // back to previous page
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Your Products!',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // for Title
                    TextFormField(
                      initialValue: _isValue['title'],
                      decoration: InputDecoration(labelText: 'Tile'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusforprice);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the value!';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _editproduct = Product(
                          title: newValue as String,
                          price: _editproduct.price,
                          description: _editproduct.description,
                          imageUrl: _editproduct.imageUrl,
                          id: _editproduct.id,
                          isFavorite: _editproduct.isFavorite,
                        );
                      },
                    ),
                    // for Price
                    TextFormField(
                      initialValue: _isValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _focusforprice,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusforDes);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid value';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter number geater than zero';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _editproduct = Product(
                          id: _editproduct.id,
                          isFavorite: _editproduct.isFavorite,
                          title: _editproduct.title,
                          price: double.parse(newValue!),
                          description: _editproduct.description,
                          imageUrl: _editproduct.imageUrl,
                        );
                      },
                    ),
                    //  for description
                    TextFormField(
                      initialValue: _isValue['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _focusforDes,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please write the description';
                        }
                        if (value.length < 10) {
                          return 'Should write at least 10 characters';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _editproduct = Product(
                          id: _editproduct.id,
                          isFavorite: _editproduct.isFavorite,
                          title: _editproduct.title,
                          price: _editproduct.price,
                          description: newValue.toString(),
                          imageUrl: _editproduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.grey,
                          ),
                          child: _imageURLcontroller.text.isEmpty
                              ? const Text(
                                  'Enter URL',
                                )
                              : FittedBox(
                                  child:
                                      Image.network(_imageURLcontroller.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLcontroller,
                            focusNode: _focusforimg,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter URL for image';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              _editproduct = Product(
                                id: _editproduct.id,
                                isFavorite: _editproduct.isFavorite,
                                title: _editproduct.title,
                                price: _editproduct.price,
                                description: _editproduct.description,
                                imageUrl: newValue!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
