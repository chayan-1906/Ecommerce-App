import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../feeds_screen.dart';

class CartEmptyScreen extends StatelessWidget {
  const CartEmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            // margin: const EdgeInsets.only(top: 80.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/empty_cart.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              getTranslated(context, 'cart_empty'),
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Roboto Slab',
                fontSize: 35.0,
                fontWeight: FontWeight.w600,
                color: themeChange.darkTheme
                    ? ColorsConstants.favBadgeColor
                    : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              getTranslated(context, 'cart_empty_description'),
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Roboto Slab',
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: themeChange.darkTheme
                    ? Theme.of(context).disabledColor
                    : ColorsConstants.subTitle,
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.07,
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FeedsScreen.routeName);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                // side: const BorderSide(color: Colors.redAccent),
              ),
              color: ColorsConstants.favBadgeColor,
              child: Text(
                getTranslated(context, 'shop_now').toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  // color: themeChange.darkTheme
                  //     ? Theme.of(context).disabledColor
                  //     : ColorsConstants.subTitle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
