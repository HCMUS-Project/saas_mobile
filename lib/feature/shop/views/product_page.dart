import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/views/cart_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/products_detail_2.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/show_all_product.dart';
import 'package:mobilefinalhcmus/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  StreamController<String>? showProductStream;

  int selectedCategory = 0;

  int selectedGrid = 1;

  @override
  void initState() {
    // TODO: implement initState

    if (showProductStream != null) {
    } else {
      showProductStream = StreamController();
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    showProductStream?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double widthContainer = 250;
    return Scaffold(
      appBar: const ProductPageAppBar(),
      body: FutureBuilder(
          future: context.read<ShopProvider>().getAllProduct(
                domain: context.read<AuthenticateProvider>().domain!,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            }
            List<Map<String, dynamic>> products = [];
            var result =
                context.read<ShopProvider>().httpResponseFlutter.result;
            if (result != null) {
              products = List<Map<String, dynamic>>.from(result['products']);
            }

            return Container(
              
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.secondary,
                onRefresh: () async{
                  setState(() {
                    
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ShowCategoryOfProduct(
                        funct: context.read<ShopProvider>().findProductRecommend(
                            domain: context.read<AuthenticateProvider>().domain!),
                        titleCategory: "Top Recommend",
                        widthContainer: widthContainer,
                      ),
                      ShowCategoryOfProduct(
                        funct: context.read<ShopProvider>().findProductTopSeller(
                            domain: context.read<AuthenticateProvider>().domain!),
                        titleCategory: "Top Seller",
                        widthContainer: widthContainer,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: widthContainer,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn.shopify.com/s/files/1/2384/0833/files/1_Quiff_1024x1024.jpg?v=1668876008"),
                                  fit: BoxFit.fill),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      result == null
                          ? Container(
                              child: Column(
                                  children: List.generate(
                                      5, (index) => buildSkeleton(context))))
                          : ShowProduct(
                              selectedGrid: selectedGrid,
                              showProductStream: showProductStream,
                              productList: products,
                            )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ShowCategoryOfProduct extends StatelessWidget {
  ShowCategoryOfProduct(
      {super.key,
      this.funct,
      required this.widthContainer,
      required this.titleCategory});
  final String titleCategory;
  final double widthContainer;

  Future<HttpResponseFlutter>? funct;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<HttpResponseFlutter>(
      future: funct,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Container(
        //     decoration: BoxDecoration(color: Colors.transparent),
        //   );
        // }

        final result = snapshot.data?.result;

        List<Map<String, dynamic>> products = [];

        if (result != null) {
          products = List<Map<String, dynamic>>.from(result['products']);
        }

        return Container(
          padding: const EdgeInsets.all(8),
          height: widthContainer * 3 / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  titleCategory,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(
                flex: 10,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: result == null ? 5 : products.length,
                  itemBuilder: (context, index) {
                    ProductModel product = ProductModel();
                    if (result != null) {
                      product = ProductModel.fromJson(products[index]);
                    }

                    return result == null
                        ? buildSkeleton(context)
                        : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  width: widthContainer,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: widthContainer,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    product.image![0]),
                                                fit: BoxFit.fill)),
                                      ),
                                      Text(
                                        product.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Text(
                                                    CurrencyConfig.convertTo(
                                                            price: product.price!)
                                                        .toString()),
                                              )),
                                          Expanded(
                                              flex: 7,
                                              child: Builder(builder: (context) {
                                                return Container(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                                            ),
                                                      ),
                                                      onPressed:
                                                          product.quantity! > 0
                                                              ? () async {
                                                                  if (context
                                                                          .read<
                                                                              AuthenticateProvider>()
                                                                          .token !=
                                                                      null) {
                                                                    await context.read<CartProvider>().addToCart(
                                                                        product:
                                                                            product,
                                                                        quantity:
                                                                            1,
                                                                        token: context
                                                                            .read<
                                                                                AuthenticateProvider>()
                                                                            .token!);
                                                                    final result = context
                                                                        .read<
                                                                            CartProvider>()
                                                                        .httpResponseFlutter
                                                                        .result;
                          
                                                                    if (result !=
                                                                        null) {
                                                                      final controller =
                                                                          showOverlay(
                                                                              context:
                                                                                  context,
                                                                              child:
                                                                                  Container(
                                                                                alignment: Alignment.center,
                                                                                child: SizedBox(
                                                                                  height: size.height * 0.2,
                                                                                  width: size.width * 0.5,
                                                                                  child: Material(
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                      elevation: 1,
                                                                                      color: Theme.of(context).colorScheme.secondary.withAlpha(150),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            flex: 8,
                                                                                            child: Container(
                                                                                              child: Image(
                                                                                                height: 32,
                                                                                                width: 32,
                                                                                                image: NetworkImage((context.read<ThemeProvider>().tenant?.tenantProfile?.logo)!),
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
                                                                      await Future.delayed(const Duration(
                                                                          seconds:
                                                                              1));
                                                                      controller[
                                                                          'hide']();
                                                                    }
                                                                  } else {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                            MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                        return LoginPage();
                                                                      },
                                                                    ));
                                                                  }
                                                                }
                                                              : null,
                                                      child: product.quantity! > 0
                                                          ? Text(
                                                              "Add to cart",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                            )
                                                          : Text(
                                                              "Sold out",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                            )),
                                                );
                                              })),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: Text(
        "Saas Product",
        style: Theme.of(context)
            .textTheme
            .titleLarge
      ),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              if (context.read<AuthenticateProvider>().token == null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const CartPage();
                  },
                ));
              }
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
            )),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}

class ShowProduct extends StatefulWidget {
  ShowProduct(
      {super.key, required this.productList,
      required this.showProductStream,
      required this.selectedGrid});

  StreamController<String>? showProductStream;
  List<Map<String, dynamic>> productList;
  int selectedGrid;
  int selectedCategory = 0;
  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  int itemlength = 5;
  List<String> categoryList = [];
  @override
  void initState() {
    // TODO: implement initState
    categoryList.add("All");
    categoryList = widget.productList
        .map<String>((e) =>
            (List<Map<String, dynamic>>.from(e['categories']))[0]['name'])
        .toList();
    categoryList = categoryList.toSet().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Map<String, dynamic>> productData = widget.productList;

    productData = categoryList[widget.selectedCategory] == "All"
        ? widget.productList
        : widget.productList.where(
            (element) {
              return (List<Map<String, dynamic>>.from(element['categories']))[0]
                      ['name'] ==
                  categoryList[widget.selectedCategory];
            },
          ).toList();

    double sizeof10item = (size.width) * 0.37;
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              String category = categoryList[index];
              Color backgroundColor = widget.selectedCategory == index
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary;
              Color textColor = widget.selectedCategory == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary;
              return Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.5,
                      backgroundColor: backgroundColor,
                    ),
                    onPressed: () {
                      widget.showProductStream?.add(category);
                      setState(() {
                        widget.selectedCategory = index;
                      });
                    },
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
              );
            },
          ),
        ),
        Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  children: convertToArrayProduct(productData),
                ),
                SizedBox(
                  width: size.width / 3,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: const BorderSide(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ShowAllProduct(
                              products: widget.productList,
                            );
                          },
                        ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "More",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> convertToArrayProduct(List<Map<String, dynamic>> productData) {
    List<Widget> data = [];
    for (int i = 0; i < productData.length; i++) {
      ProductModel product = ProductModel.fromJson(productData[i]);

      data.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ProductDetail2(
                product: product,
              );
            },
          ));
        },
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration
          (
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.image![0]),
                          fit: BoxFit.fill)),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  // decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.description!,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        RatingBar(
                          ignoreGestures: true,
                          itemPadding: const EdgeInsets.all(2),
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          initialRating: product.rating!,
                          ratingWidget: RatingWidget(
                            full: Image.asset('assets/images/star_full.png'),
                            half: Image.asset('assets/images/star_half.png'),
                            empty:
                                Image.asset('assets/images/star_border.png'),
                          ),
                          onRatingUpdate: (value) {},
                        ),
                        Text(CurrencyConfig.convertTo(price: product.price!)
                            .toString())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return data;
  }
}
