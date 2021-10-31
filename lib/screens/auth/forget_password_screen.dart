import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget_password';

  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String _emailAddress = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

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
            .sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase())
            .then(
              (value) => Fluttertoast.showToast(
                msg: getTranslated(context, 'reset_link_sent'),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.greenAccent,
                textColor: Colors.pinkAccent,
                fontSize: 16.0,
              ),
            );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          getTranslated(context, 'error_occurred'),
          error.toString(),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Loading(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.redAccent,
                      Colors.orangeAccent,
                      Colors.purpleAccent,
                      Colors.lightBlueAccent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        getTranslated(context, 'forget_password'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          key: const ValueKey('email'),
                          validator: (email) {
                            if (email!.isEmpty || !email.contains('@')) {
                              return getTranslated(context, 'email_warning');
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            hintText: getTranslated(context, 'enter_email'),
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
                              fontSize: 20.0,
                            ),
                            prefixIcon: Icon(
                                MyIcons.forgetPasswordScreenIcons['email']),
                            fillColor: Theme.of(context).backgroundColor,
                          ),
                          onSaved: (value) {
                            _emailAddress = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: InkWell(
                        onTap: () {
                          _submitForm();
                          // Navigator.of(context).pushNamed(LoginScreen.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 50.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MyIcons.forgetPasswordScreenIcons['lock'],
                                size: 20.0,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                getTranslated(context, 'reset_password'),
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
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
