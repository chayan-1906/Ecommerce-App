import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/screens/feeds_products_screen.dart';
import 'package:ecommerce_app/widgets/search_by_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchTextController;
  final FocusNode _focusNode = FocusNode();
  List<Product> _searchList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      // Refresh list
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productList = productsProvider.products;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: SearchByHeader(
              stackPaddingTop: 175.0,
              titlePaddingTop: 50.0,
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: getTranslated(context, 'search'),
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              // search field
              stackChild: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchTextController,
                  minLines: 1,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0.0,
                        style: BorderStyle.none,
                      ),
                    ),
                    prefixIcon: Icon(
                      MyIcons.searchScreenIcons['search'],
                    ),
                    hintText: getTranslated(context, 'search'),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    suffixIcon: IconButton(
                      icon: Icon(
                        MyIcons.searchScreenIcons['clear'],
                        color: _searchTextController.text.isNotEmpty
                            ? Colors.redAccent
                            : Theme.of(context).disabledColor,
                      ),
                      onPressed: _searchTextController.text.isEmpty
                          ? null
                          : () {
                              _searchTextController.clear();
                              _focusNode.unfocus();
                            },
                    ),
                  ),
                  onChanged: (value) {
                    _searchTextController.text.toLowerCase();
                    setState(() {
                      _searchList = productsProvider.searchQuery(value);
                    });
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _searchTextController.text.isNotEmpty && _searchList.isEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Icon(
                        MyIcons.searchScreenIcons['search_not_found'],
                        size: 40.0,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        getTranslated(context, 'no_results_found'),
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          color: ColorsConstants.red700,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 240 / 420,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: List.generate(
                        _searchTextController.text.isEmpty
                            ? productList.length
                            : _searchList.length, (index) {
                      return ChangeNotifierProvider.value(
                        value: _searchTextController.text.isEmpty
                            ? productList[index]
                            : _searchList[index],
                        child: const FeedProductsScreen(),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}
