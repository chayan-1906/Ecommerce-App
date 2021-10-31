import 'dart:ui';

import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/screens/user_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: const UserState(),
        title: Text(
          getTranslated(context, 'ecommerce_app'),
          textAlign: TextAlign.center,
          // overflow: TextOverflow.ellipsis,
          style: GoogleFonts.getFont(
            'Source Serif Pro',
            fontWeight: FontWeight.w600,
            color: ColorsConstants.red400,
            fontSize: 30.0,
          ),
        ),
        image: Image.asset(
          'assets/images/app_icon.png',
          fit: BoxFit.contain,
        ),
        photoSize: 130.0,
        backgroundColor: Colors.white,
        useLoader: false,
      ),
    );
  }
}
