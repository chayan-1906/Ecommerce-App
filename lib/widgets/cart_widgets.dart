import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/services/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var response;

Future<void> payWithCard(BuildContext context, {required int amount}) async {
  ProgressDialog progressDialog = ProgressDialog(context);
  progressDialog.style(
    message: getTranslated(context, 'please_wait'),
  );
  await progressDialog.show();
  response = await StripeService.payWithNewCard(
    amount: amount.toString(),
    currency: 'USD',
  );
  await progressDialog.hide();
  print('response: ${response.message}');
  // response.success ? print('amount: ${response.}') : print('failed');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ),
  );
}

Widget checkoutSection(BuildContext context, double subTotal) {
  var uuid = const Uuid();
  final cartProvider = Provider.of<CartProvider>(context);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.grey, width: 0.5),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  colors: [
                    ColorsConstants.gradientLStart,
                    ColorsConstants.gradientLEnd,
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.0),
                  onTap: () async {
                    double amountInCents = subTotal * 1000;
                    int integerAmount = (amountInCents / 10).ceil();
                    await payWithCard(context, amount: integerAmount);
                    if (response.success == true) {
                      User? user = _firebaseAuth.currentUser;
                      final _uid = user!.uid;
                      cartProvider.getCartItems
                          .forEach((key, orderValue) async {
                        final orderId = uuid.v4();
                        try {
                          await FirebaseFirestore.instance
                              .collection('order')
                              .doc(orderId)
                              .set({
                            'orderId': orderId,
                            'userId': _uid,
                            'productId': orderValue.productId,
                            'title': orderValue.title,
                            'price': double.parse(orderValue.price) *
                                orderValue.quantity,
                            'imageUrl': orderValue.imageUrl,
                            'quantity': orderValue.quantity,
                            'orderDate': Timestamp.now(),
                          }).then((value) {
                            cartProvider.clearCart();
                          });
                        } catch (error) {
                          print('Error occurred: $error');
                        }
                      });
                    } else {
                      GlobalMethods.authErrorDialog(
                        context,
                        getTranslated(context, 'error_occurred'),
                        getTranslated(context, 'enter_correct_payment_info'),
                      );
                      return;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AutoSizeText(
                      getTranslated(context, 'checkout').toUpperCase(),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        color: ColorsConstants.title,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                        // fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            getTranslated(context, 'total'),
            style: GoogleFonts.getFont(
              'Roboto Slab',
              color: ColorsConstants.title,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              fontSize: 18.0,
            ),
          ),
          Text(
            'US \$ ${subTotal.toStringAsFixed(2)}',
            style: GoogleFonts.getFont(
              'Roboto Slab',
              color: ColorsConstants.indigo600,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    ),
  );
}
