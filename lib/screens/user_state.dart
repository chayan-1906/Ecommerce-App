import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/screens/landing_page.dart';
import 'package:ecommerce_app/screens/main_screen.dart';
import 'package:ecommerce_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Loading(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            print('The user has already logged in');
            return const MainScreen();
          } else {
            print('The user didn\'t log in');
            return const LandingPage();
          }
        } else if (userSnapshot.hasError) {
          return Center(
            child: Text(
              getTranslated(context, 'error_occurred'),
              style: GoogleFonts.getFont(
                'Roboto Slab',
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              getTranslated(context, 'error_occurred'),
              style: GoogleFonts.getFont(
                'Roboto Slab',
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
          );
        }
      },
    );
  }
}
