import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/screens/orders/order_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/user_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  ScrollController? _scrollController;
  var top = 0.0;
  String _uid = '';
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _joinedAt = '';
  String _userImageUrl = '';
  String? _selectedLanguage;
  List<String> languages = [
    'English',
    'हिंदी',
    'español',
    'فارسی', // farsi
    'اَلْعَرَبِيَّةُ‎', // arbi
    'اردو', // urdu
  ];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getUserInfo() async {
    User? user = _firebaseAuth.currentUser;
    _uid = user!.uid;
    print(user.email);
    final DocumentSnapshot<Map<String, dynamic>>? documentSnapshot = user
            .isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    print('documentSnapshot: ${documentSnapshot}');
    if (documentSnapshot == null) {
      _name = getTranslated(context, 'guest');
      _email = getTranslated(context, 'anonymous');
      _phoneNumber = getTranslated(context, 'not_available');
      _joinedAt = getTranslated(context, 'not_available');
      _userImageUrl = '';
      return;
    } else {
      setState(() {
        _name = documentSnapshot.get('name');
        _email = documentSnapshot.get('email');
        _phoneNumber = documentSnapshot.get('phoneNumber') ??
            getTranslated(context, 'not_available');
        _joinedAt = documentSnapshot.get('joinedAt');
        _userImageUrl = documentSnapshot.get('imageUrl') ??
            'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg';
        print(user.photoURL);
        print(user.displayName);
      });
    }
  }

  Future<void> chooseLanguageDialog(
      BuildContext context, String title, bool darkTheme) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: darkTheme ? Colors.black45 : Colors.white,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/app_language.png',
                  height: 20.0,
                  width: 20.0,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Roboto Slab',
                    color: darkTheme ? Colors.white : ColorsConstants.title,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          elevation: 5.0,
          content: RadioGroup<String>.builder(
            direction: Axis.vertical,
            activeColor: ColorsConstants.red400,
            groupValue: _selectedLanguage!,
            onChanged: (value) => setState(() {
              _selectedLanguage = value!;
              _changeLanguage(_selectedLanguage!);
              Navigator.of(context).pop();
              print(_selectedLanguage);
            }),
            items: languages,
            itemBuilder: (language) => RadioButtonBuilder(language),
          ),
        );
      },
    );
  }

  void _changeLanguage(String language) async {
    String? languageCode;
    switch (language) {
      case 'English':
        languageCode = 'en';
        break;
      case 'हिंदी':
        languageCode = 'hi';
        break;
      case 'español':
        languageCode = 'es';
        break;
      case 'فارسی': // farsi
        languageCode = 'fa';
        break;
      case 'اَلْعَرَبِيَّةُ‎': // arbi
        languageCode = 'ar';
        break;
      case 'اردو': // urdu
        languageCode = 'ur';
        break;
      default:
        print('151: default');
        languageCode = 'US';
    }
    Locale _temp = await setLocale(languageCode);
    MyApp.setLocale(context, _temp);
  }

  Future<void> getSelectedLanguage() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    String languageCode =
        _sharedPreferences.getString(LANGUAGE_CODE) ?? ENGLISH;
    print('163: languageCode: $languageCode');
    switch (languageCode) {
      case 'en':
        _selectedLanguage = 'English';
        break;
      case 'hi':
        _selectedLanguage = 'हिंदी';
        break;
      case 'es':
        _selectedLanguage = 'español';
        break;
      case 'fa': // farsi
        _selectedLanguage = 'فارسی';
        break;
      case 'ar': // arbi
        _selectedLanguage = 'اَلْعَرَبِيَّةُ‎';
        break;
      case 'ur': // urdu
        _selectedLanguage = 'اردو';
        break;
      default:
        print('184: default');
        _selectedLanguage = 'English';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      setState(() {});
    });
    getUserInfo();
    getSelectedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 4.0,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsConstants.starterColor,
                            ColorsConstants.endColor,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      child: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        centerTitle: true,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: top <= 110.0 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12.0),
                                  Container(
                                    height: kToolbarHeight / 1.8,
                                    width: kToolbarHeight / 1.8,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 1.0,
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          _userImageUrl != ''
                                              ? _userImageUrl
                                              : 'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    _name == ''
                                        ? getTranslated(context, 'guest')
                                        : _name,
                                    style: GoogleFonts.getFont(
                                      'Roboto Slab',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        background: Image(
                          image: NetworkImage(
                            _userImageUrl != ''
                                ? _userImageUrl
                                : 'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: userTitle(
                        getTranslated(context, 'user_bag'),
                      ),
                    ),
                    const Divider(thickness: 0.2, color: Colors.blueGrey),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        // splashColor: Theme.of(context).splashColor,
                        splashColor: Colors.orangeAccent,
                        child: ListTile(
                          title: Text(
                            getTranslated(context, 'wishlist'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading:
                              Icon(MyIcons.userTileIcons['wishlist_outlined']),
                          trailing:
                              Icon(MyIcons.userTileIcons['chevron_right']),
                          onTap: () => Navigator.of(context)
                              .pushNamed(WishlistScreen.routeName),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        // splashColor: Theme.of(context).splashColor,
                        splashColor: Colors.orangeAccent,
                        child: ListTile(
                          title: Text(
                            getTranslated(context, 'orders'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Icon(MyIcons.userTileIcons['orders']),
                          trailing:
                              Icon(MyIcons.userTileIcons['chevron_right']),
                          onTap: () => Navigator.of(context)
                              .pushNamed(OrderScreen.routeName),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: userTitle(
                        getTranslated(context, 'user_information'),
                      ),
                    ),
                    const Divider(thickness: 0.2, color: Colors.blueGrey),
                    userListTile(context, getTranslated(context, 'email'),
                        _email, 'email'),
                    userListTile(
                        context,
                        getTranslated(context, 'phone_number'),
                        _phoneNumber,
                        'phone_call'),
                    userListTile(
                        context,
                        getTranslated(context, 'shipping_address'),
                        'Address',
                        'local_shipping'),
                    userListTile(context, getTranslated(context, 'joined_date'),
                        _joinedAt, 'watch_later'),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: userTitle(
                        getTranslated(context, 'user_settings'),
                      ),
                    ),
                    const Divider(thickness: 0.2, color: Colors.blueGrey),
                    // Dark theme
                    ListTileSwitch(
                      value: themeProvider.darkTheme,
                      leading: Icon(MyIcons.userTileIcons['theme_light_dark']),
                      onChanged: (value) {
                        setState(() {
                          themeProvider.darkTheme = value;
                        });
                      },
                      visualDensity: VisualDensity.comfortable,
                      switchType: SwitchType.cupertino,
                      switchActiveColor: Colors.indigoAccent,
                      title: Text(
                        getTranslated(context, 'dark_theme'),
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // app language
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        // splashColor: Theme.of(context).splashColor,
                        splashColor: Colors.orangeAccent,
                        child: ListTile(
                          title: Text(
                            getTranslated(context, 'app_language'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Icon(MyIcons.userTileIcons['language']),
                          subtitle: Text(
                            _selectedLanguage ?? 'English',
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            print('app language tapped');
                            // Navigator.canPop(context)
                            //     ? Navigator.pop(context)
                            //     : null;
                            chooseLanguageDialog(
                                context,
                                getTranslated(context, 'language'),
                                themeProvider.darkTheme);
                          },
                        ),
                      ),
                    ),
                    // Logout
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        // splashColor: Theme.of(context).splashColor,
                        splashColor: Colors.orangeAccent,
                        child: ListTile(
                          title: Text(
                            getTranslated(context, 'logout'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Icon(MyIcons.userTileIcons['exit_to_app']),
                          onTap: () {
                            print('tapped');
                            // Navigator.canPop(context)
                            //     ? Navigator.pop(context)
                            //     : null;
                            GlobalMethods.signOutDialog(
                                context,
                                getTranslated(context, 'logout'),
                                getTranslated(context, 'logout_warning'),
                                () async {
                              await _firebaseAuth.signOut();
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // buildFloatingActionButton(),
        ],
      ),
    );
  }
}
