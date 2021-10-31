import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/screens/auth/forget_password_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailAddress = '';
  String _password = '';
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await _firebaseAuth
            .signInWithEmailAndPassword(
              email: _emailAddress.toLowerCase().trim(),
              password: _password.trim(),
            )
            .then((value) =>
                Navigator.canPop(context) ? Navigator.pop(context) : null);
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          getTranslated(context, 'error_occurred'),
          error.toString(),
        );
        print('error occurred ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: Loading(),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [const Color(0xFF09FE92), const Color(0xFF1AFBA7)],
                            [const Color(0xFF25F9B5), const Color(0xFF2FF7C2)],
                            [const Color(0xFF38F6CD), const Color(0xFF40F5D7)],
                            [const Color(0xFF4AF3E3), const Color(0xFF4EF2E8)],
                            [const Color(0xFF51F2EC), const Color(0xFF56F1F3)],
                            [const Color(0xFF55F1F2), const Color(0xFF5AF0F8)],
                          ],
                          durations: [3000, 2440, 3800, 2000],
                          heightPercentages: [0.15, 0.19, 0.23, 0.27],
                          blur: const MaskFilter.blur(BlurStyle.inner, 10.0),
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        waveAmplitude: 0,
                        size: const Size(double.infinity, double.infinity),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 80.0),
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://image.flaticon.com/icons/png/128/869/869636.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // textformfield email
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('email'),
                                validator: (email) {
                                  if (email!.isEmpty || !email.contains('@')) {
                                    return getTranslated(
                                        context, 'email_warning');
                                  } else {
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      getTranslated(context, 'enter_email'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  errorStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  prefixIcon:
                                      Icon(MyIcons.loginScreenIcons['email']),
                                  fillColor: Theme.of(context).backgroundColor,
                                ),
                                onSaved: (value) {
                                  _emailAddress = value!;
                                },
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                              ),
                            ),
                            // textformfield password
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                key: const ValueKey('password'),
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return getTranslated(
                                        context, 'password_empty_warning');
                                  } else if (password.length < 6) {
                                    return getTranslated(
                                        context, 'password_length_6');
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.name,
                                focusNode: _passwordFocusNode,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      getTranslated(context, 'enter_password'),
                                  hintStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  errorStyle: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                  prefixIcon: Icon(
                                      MyIcons.loginScreenIcons['password']),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: _obscureText
                                        ? Icon(MyIcons
                                            .loginScreenIcons['visibility_on'])
                                        : Icon(MyIcons.loginScreenIcons[
                                            'visibility_off']),
                                  ),
                                  fillColor: Theme.of(context).backgroundColor,
                                ),
                                obscureText: _obscureText,
                                onSaved: (value) {
                                  _password = value!;
                                },
                                // onEditingComplete: _submitForm,
                              ),
                            ),
                            // login button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _submitForm();
                                    // Navigator.of(context).pushNamed(LoginScreen.routeName);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        radius: 1.5,
                                        colors: [
                                          ColorsConstants.starterColor,
                                          ColorsConstants.endColor,
                                          ColorsConstants.starterColor,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.5),
                                          blurRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MyIcons.landingPageIcons['sign_in'],
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          getTranslated(context, 'login'),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            fontSize: 20.0,
                                            color: Colors.black87,
                                            letterSpacing: 0.8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                              ],
                            ),
                            // forget password
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ForgetPasswordScreen.routeName);
                                  },
                                  child: Text(
                                    getTranslated(context, 'forget_password'),
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.getFont(
                                      'Roboto Slab',
                                      fontSize: 15.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue.shade800,
                                      decoration: TextDecoration.underline,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
