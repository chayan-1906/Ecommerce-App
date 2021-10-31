import 'package:ecommerce_app/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

Widget productDescription(
    {required BuildContext context,
    required bool themeState,
    required String title,
    required String value}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.getFont(
            'Roboto Slab',
            color: themeState
                ? Theme.of(context).disabledColor
                : ColorsConstants.title,
            fontWeight: FontWeight.w600,
            fontSize: 21.0,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.getFont(
            'Roboto Slab',
            color: themeState
                ? Theme.of(context).disabledColor
                : ColorsConstants.subTitle,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ],
    ),
  );
}
