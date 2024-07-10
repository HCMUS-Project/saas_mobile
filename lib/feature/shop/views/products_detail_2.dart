import 'dart:async';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:mobilefinalhcmus/components/show_overlay.dart';

import 'package:mobilefinalhcmus/config/currency_config.dart';

import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/views/checkout_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/model/review_model.dart';

import 'package:mobilefinalhcmus/feature/shop/views/review/review_page.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/test1.dart';
import 'package:provider/provider.dart';

import 'package:readmore/readmore.dart';

class ProductDetail2 extends StatefulWidget {
  ProductDetail2({super.key, required this.product});
  ProductModel product;
  @override
  State<ProductDetail2> createState() => _ProductDetail2State();
}

class _ProductDetail2State extends State<ProductDetail2>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: ShowListImageOfProduct(product: product),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                                height: 32,
                                width: 32,
                                child: Image(
                                  color:   Color(0xFFFFC107),
                                    image:
                                        AssetImage("assets/images/star.png"))),
                            Text("${product.rating} (${product.numberRating})")
                          ],
                        ),
                        Container(
                            child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ))
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      CurrencyConfig.convertTo(price: product.price!)
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.category?[0]['name'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate('description')!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ReadMoreText(
                          delimiterStyle:
                              const TextStyle(overflow: TextOverflow.fade),
                          product.description!,
                          trimMode: TrimMode.Line,
                          trimLines: 2,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: ShowReview(product: product)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: (product.quantity!) > 0
                ? Container(
                    alignment: Alignment.center,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(56, 56),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
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
                                            padding: const EdgeInsets.all(8),
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
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                child: Image(
                                                                    image: NetworkImage(
                                                                        product.image![
                                                                            0])),
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
                                                                              price: product.price!)
                                                                          .toString(),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge
                                                                          ?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
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
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                const Expanded(
                                                                    child: Text(
                                                                        "Quantity")),
                                                                Expanded(
                                                                    child: Row(
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: Theme.of(context)
                                                                            .elevatedButtonTheme
                                                                            .style
                                                                            ?.copyWith(
                                                                                shape: const MaterialStatePropertyAll(
                                                                                    CircleBorder())),
                                                                        onPressed:
                                                                            () {
                                                                          if ((counter - 1) >
                                                                              0) {
                                                                            setState(
                                                                              () {
                                                                                counter--;
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                        child: const Icon(
                                                                            Icons.remove)),
                                                                    Text(
                                                                        "$counter"),
                                                                    ElevatedButton(
                                                                        style: Theme.of(context)
                                                                            .elevatedButtonTheme
                                                                            .style
                                                                            ?.copyWith(
                                                                                shape: const MaterialStatePropertyAll(
                                                                                    CircleBorder())),
                                                                        onPressed:
                                                                            () {
                                                                          if ((counter + 1) <=
                                                                              product.quantity!) {
                                                                            setState(
                                                                              () {
                                                                                counter++;
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                        child: const Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: Icon(Icons.add)))
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
                                                    child: SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (context
                                                                .read<
                                                                    AuthenticateProvider>()
                                                                .token ==
                                                            null) {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) {
                                                              return LoginPage();
                                                            },
                                                          ));
                                                        } else {
                                                          await context
                                                              .read<
                                                                  CartProvider>()
                                                              .addToCart(
                                                                  product:
                                                                      product,
                                                                  quantity:
                                                                      counter,
                                                                  token: context
                                                                      .read<
                                                                          AuthenticateProvider>()
                                                                      .token!);
                                                          final result = context
                                                              .read<
                                                                  CartProvider>()
                                                              .httpResponseFlutter
                                                              .result;
                                                          if (result != null) {
                                                            final renderBox =
                                                                context.findRenderObject()
                                                                    as RenderBox;
                                                            final size =
                                                                renderBox.size;
                                                            print(size.height);
                                                            print(size.width);
                                                            final controller =
                                                                showOverlay(
                                                                    context:
                                                                        context,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Colors.transparent),
                                                                      child:
                                                                          SizedBox(
                                                                        height: size.height *
                                                                            0.5,
                                                                        width: size.width *
                                                                            0.5,
                                                                        child: Material(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            elevation: 1,
                                                                            color: Theme.of(context).colorScheme.primary.withAlpha(150),
                                                                            child: Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 8,
                                                                                  child: Container(
                                                                                    child: const Image(
                                                                                      image: AssetImage("assets/images/logo_0.png"),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    child: Text(
                                                                                      "Add success",
                                                                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    ));
                                                            controller[
                                                                "show"]();
                                                            await Future.delayed(
                                                                const Duration(
                                                                    seconds:
                                                                        1));
                                                            controller[
                                                                'hide']();
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child: Text(
                                                        "Add to cart",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                color: Theme.of(
                                                                        context)
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
                                        const Icon(
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
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(56, 56),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () async {
                                    if (context
                                            .read<AuthenticateProvider>()
                                            .token ==
                                        null) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return LoginPage();
                                        },
                                      ));
                                    } else {
                                      await context
                                          .read<CartProvider>()
                                          .addToCart(
                                              product: product,
                                              quantity: 1,
                                              token: context
                                                  .read<AuthenticateProvider>()
                                                  .token!);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          List<CartModel> products = [];

                                          products.add(CartModel(
                                              product: product, quantity: 1));
                                          return CheckOutPage(
                                            total: product.price!,
                                            products: products,
                                          );
                                        },
                                      ));
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        CurrencyConfig.convertTo(
                                                price: product.price!)
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                      )
                                    ],
                                  )),
                            ))
                      ],
                    ))
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const BeveledRectangleBorder(),
                            fixedSize: const Size(56, 56)),
                        onPressed: product.quantity! > 0 ? () {} : null,
                        child: const Text("SOLD OUT")),
                  ),
          )
        ],
      ),
    );
  }
}

