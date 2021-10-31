import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key? key, required this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Container(
              child: _buildItem(context),
              // padding: EdgeInsets.all(10.0),
            )
          : Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        MyIcons.uploadProductScreenIcons['unfold_more_rounded'],
                        color: Colors.black,
                        size: 23.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(
        title,
        style: GoogleFonts.getFont(
          'Roboto Slab',
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
