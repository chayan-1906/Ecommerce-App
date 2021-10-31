import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget userListTile(
    BuildContext context, String title, String subTitle, String iconKey) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      // splashColor: Theme.of(context).splashColor,
      splashColor: Colors.orangeAccent,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.getFont(
            'Roboto Slab',
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: GoogleFonts.getFont(
            'Roboto Slab',
            fontSize: 12.0,
          ),
        ),
        leading: Icon(MyIcons.userTileIcons[iconKey]),
        onTap: () {},
      ),
    ),
  );
}

Widget userTitle(String title) {
  return Padding(
    padding: const EdgeInsets.all(14.0),
    child: Text(
      title,
      style: GoogleFonts.getFont(
        'Roboto Slab',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
