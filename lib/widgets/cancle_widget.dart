import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/providers/checkout_provider.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

Future<bool> cancelWidget({
  required BuildContext context,
  required TextEditingController textEditingController,
  String? bookingId,
  String? orderId,
}) async {
  final rs = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Image(
                            height: 64,
                            width: 64,
                            image: AssetImage("assets/gif/sad.gif"),
                          ),
                          Text(
                            AppLocalizations.of(context)!.translate('areYouSureToCancel')!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 1,
                        child: TextField(
                          controller: textEditingController,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          maxLines: 5,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5)))),
                                  onPressed: () async {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("${(AppLocalizations.of(context)!.translate('no')!)}"))),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5)))),
                                  onPressed: () async {
                                    String? errorMessage;
                                    if (orderId != null) {
                                      await context
                                          .read<CheckoutProvider>()
                                          .cancelOrder(
                                              token: context
                                                  .read<AuthenticateProvider>()
                                                  .token!,
                                              note: textEditingController.text,
                                              orderId: orderId);
                                      
                                      errorMessage = context
                                          .read<CheckoutProvider>()
                                          .httpResponseFlutter
                                          .errorMessage;
                                    } else if (bookingId != null) {
                                      await context
                                          .read<BookingProvider>()
                                          .deleteBookingOrder(
                                            note: textEditingController.text,
                                              token: context
                                                  .read<AuthenticateProvider>()
                                                  .token!,
                                              bookingId: bookingId);
                                      errorMessage = context
                                          .read<BookingProvider>()
                                          .httpResponseFlutter
                                          .errorMessage;
                                    }
                
                                    if (errorMessage != null) {
                                      await QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          text: errorMessage);
                                    } else {
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                                  child: Text("${((AppLocalizations.of(context)!.translate('yes')!))}"))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ) ??
      false;
  return rs;
}
