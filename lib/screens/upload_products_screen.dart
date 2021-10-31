import 'dart:io';
import 'dart:ui';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:direct_select/direct_select.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/gradient_text_widget.dart';
import 'package:ecommerce_app/widgets/loading.dart';
import 'package:ecommerce_app/widgets/myselectionitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadProductsScreen extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductsScreen({Key? key}) : super(key: key);

  @override
  _UploadProductsScreenState createState() => _UploadProductsScreenState();
}

class _UploadProductsScreenState extends State<UploadProductsScreen> {
  final _formKey = GlobalKey<FormState>();

  var _productTitle = '';
  var _productPrice = '';
  var _productDescription = '';
  var _productQuantity = '';

  String? _categoryValue;
  String _brandValue = 'Select a Brand';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String? _imageUrl;
  var uuid = const Uuid();
  int selectedCategory = 0;
  bool _isPanDown = false;
  bool _isBrandDropDownOpened = false;
  bool _isBackPressedOrTouchedOutSide = false;
  List<String> _categories = [
    'Select a Category',
    'Phones',
    'Clothes',
    'Shoes',
    'Beauty & Health',
    'Laptops',
    'Furniture',
    'Watches',
  ];
  List<String> _brandList = [
    'Brandless',
    'Adidas',
    'Apple',
    'Dell',
    'H & M',
    'Nike',
    'Samsung',
    'Huawei',
  ];

  List<Widget> _buildCategory() {
    return _categories
        .map(
          (val) => MySelectionItem(
            title: val,
          ),
        )
        .toList();
  }

