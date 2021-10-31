import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:flutter/material.dart';

import 'cart/cart_screen.dart';
import 'feeds_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'user_info_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedPageIndex = 0;
  List<dynamic>? pages;
  @override
  void initState() {
    pages = [
      const HomeScreen(),
      const FeedsScreen(),
      const SearchScreen(),
      const CartScreen(),
      const UserInfoScreen(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages![_selectedPageIndex], //_pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 1.12,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.blueGrey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).textSelectionColor,
              selectedItemColor: ColorsConstants.red300,
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(MyIcons.homeIcon),
                  label: getTranslated(context, 'home'),
                  activeIcon: Icon(MyIcons.homeCircleIcon),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MyIcons.feedIcon),
                  label: getTranslated(context, 'feeds'),
                  activeIcon: Icon(MyIcons.feedBoxIcon),
                ),
                BottomNavigationBarItem(
                  activeIcon: null,
                  icon: Icon(null),
                  label: getTranslated(context, 'search'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MyIcons.cartIcon),
                  label: getTranslated(context, 'cart'),
                  activeIcon: Icon(MyIcons.cartCoveredIcon),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MyIcons.accountIcon),
                  label: getTranslated(context, 'user'),
                  activeIcon: Icon(MyIcons.accountIconCovered),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: ColorsConstants.red300,
          hoverElevation: 10,
          splashColor: Colors.orangeAccent,
          tooltip: 'Search',
          elevation: 4,
          child: Icon(MyIcons.shoppingSearchIcon),
          onPressed: () => setState(() {
            _selectedPageIndex = 2;
          }),
        ),
      ),
    );
  }
}
