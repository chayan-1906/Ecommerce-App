import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/screens/categories_feeds_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryWidget extends StatefulWidget {
  final int index;
  const CategoryWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  List<Map<String, dynamic>> categories = [
    {
      'categoryName': 'Phones',
      'categoryImagesPath': 'assets/images/cat_phones.png',
    },
    {
      'categoryName': 'Clothes',
      'categoryImagesPath': 'assets/images/cat_clothes.jpg',
    },
    {
      'categoryName': 'Shoes',
      'categoryImagesPath': 'assets/images/cat_shoes.jpg',
    },
    {
      'categoryName': 'Beauty & Health',
      'categoryImagesPath': 'assets/images/cat_beauty.jpg',
    },
    {
      'categoryName': 'Laptops',
      'categoryImagesPath': 'assets/images/cat_laptops.png',
    },
    {
      'categoryName': 'Furniture',
      'categoryImagesPath': 'assets/images/cat_furniture.jpg',
    },
    {
      'categoryName': 'Watches',
      'categoryImagesPath': 'assets/images/cat_watches.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            print('${categories[widget.index]['categoryName']}');
            Navigator.of(context).pushNamed(CategoriesFeedsScreen.routeName,
                arguments: '${categories[widget.index]['categoryName']}');
          },
          child: Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(
                  categories[widget.index]['categoryImagesPath'],
                ),
                fit: BoxFit.cover,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 10.0,
          right: 10.0,
          child: Container(
            margin: const EdgeInsets.only(top: 14.0),
            child: Text(
              categories[widget.index]['categoryName'],
              style: GoogleFonts.getFont(
                'Roboto Slab',
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: ColorsConstants.title,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
