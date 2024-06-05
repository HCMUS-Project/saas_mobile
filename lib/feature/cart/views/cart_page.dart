import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/views/checkout_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartProvider? cartProvider;
  @override
  void initState() {
    // TODO: implement initState
    cartProvider = context.read<CartProvider>();
    cartProvider?.setTotal = 0;
    cartProvider?.setSelectedList = [];

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartList = context.read<CartProvider>().cartList;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            )),
        title: Text("Cart"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white),
        child: FutureBuilder(
            future: context
                .read<CartProvider>()
                .getAllItem(token: context.read<AuthenticateProvider>().token!),
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
              final result =
                  context.read<CartProvider>().httpResponseFlutter.errorMessage;

              if (result != null) {
                return Container(
                  child: Center(
                    child: Text("No items"),
                  ),
                );
              }
              final carts = List<Map<String, dynamic>>.from(context
                  .read<CartProvider>()
                  .httpResponseFlutter
                  .result?['data']['carts']);

              final cartItems =
                  List<Map<String, dynamic>>.from(carts[0]['cartItems']);
              final cartId = carts[0]['id'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
             

                          return FutureBuilder(
                              future: context
                                  .read<ShopProvider>()
                                  .findProduct(
                                      domain: context.read<AuthenticateProvider>().domain!,
                                      productId: item['productId'],
                                  ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }
                                final data = snapshot.data?.result?['data'];

                                final cartItem = CartModel.fromJson({
                                  "product": ProductModel.fromJson(data),
                                  "quantity": item['quantity']
                                });
                               
                                int quantityChange = cartItem.quantity;
                                return StatefulBuilder(
                                  builder: (context, setState2) => Container(
                                    height: size.width / 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Checkbox(
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              onChanged: (value) {
                                                setState2(() {
                                                  cartItem.isSelected =
                                                      !cartItem.isSelected;
                                                
                                                  if (cartItem.isSelected) {
                                                  
                                                    context
                                                        .read<CartProvider>()
                                                        .updateCheckout(
                                                            typeFlag:
                                                                "ADD_ITEM",
                                                            item: cartItem);
                                                  } else {
                                                    context
                                                        .read<CartProvider>()
                                                        .updateCheckout(
                                                            typeFlag:
                                                                "REMOVE_ITEM",
                                                            item: cartItem);
                                                  }
                                                });
                                              },
                                              shape: BeveledRectangleBorder(
                                                  side: BorderSide(width: 1)),
                                              value: cartItem.isSelected,
                                            )),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              height: size.width * 0.3,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          (cartItem.product
                                                              .image![0])),
                                                      fit: BoxFit.fill)),
                                            )),
                                        Expanded(
                                            flex: 6,
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      flex: 7,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(cartItem
                                                                .product.name!),
                                                          ),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceAround,
                                                          //   children: [
                                                          //     Text(
                                                          //         "Color: Black"),
                                                          //     Text("Size: L")
                                                          //   ],
                                                          // ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape:
                                                                          CircleBorder(),
                                                                      minimumSize:
                                                                          Size(
                                                                              36,
                                                                              36),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white),
                                                                  onPressed:
                                                                      () async {
                                                                    await context.read<CartProvider>().updateCart(
                                                                        token: context
                                                                            .read<
                                                                                AuthenticateProvider>()
                                                                            .token!,
                                                                        cartId:
                                                                            cartId,
                                                                        quantity:
                                                                            quantityChange -
                                                                                1,
                                                                        productId: cartItem
                                                                            .product
                                                                            .id!);
                                                                    final result = context
                                                                        .read<
                                                                            CartProvider>()
                                                                        .httpResponseFlutter
                                                                        .result;
                                                                    if (result ==
                                                                        null) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  100),
                                                                          content: Text(context
                                                                              .read<CartProvider>()
                                                                              .httpResponseFlutter
                                                                              .errorMessage!)));
                                                                    } else {
                                                                      setState2(
                                                                        () {
                                                                          quantityChange =
                                                                              quantityChange - 1;
                                                                          cartItem.quantity =
                                                                              quantityChange;
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                              Text(
                                                                quantityChange
                                                                    .toString(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape:
                                                                          CircleBorder(),
                                                                      minimumSize:
                                                                          Size(
                                                                              36,
                                                                              36),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white),
                                                                  onPressed:
                                                                      () async {
                                                                    await context.read<CartProvider>().updateCart(
                                                                        token: context
                                                                            .read<
                                                                                AuthenticateProvider>()
                                                                            .token!,
                                                                        cartId:
                                                                            cartId,
                                                                        quantity:
                                                                            quantityChange +
                                                                                1,
                                                                        productId: cartItem
                                                                            .product
                                                                            .id!);
                                                                    final result = context
                                                                        .read<
                                                                            CartProvider>()
                                                                        .httpResponseFlutter
                                                                        .result;
                                                                    if (result ==
                                                                        null) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  100),
                                                                          content: Text(context
                                                                              .read<CartProvider>()
                                                                              .httpResponseFlutter
                                                                              .errorMessage!)));
                                                                    } else {
                                                                      setState2(
                                                                          () {
                                                                        quantityChange =
                                                                            quantityChange +
                                                                                1;
                                                                        cartItem.quantity =
                                                                            quantityChange;
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(Icons
                                                                      .more_vert)),
                                                            ),
                                                            Expanded(
                                                                flex: 8,
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      CurrencyConfig.convertTo(
                                                                              price: cartItem.product.price! * quantityChange)
                                                                          .toString(),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall,
                                                                    )))
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                  if (cartList.length > 0)
                    Row(
                      children: [
                        Text("Total amount: "),
                        Text(
                            "${CurrencyConfig.convertTo(price: context.read<CartProvider>().total).toString()}")
                      ],
                    ),
                  Expanded(
                      flex: 1,
                      child: Consumer(
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: context
                                    .watch<CartProvider>()
                                    .selectedList
                                    .isNotEmpty
                                ? () {
                                    final selectedListTemp = context.read<CartProvider>().selectedList;
                                    final totalTemp =  context.read<CartProvider>().total;
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) {
                                        return CheckOutPage(
                                          cartID: cartId as String,
                                          products: selectedListTemp,
                                          total: totalTemp,
                                        );
                                      },
                                    )).then((value) => setState(() {
                                              context
                                                  .read<CartProvider>()
                                                  .setSelectedList = [];
                                            }));
                                    context.read<CartProvider>().setTotal = 0;
                                    // cartProvider?.setTotal = 0;
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: context
                                          .watch<CartProvider>()
                                          .selectedList
                                          .isNotEmpty
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.grey),
                              child: Text(
                                "CHECK OUT",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          );
                        },
                      ))
                ],
              );
            }),
      ),
    );
  }
}
