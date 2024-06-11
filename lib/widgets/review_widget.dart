import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

void PostReview ({required BuildContext context, required TextEditingController textController, required String productId})async{
  double reviewRating = 0 ;
  TextEditingController controller = TextEditingController();
  print('qwekjqwhekjqwh');
  return showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
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
                          itemPadding: EdgeInsets.all(2),
                          itemSize: 35.0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: false,
                          initialRating: 0,
                          ratingWidget: RatingWidget(
                            full: Image.asset('assets/images/heart.png',color: Theme.of(context).colorScheme.secondary,),
                            half: Image.asset('assets/images/heart_haft.png',color: Theme.of(context).colorScheme.secondary),
                            empty:
                                Image.asset('assets/images/heart_border.png',color: Theme.of(context).colorScheme.secondary),
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
                          padding: EdgeInsets.all(8),
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            elevation: 1,
                            child: TextField(
                              controller: controller,
                              onChanged: (value){
                                print(value);
                                print(controller.text);
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              maxLines: 5,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                              Text("Add your photo")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.secondary),
                              onPressed: ()async {
                                print(controller.text);
                                await context.read<ShopProvider>().ReviewProduct(token:context.read<AuthenticateProvider>().token!,productId: productId, review: controller.text, rating: reviewRating);
                                final errorMessage = context.read<ShopProvider>().httpResponseFlutter.errorMessage;
                                if (errorMessage != null){
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: errorMessage
                                  );
                                }else{
                                  Navigator.of(context).pop();
                                  
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
}