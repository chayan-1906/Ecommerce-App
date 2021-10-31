import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/orders_provider.dart';
import 'package:ecommerce_app/services/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'order_empty_screen.dart';
import 'order_full_screen.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  void payWithCard({required int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      message: getTranslated(context, 'please_wait'),
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
      currency: 'USD',
      amount: amount.toString(),
    );
    await dialog.hide();
    print('response : ${response.message}');
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration:
            Duration(milliseconds: response.success == true ? 1200 : 3000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);

    return FutureBuilder(
      future: orderProvider.fetchOrders(),
      builder: (context, snapshot) {
        return orderProvider.getOrders.isEmpty
            ? const Scaffold(
                body: OrderEmptyScreen(),
              )
            : Scaffold(
                appBar: AppBar(
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorsConstants.starterColor,
                          ColorsConstants.endColor,
                        ],
                      ),
                    ),
                  ),
                  title: Text(
                    '${getTranslated(context, 'orders')} (${orderProvider.getOrders.length})',
                    style: GoogleFonts.getFont(
                      'Roboto Slab',
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Container(
                  margin: const EdgeInsets.only(bottom: 60.0),
                  child: ListView.builder(
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: orderProvider.getOrders[index],
                        child: const OrderFullScreen(),
                      );
                    },
                    itemCount: orderProvider.getOrders.length,
                  ),
                ),
              );
      },
    );
  }
}
