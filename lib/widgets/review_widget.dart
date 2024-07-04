import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

Future<bool> PostReview ({required BuildContext context, required TextEditingController textController, String? productId, String? serviceId, double reviewRating = 0})async{
  TextEditingController controller = TextEditingController();
  final rs = await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "What is your rate?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        RatingBar(
                          itemPadding: const EdgeInsets.all(2),
                          itemSize: 35.0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: false,
                          initialRating: reviewRating,
                          ratingWidget: RatingWidget(
                            full: Image.asset('assets/images/star_full.png',color: Theme.of(context).colorScheme.secondary,),
                            half: Image.asset('assets/images/star_half.png',color: Theme.of(context).colorScheme.secondary),
                            empty:
                                Image.asset('assets/images/star_border.png',color: Theme.of(context).colorScheme.secondary),
                          ),
                          onRatingUpdate: (value) {
                            print(value);
                            reviewRating = value;
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              "Please share your opinion",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "about the product",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            elevation: 1,
                            child: TextField(
                              controller: textController,
                              onChanged: (value){
                                print(value);
                                print(controller.text);
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              maxLines: 5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                              const Text("Add your photo")
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.secondary),
                              onPressed: ()async {
                                print(controller.text);
                                String? errorMessage;
                                if(productId!=null){
                                  print("review product");
                                  await context.read<ShopProvider>().ReviewProduct(token:context.read<AuthenticateProvider>().token!,productId: productId!, review: textController.text, rating: reviewRating);
                                  errorMessage = context.read<ShopProvider>().httpResponseFlutter.errorMessage;
                                }

                                if (serviceId !=null){
                                  await context.read<BookingProvider>().postReviewService(token:context.read<AuthenticateProvider>().token!,serviceId: serviceId, review: textController.text, rating: reviewRating);
                                  errorMessage = context.read<ShopProvider>().httpResponseFlutter.errorMessage;
                                }
                                if (errorMessage != null){
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: errorMessage
                                    );
                                  }else{
                                    Navigator.of(context).pop(true);
                                    
                                  }

                              },
                              child: Text(
                                "SEND REVIEW",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  return rs;
}