  // showAlertDialog(BuildContext context, String title, String body) {
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(body),
  //         actions: [
  //           FlatButton(
  //             child: Text(
  //               getTranslated(context, 'okay'),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _tryUploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (selectedCategory == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            getTranslated(context, 'category_empty_warning'),
            style: GoogleFonts.getFont('Roboto Slab',
                fontWeight: FontWeight.w600, color: Colors.redAccent),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
    if (_brandValue == 'Select a Brand') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            getTranslated(context, 'brand_empty_warning'),
            style: GoogleFonts.getFont(
              'Roboto Slab',
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
    if (isValid && selectedCategory != 0 && _brandValue != 'Select a Brand') {
      _formKey.currentState!.save();
      print(_productTitle);
      print(_productPrice);
      print(_brandValue);
      print(_productDescription);
      print(_productQuantity);
      // Use those values to send our request...
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          GlobalMethods.authErrorDialog(
              context, getTranslated(context, 'image_empty_warning'), '');
          return;
        }
        setState(() {
          _isLoading = true;
        });

        final User? user = _firebaseAuth.currentUser;
        final _uid = user!.uid;
        final _productId = uuid.v4();
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('productPictures')
            .child(_productId + '.jpg');
        await storageReference.putFile(_pickedImage!);
        _imageUrl = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('products')
            .doc(_productId)
            .set({
          'productId': _productId,
          'productTitle': _productTitle,
          'price': _productPrice,
          'productImage': _imageUrl,
          'productCategory': _categoryValue,
          'productBrand': _brandValue,
          'productDescription': _productDescription,
          'productQuantity': _productQuantity,
          'userId': _uid,
          'createdAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        GlobalMethods.authErrorDialog(context, error.toString(), '');
        print('error occurred ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
          selectedCategory = 0;
          _removeImage();
          _brandValue = 'Select a Brand';
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return _isLoading
        ? const Scaffold(
            body: Loading(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                getTranslated(context, 'upload_product'),
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  fontWeight: FontWeight.w600,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsConstants.starterColor,
                      ColorsConstants.endColor,
                    ],
                  ),
                ),
              ),
            ),
            // Upload button
            bottomSheet: Container(
              height: kBottomNavigationBarHeight * 0.8,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Material(
                color: Theme.of(context).backgroundColor,
                child: InkWell(
                  onTap: _tryUploadProduct,
                  splashColor: Colors.pinkAccent.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // upload button text
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: GradientText(
                          text: getTranslated(context, 'upload'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                            letterSpacing: 1.3,
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.redAccent,
                              Colors.tealAccent,
                            ],
                          ),
                        ),
                      ),
                      // upload icon
                      GradientIcon(
                        icon: MyIcons.uploadProductScreenIcons['upload'],
                        size: 20.0,
                        gradient: const LinearGradient(
                          colors: [
                            Colors.lightBlueAccent,
                            Colors.redAccent,
                            Colors.tealAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // const SizedBox(height: 5.0),
                  Center(
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // product title & price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // product title
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 9, left: 16.0),
                                      child: TextFormField(
                                        key: const ValueKey('Title'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return getTranslated(context,
                                                'product_title_empty_warning');
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          hintText: getTranslated(
                                              context, 'product_title'),
                                          hintStyle: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          _productTitle = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  // price
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: TextFormField(
                                        key: const ValueKey('Price \$'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return getTranslated(
                                                context, 'price');
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: '${getTranslated(
                                              context, 'price')} \$',
                                          hintStyle: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          _productPrice = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              /* Image picker here */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // product image
                                  Expanded(
                                    //  flex: 2,
                                    child: _pickedImage == null
                                        ? Container(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            margin: const EdgeInsets.all(10.0),
                                            height: 200.0,
                                            width: 200.0,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                getTranslated(
                                                    context, 'product_image'),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.getFont(
                                                  'Roboto Slab',
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.all(10.0),
                                            height: 200.0,
                                            width: 200.0,
                                            child: Container(
                                              height: 200.0,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                              ),
                                              child: Image.file(
                                                _pickedImage!,
                                                fit: BoxFit.contain,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          ),
                                  ),
                                  // image pickers: camera, gallery & remove
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // camera
                                      FittedBox(
                                        child: FlatButton.icon(
                                          textColor: Colors.white,
                                          onPressed: _pickImageCamera,
                                          icon: Icon(
                                              MyIcons.uploadProductScreenIcons[
                                                  'camera'],
                                              color: ColorsConstants
                                                  .gradientFStart),
                                          label: Text(
                                            getTranslated(context, 'camera'),
                                            style: GoogleFonts.getFont(
                                              'Roboto Slab',
                                              fontWeight: FontWeight.w500,
                                              color: themeProvider.darkTheme
                                                  ? ColorsConstants.teal50
                                                  : ColorsConstants.title,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // gallery
                                      FittedBox(
                                        child: FlatButton.icon(
                                          textColor: Colors.white,
                                          onPressed: _pickImageGallery,
                                          icon: Icon(
                                              MyIcons.uploadProductScreenIcons[
                                                  'gallery'],
                                              color: ColorsConstants
                                                  .gradientFStart),
                                          label: Text(
                                            getTranslated(context, 'gallery'),
                                            style: GoogleFonts.getFont(
                                              'Roboto Slab',
                                              fontWeight: FontWeight.w500,
                                              color: themeProvider.darkTheme
                                                  ? ColorsConstants.teal50
                                                  : ColorsConstants.title,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // remove photo
                                      _pickedImage == null
                                          ? Container()
                                          : FittedBox(
                                              child: FlatButton.icon(
                                                textColor: Colors.white,
                                                onPressed: _removeImage,
                                                icon: Icon(
                                                  MyIcons.uploadProductScreenIcons[
                                                      'remove'],
                                                  color: ColorsConstants.red500,
                                                ),
                                                label: Text(
                                                  getTranslated(
                                                      context, 'remove_photo'),
                                                  style: GoogleFonts.getFont(
                                                    'Roboto Slab',
                                                    fontWeight: FontWeight.w500,
                                                    color: themeProvider
                                                            .darkTheme
                                                        ? ColorsConstants.teal50
                                                        : ColorsConstants.title,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              // category dropdown
                              DirectSelect(
                                backgroundColor: Colors.greenAccent,
                                itemExtent: 35.0,
                                selectedIndex: selectedCategory,
                                child: MySelectionItem(
                                  isForList: false,
                                  title: _categories[selectedCategory],
                                ),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedCategory = index!;
                                    _categoryValue =
                                        _categories[selectedCategory];
                                  });
                                },
                                items: _buildCategory(),
                              ),
                              const SizedBox(width: 10.0),
                              AwesomeDropDown(
                                isPanDown: _isPanDown,
                                isBackPressedOrTouchedOutSide:
                                    _isBackPressedOrTouchedOutSide,
                                dropDownBGColor: Colors.redAccent.shade100,
                                dropDownOverlayBGColor:
                                    Colors.redAccent.shade100,
                                dropDownIcon: Icon(
                                  MyIcons.uploadProductScreenIcons['dropdown'],
                                  color: Colors.black,
                                  size: 23.0,
                                ),
                                elevation: 5.0,
                                dropDownBorderRadius: 10.0,
                                dropDownTopBorderRadius: 50.0,
                                dropDownBottomBorderRadius: 50.0,
                                dropDownIconBGColor: Colors.transparent,
                                dropDownList: _brandList,
                                selectedItem: _brandValue,
                                numOfListItemToShow: _brandList.length,
                                selectedItemTextStyle: GoogleFonts.getFont(
                                  'Roboto Slab',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                dropDownListTextStyle: GoogleFonts.getFont(
                                  'Roboto Slab',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                onDropDownItemClick: (selectedBrand) {
                                  _brandValue = selectedBrand;
                                },
                                dropStateChanged: (isOpened) {
                                  _isBrandDropDownOpened = isOpened;
                                  if (!isOpened) {
                                    _isBackPressedOrTouchedOutSide = false;
                                  }
                                  print(
                                      '_isBrandDropDownOpened: $_isBrandDropDownOpened');
                                },
                              ),
                              const SizedBox(height: 15.0),
                              // product description
                              TextFormField(
                                key: const ValueKey('Description'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return getTranslated(context,
                                        'product_description_empty_warning');
                                  }
                                  return null;
                                },
                                maxLines: 10,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  //  counterText: charLength.toString(),
                                  labelText: getTranslated(
                                      context, 'product_description'),
                                  labelStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintText: getTranslated(
                                      context, 'product_description'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _productDescription = value!;
                                },
                                onChanged: (text) {
                                  // setState(() => charLength -= text.length);
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // quantity
                                  Expanded(
                                    //flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        key: const ValueKey('Quantity'),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return getTranslated(context,
                                                'quantity_empty_description');
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: getTranslated(
                                              context, 'quantity'),
                                          hintStyle: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onSaved: (value) {
                                          _productQuantity = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 45.0),
                ],
              ),
            ),
          );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData? icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    Key? key,
    required this.icon,
    required this.size,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
