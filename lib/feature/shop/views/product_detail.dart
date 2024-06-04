import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/views/checkout_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/review_page.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:readmore/readmore.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({super.key, required this.product});

  ProductModel product;
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    print("rating ${product.rating}");
      print("number of rating ${product.numberRating}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                //product image
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(product.image![0]),
                            fit: BoxFit.fill)),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                onChanged: (value) {},
                                hint: Text("Size"),
                                items: items
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                onChanged: (value) {},
                                hint: Text("Color"),
                                items: items
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()),
                                onPressed: () {},
                                child: Image.asset("assets/images/heart.png")))
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            //title
                            Text(
                              product.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                            ),
                            Text(
                              "sub title",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                            RatingBar(
                              itemPadding: EdgeInsets.all(2),
                              itemSize: 18.0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              initialRating: 3.3,
                              ratingWidget: RatingWidget(
                                full: Image.asset('assets/images/heart.png'),
                                half:
                                    Image.asset('assets/images/heart_haft.png'),
                                empty: Image.asset(
                                    'assets/images/heart_border.png'),
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          ],
                        )),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  child: Text(
                                    CurrencyConfig.convertTo(
                                            price: product.price!)
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //Detail Product
                Container(
                  padding: EdgeInsets.all(8),
                  child: ReadMoreText(
                    delimiterStyle: TextStyle(overflow: TextOverflow.fade),
                    product.description!,
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                  ),
                ),

                //review
                Divider(),
                ReviewWidget(
                  numberOfRating: product.numberRating,
                  rating: product.rating,
                  productId: product.id,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.amber),
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(56, 56),
                            shape: BeveledRectangleBorder()),
                        onPressed: () async {
                          int counter = 1;
                          await showModalBottomSheet<bool>(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Container(
                                  padding: EdgeInsets.all(8),
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                      ),
                                                      child: Image(
                                                          image: NetworkImage(
                                                              product
                                                                  .image![0])),
                                                    )),
                                                Expanded(
                                                    flex: 7,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            CurrencyConfig.convertTo(
                                                                    price: product
                                                                        .price!)
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                          Text(
                                                            "Stock: ${product.quantity}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child:
                                                              Text("Quantity")),
                                                      Expanded(
                                                          child: Row(
                                                        children: [
                                                          ElevatedButton(
                                                              style: Theme.of(
                                                                      context)
                                                                  .elevatedButtonTheme
                                                                  .style
                                                                  ?.copyWith(
                                                                      shape: MaterialStatePropertyAll(
                                                                          CircleBorder())),
                                                              onPressed: () {
                                                                if ((counter -
                                                                        1) >
                                                                    0) {
                                                                  setState(
                                                                    () {
                                                                      counter--;
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              child: Icon(Icons
                                                                  .remove)),
                                                          Text("$counter"),
                                                          ElevatedButton(
                                                              style: Theme.of(
                                                                      context)
                                                                  .elevatedButtonTheme
                                                                  .style
                                                                  ?.copyWith(
                                                                      shape: MaterialStatePropertyAll(
                                                                          CircleBorder())),
                                                              onPressed: () {
                                                                if ((counter +
                                                                        1) <=
                                                                    product
                                                                        .quantity!)
                                                                  setState(
                                                                    () {
                                                                      counter++;
                                                                    },
                                                                  );
                                                              },
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                      Icons
                                                                          .add)))
                                                        ],
                                                      ))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await context
                                                  .read<CartProvider>()
                                                  .addToCart(
                                                      product: product,
                                                      quantity: counter,
                                                      token: context
                                                          .read<
                                                              AuthenticateProvider>()
                                                          .token!);
                                              final result = context
                                                  .read<CartProvider>()
                                                  .httpResponseFlutter
                                                  .result;
                                              if (result != null) {
                                                final renderBox =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final size = renderBox.size;
                                                print(size.height);
                                                print(size.width);
                                                final controller = showOverlay(
                                                    context: context,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent),
                                                      child: Container(
                                                        height:
                                                            size.height * 0.5,
                                                        width: size.width * 0.5,
                                                        child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            elevation: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary
                                                                .withAlpha(150),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  flex: 8,
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Image(
                                                                      image: AssetImage(
                                                                          "assets/images/logo_0.png"),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                      "Add success",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium
                                                                          ?.copyWith(
                                                                              fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    ));
                                                controller["show"]();
                                                await Future.delayed(
                                                    Duration(seconds: 1));
                                                controller['hide']();
                                                // final overlayController =
                                                //     showOverlay(
                                                //         context: context,
                                                //         child: Padding(
                                                //           padding:
                                                //               const EdgeInsets
                                                //                   .all(8.0),
                                                //           child: Column(
                                                //             children: [
                                                //               Image.asset(
                                                //                   'assets/images/check.png'),
                                                //               SizedBox(
                                                //                 height: 10,
                                                //               ),
                                                //               Text(
                                                //                   "Added to cart")
                                                //             ],
                                                //           ),
                                                //         ));
                                                // overlayController["show"]();
                                                // await Future.delayed(
                                                //     Duration(seconds: 1));
                                                // overlayController["hide"]();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Add to cart",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                            )),
                                      ))
                                    ],
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_sharp,
                              ),
                              Text("Add to cart",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ],
                          ),
                        )),
                  )),
              Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(56, 56),
                          shape: RoundedRectangleBorder()),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            List<CartModel> products = [];
                            products
                                .add(CartModel(product: product, quantity: 1));
                            return CheckOutPage(
                              total: product.price!,
                              products: products,
                            );
                          },
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Buy",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                          Text(
                            CurrencyConfig.convertTo(price: product.price!)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                          )
                        ],
                      )))
            ],
          )),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  ReviewWidget({super.key, this.productId, this.numberOfRating, this.rating});
  String? productId;
  double? rating;
  int? numberOfRating;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 60,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Product review"),
                          RatingBar(
                            itemPadding: EdgeInsets.all(2),
                            itemSize: 18.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ignoreGestures: true,
                            initialRating: 0,
                            ratingWidget: RatingWidget(
                              full: Image.asset('assets/images/heart.png'),
                              half: Image.asset('assets/images/heart_haft.png'),
                              empty:
                                  Image.asset('assets/images/heart_border.png'),
                            ),
                            onRatingUpdate: (value) {},
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ReviewPage(
                                  numberOfRating: numberOfRating,
                                  rating: rating,
                                  productId: productId!,
                                );
                              },
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("All"),
                              Icon(
                                Icons.arrow_forward,
                                size: 24,
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
          // Container(
          //   height: 100,
          //   child: ListView.builder(
          //     itemCount: 0,
          //     itemBuilder: (context, index) {
          //       return Container(

          //       );
          //   },),
          // ),
        ],
      ),
    );
  }
}
