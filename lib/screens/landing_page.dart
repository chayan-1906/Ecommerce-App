import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/auth/sign_up_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/gradient_text_widget.dart';
import 'package:ecommerce_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  List<String> images = [
    'https://media.istockphoto.com/photos/man-at-the-shopping-picture-id868718238?k=6&m=868718238&s=612x612&w=0&h=ZUPCx8Us3fGhnSOlecWIZ68y3H4rCiTnANtnjHk0bvo=',
    'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1138257321%2F0x0.jpg%3Ffit%3Dscale',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images.shuffle();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _googleSignIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          // var date = DateTime.now().toString();
          var date = authResult.user!.metadata.creationTime.toString();
          var dateParse = DateTime.parse(date);
          var formattedDate =
              '${dateParse.day}-${dateParse.month}-${dateParse.year}';
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'phoneNumber': authResult.user!.phoneNumber,
            'imageUrl': authResult.user!.photoURL,
            'joinedAt': formattedDate,
            'createdAt': date,
          });
          print(authResult.user!.phoneNumber);
        } catch (error) {
          GlobalMethods.authErrorDialog(
            context,
            getTranslated(context, 'error_occurred'),
            error.toString(),
          );
          print('error occurred ${error.toString()}');
        }
      }
    }
  }

  void _loginAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (error) {
      GlobalMethods.authErrorDialog(
        context,
        getTranslated(context, 'error_occurred'),
        error.toString(),
      );
      print('error occurred ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Loading(),
          )
        : Scaffold(
            body: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: images[0],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: FractionalOffset(_animation.value, 0),
                ),
                // welcome & welcome to the largest online store
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientText(
                        text: getTranslated(context, 'welcome'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          fontSize: 60.0,
                          fontWeight: FontWeight.w700,
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Colors.redAccent,
                            Colors.tealAccent,
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          getTranslated(context, 'welcome_description'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontSize: 26.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // login & sign up
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10.0),
                        // login
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName);
                            },
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorsConstants.starterColor,
                                    ColorsConstants.endColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MyIcons.landingPageIcons['sign_in'],
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    getTranslated(context, 'login'),
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
                        ),
                        // sign up
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SignUpScreen.routeName);
                            },
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorsConstants.endColor,
                                    ColorsConstants.starterColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MyIcons.landingPageIcons['sign_up'],
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    getTranslated(context, 'sign_up'),
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
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    // or continue with
                    Row(
                      children: [
                        // divider
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          ),
                        ),
                        // or continue with
                        Text(
                          getTranslated(context, 'continue_with'),
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontSize: 20.0,
                            color: Colors.black,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // divider
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    // Google + Sign in
                    SizedBox(
                      height: 45.0,
                      child: OutlinedButton.icon(
                        icon: Icon(
                          MyIcons.landingPageIcons['google'],
                          color: ColorsConstants.red400,
                        ),
                        onPressed: () {
                          _googleSignIn();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side: BorderSide(
                              width: 2.0, color: ColorsConstants.red400),
                          elevation: 5.0,
                        ),
                        label: Text(
                          getTranslated(context, 'google+'),
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontSize: 20.0,
                            color: ColorsConstants.red400,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Sign in as a guest
                    SizedBox(
                      height: 45.0,
                      child: OutlinedButton(
                        onPressed: () {
                          _loginAnonymously();
                          // Navigator.of(context).pushNamed(BottomBarScreen.routeName);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side: const BorderSide(
                              width: 2.0, color: Colors.orangeAccent),
                          elevation: 5.0,
                        ),
                        child: Text(
                          getTranslated(context, 'sign_in_anonymously'),
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontSize: 20.0,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ],
            ),
          );
  }
}
