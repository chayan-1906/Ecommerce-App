import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup_screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _emailAddress = '';
  String _password = '';
  String _phoneNumber = '';
  String _imageUrl = '';
  bool _obscureText = true;
  File? _pickedImage;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = '${dateParse.day}-${dateParse.month}-${dateParse.year}';
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          GlobalMethods.authErrorDialog(
            context,
            getTranslated(context, 'warning'),
            getTranslated(context, 'image_empty_warning'),
          );
          return;
        } else {
          setState(() {
            _isLoading = true;
          });
          await _firebaseAuth.createUserWithEmailAndPassword(
            email: _emailAddress.toLowerCase().trim(),
            password: _password.trim(),
          );
          final User user = _firebaseAuth.currentUser!;
          final _uid = user.uid;
          // user.updateProfile(photoURL: _imageUrl, displayName: _name);
          user.updatePhotoURL(_imageUrl);
          user.updateDisplayName(_name);
          user.reload();
          final storageReference = FirebaseStorage.instance
              .ref()
              .child('profilePictures')
              .child(_uid + ".jpg");
          await storageReference.putFile(_pickedImage!);
          _imageUrl = await storageReference.getDownloadURL();
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _name,
            'email': _emailAddress,
            'phoneNumber': _phoneNumber,
            'imageUrl': _imageUrl,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          getTranslated(context, 'error_occurred'),
          error.toString(),
        );
        print('error occurred: ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final _imagePicker = ImagePicker();
    var pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final _imagePicker = ImagePicker();
    var pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
      Navigator.pop(context);
    }
  }

  void _removePhoto() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Loading()
          : SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [Colors.red, const Color(0xEEF44336)],
                            [Colors.red.shade800, const Color(0x77E57373)],
                            [Colors.orange, const Color(0x66FF9800)],
                            [Colors.yellow, const Color(0x55FFEB3B)],
                          ],
                          // durations: [35000, 19440, 10800, 6000],
                          durations: [3000, 2440, 3800, 2000],
                          heightPercentages: [0.01, 0.10, 0.18, 0.27],
                          blur: const MaskFilter.blur(BlurStyle.normal, 10.0),
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        waveAmplitude: 0,
                        size: const Size(double.infinity, double.infinity),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      // profile photo
                      Stack(
                        children: [
                          // Circle Avatar
                          Container(
                            margin: const EdgeInsets.all(30.0),
                            child: CircleAvatar(
                              backgroundColor: ColorsConstants.gradientLEnd,
                              radius: 71.0,
                              child: CircleAvatar(
                                radius: 65.0,
                                backgroundColor: ColorsConstants.gradientFEnd,
                                backgroundImage: _pickedImage == null
                                    ? null
                                    : FileImage(_pickedImage!),
                              ),
                            ),
                          ),
                          // Camera Icon to pick image
                          Positioned(
                            top: 120.0,
                            left: 110.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          getTranslated(
                                              context, 'choose_image_picker'),
                                          style: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            fontSize: 20.0,
                                            color: ColorsConstants.indigo400,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          // alert dialog
                                          child: ListBody(
                                            children: [
                                              // camera
                                              InkWell(
                                                onTap: () {
                                                  return _pickImageCamera();
                                                },
                                                splashColor:
                                                    Colors.orangeAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        MyIcons.signupScreenIcons[
                                                            'camera'],
                                                        color: ColorsConstants
                                                            .gradientFStart,
                                                      ),
                                                    ),
                                                    Text(
                                                      getTranslated(
                                                          context, 'camera'),
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Roboto Slab',
                                                        color: ColorsConstants
                                                            .title,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // gallery
                                              InkWell(
                                                onTap: () {
                                                  return _pickImageGallery();
                                                },
                                                splashColor:
                                                    Colors.orangeAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        MyIcons.signupScreenIcons[
                                                            'gallery'],
                                                        color: ColorsConstants
                                                            .gradientFStart,
                                                      ),
                                                    ),
                                                    Text(
                                                      getTranslated(
                                                          context, 'gallery'),
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Roboto Slab',
                                                        color: ColorsConstants
                                                            .title,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // remove photo
                                              InkWell(
                                                onTap: () {
                                                  return _removePhoto();
                                                },
                                                splashColor:
                                                    Colors.orangeAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        MyIcons.signupScreenIcons[
                                                            'remove'],
                                                        color: ColorsConstants
                                                            .red500,
                                                      ),
                                                    ),
                                                    Text(
                                                      getTranslated(context,
                                                          'remove_photo'),
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Roboto Slab',
                                                        color: ColorsConstants
                                                            .title,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              padding: const EdgeInsets.all(15.0),
                              elevation: 10.0,
                              splashColor: Colors.orangeAccent,
                              fillColor: ColorsConstants.gradientLEnd,
                              child: Icon(
                                MyIcons.signupScreenIcons['add_a_photo'],
                              ),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // textformfield name
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('name'),
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return getTranslated(
                                        context, 'name_empty_warning');
                                  } else {
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      getTranslated(context, 'enter_name'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  errorStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  prefixIcon:
                                      Icon(MyIcons.signupScreenIcons['person']),
                                  fillColor: Theme.of(context).backgroundColor,
                                ),
                                onSaved: (value) {
                                  _name = value!;
                                },
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailFocusNode),
                              ),
                            ),
                            // textformfield email
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('email'),
                                validator: (email) {
                                  if (email!.isEmpty || !email.contains('@')) {
                                    return getTranslated(
                                        context, 'email_warning');
                                  } else {
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _emailFocusNode,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      getTranslated(context, 'enter_email'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  errorStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  prefixIcon:
                                      Icon(MyIcons.signupScreenIcons['email']),
                                  fillColor: Theme.of(context).backgroundColor,
                                ),
                                onSaved: (value) {
                                  _emailAddress = value!;
                                },
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                              ),
                            ),
                            // textformfield password
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('password'),
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return getTranslated(
                                        context, 'password_empty_warning');
                                  } else if (password.length < 6) {
                                    return getTranslated(
                                        context, 'password_length_6');
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.name,
                                focusNode: _passwordFocusNode,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      getTranslated(context, 'enter_password'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  errorStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  prefixIcon: Icon(
                                      MyIcons.signupScreenIcons['password']),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: _obscureText
                                        ? Icon(MyIcons
                                            .signupScreenIcons['visibility_on'])
                                        : Icon(MyIcons.signupScreenIcons[
                                            'visibility_off']),
                                  ),
                                  fillColor: Theme.of(context).backgroundColor,
                                ),
                                obscureText: _obscureText,
                                onSaved: (value) {
                                  _password = value!;
                                },
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_phoneNumberFocusNode),
                              ),
                            ),
                            // textformfield phone number
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('phone'),
                                validator: (phone) {
                                  if (phone!.isEmpty) {
                                    return getTranslated(
                                        context, 'phone_warning');
                                  } else if (phone.length != 10) {
                                    return getTranslated(
                                        context, 'phone_length_10');
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                focusNode: _phoneNumberFocusNode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      getTranslated(context, 'enter_phone'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  errorStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  prefixIcon:
                                      Icon(MyIcons.signupScreenIcons['phone']),
                                  fillColor: Theme.of(context).backgroundColor,
                                ),
                                onSaved: (value) {
                                  _phoneNumber = value!;
                                },
                                onEditingComplete: _submitForm,
                              ),
                            ),
                            // signup button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _submitForm();
                                    // Navigator.of(context).pushNamed(LoginScreen.routeName);
                                  },
                                  child: _isLoading
                                      ? const Loading()
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          height: 36.0,
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              radius: 1.5,
                                              colors: [
                                                ColorsConstants.starterColor,
                                                ColorsConstants.endColor,
                                                ColorsConstants.starterColor,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.5),
                                                blurRadius: 1.5,
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MyIcons.landingPageIcons[
                                                    'sign_up'],
                                                size: 18.0,
                                              ),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                getTranslated(
                                                    context, 'sign_up'),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.getFont(
                                                  'Roboto Slab',
                                                  fontSize: 20.0,
                                                  color: Colors.black87,
                                                  letterSpacing: 0.8,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
