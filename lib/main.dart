// @dart=2.8
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/screens/auth/forget_password_screen.dart';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/auth/sign_up_screen.dart';
import 'package:ecommerce_app/screens/bottom_bar_screen.dart';
import 'package:ecommerce_app/screens/orders/order_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';
import 'inner_screen/brand_navigation_rail.dart';
import 'localization/demo_localizations.dart';
import 'localization/localization_constants.dart';
import 'provider/orders_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/categories_feeds_screen.dart';
import 'screens/feeds_screen.dart';
import 'screens/my_splash_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/upload_products_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'widgets/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();
  Locale _locale = const Locale('US');

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    print('Inside didChangeDependencies $_locale');
    super.didChangeDependencies();
  }

  void getCurrentTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.themePreferences.getTheme();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentTheme();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Loading();
    } else {
      return FutureBuilder(
          future: _firebaseInitialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(
                  body: Loading(),
                ),
              );
            } else if (snapshot.hasError) {
              return MaterialApp(
                home: Scaffold(
                  body: Text(
                    getTranslated(context, 'error_occurred'),
                    style: GoogleFonts.getFont(
                      'Roboto Slab',
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: ColorsConstants.red400,
                    ),
                  ),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) {
                    return themeChangeProvider;
                  },
                ),
                ChangeNotifierProvider(
                  create: (_) => ProductsProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => WishlistProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<ThemeProvider>(
                builder: (context, themeData, child) {
                  return MaterialApp(
                    title: 'Ecommerce',
                    theme: Themes.themeData(
                        context, themeChangeProvider.darkTheme),
                    debugShowCheckedModeBanner: false,
                    home: const MySplashScreen(),
                    routes: {
                      BrandNavigationRail.routeName: (ctx) =>
                          const BrandNavigationRail(),
                      FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                      CartScreen.routeName: (ctx) => const CartScreen(),
                      WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                      ProductDetailsScreen.routeName: (ctx) =>
                          const ProductDetailsScreen(),
                      CategoriesFeedsScreen.routeName: (ctx) =>
                          const CategoriesFeedsScreen(),
                      LoginScreen.routeName: (ctx) => const LoginScreen(),
                      SignUpScreen.routeName: (ctx) => const SignUpScreen(),
                      BottomBarScreen.routeName: (ctx) =>
                          const BottomBarScreen(),
                      UploadProductsScreen.routeName: (ctx) =>
                          const UploadProductsScreen(),
                      ForgetPasswordScreen.routeName: (ctx) =>
                          const ForgetPasswordScreen(),
                      OrderScreen.routeName: (ctx) => const OrderScreen(),
                    },
                    locale: _locale,
                    supportedLocales: const [
                      Locale('en', 'US'), // english --> United States
                      Locale('hi', 'IN'), // hindi --> India
                      Locale('es', 'ES'), // spanish --> Spain
                      Locale('fa', 'IR'), // farsi --> Iran
                      Locale('ar', 'SA'), // arabic --> Saudi Arab
                      Locale('ur', 'PK'), // urdu --> Pakistan
                    ],
                    localizationsDelegates: const [
                      DemoLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    localeResolutionCallback: (deviceLocale, supportedLocales) {
                      for (var locale in supportedLocales) {
                        if (locale.languageCode == deviceLocale.languageCode &&
                            locale.countryCode == deviceLocale.countryCode) {
                          print('129: Inside if');
                          return deviceLocale;
                        }
                      }
                      print('131: ${supportedLocales.first}');
                      return supportedLocales.first;
                    },
                  );
                },
              ),
            );
          });
    }
  }
}