class ShowReview extends StatefulWidget {
  const ShowReview({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<ShowReview> createState() => _ShowReviewState();
}

class _ShowReviewState extends State<ShowReview> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ShopProvider>().reviewOfProduct(
          domain: context.read<AuthenticateProvider>().domain,
          page: 1,
          pageSize: 5,
          productId: widget.product.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
                      child: CircularProgressIndicator(),
                    );
        }
        final rs = snapshot.data?.result;
        List<ReviewModel> reviews = List<Map<String, dynamic>>.from(rs?['reviews']).map((e) => ReviewModel.fromJson(e)).toList();

        return Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.translate('review')!} (${reviews.length})",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ReviewPage(
                                    numberOfRating: widget.product.numberRating,
                                    rating: widget.product.rating,
                                    productId: widget.product.id!,
                                  );
                                },
                              )).then((value) {
                                setState(() {
                                  
                                });
                              });
                            },
                            icon:
                                const Icon(Icons.arrow_forward_ios, size: 12)))
                  ],
                ),
              ),
              Container(
                child: Column(
                  children:convertToReview(reviews),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> convertToReview(List<ReviewModel> reviews){
    List<Widget> data =[];
    for (int i = 0; i < reviews.length; i++){
      final review = reviews[i];
      data.add(Container(
                
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/man.png"),
                          ),
                        )),
                    Flexible(
                      fit: FlexFit.loose,
                        flex: 8,
                        child: Container(  
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review.user!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight:
                                                    FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Image(
                                            height: 32,
                                            width: 32,
                                            image: AssetImage(
                                                'assets/images/star.png'),
                                            color: Color(0xFFFFC107),
                                          ),
                                          Text(review.rating.toString())
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 9,
                                child: Container(
                                  
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    review.review!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ));
    }
    return data;
  }
}

class ShowListImageOfProduct extends StatefulWidget {
  const ShowListImageOfProduct({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<ShowListImageOfProduct> createState() => _ShowListImageOfProductState();
}

class _ShowListImageOfProductState extends State<ShowListImageOfProduct> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(),
          child: GestureDetector(
              onTap: () {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: [SystemUiOverlay.bottom]);
                CustomImageProvider customImageProvider = CustomImageProvider(
                    imageUrls: widget.product.image!,
                    initialIndex: selectedImage);
                showImageViewerPager(context, customImageProvider,
                    immersive: false,
                    swipeDismissible: true,
                    doubleTapZoomable: true, onPageChanged: (page) {
                  // print("Page changed to $page");
                }, onViewerDismissed: (page) {
                  // print("Dismissed while on page $page");
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: SystemUiOverlay.values);
                  setState(() {
                    selectedImage = page;
                  });
                });
              },
              child: Image(
                  image: NetworkImage(widget.product.image![selectedImage]))),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final image = widget.product.image![index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = index;
                      });
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedImage == index
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Material(
                        elevation: 1,
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              image: NetworkImage(image),
                              fit: BoxFit.fill,
                              width: 80,
                            )),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: widget.product.image!.length),
          ),
        )
      ],
    );
  }
}

