import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/components/loading_screen.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/checkout/model/payment_method_model.dart';
import 'package:mobilefinalhcmus/feature/checkout/providers/checkout_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/models/voucher_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutPage extends StatefulWidget {
  List<CartModel>? products;
  int total;
  String? cartID;
  CheckOutPage({super.key, this.cartID, this.products, required this.total});

  late final provider;
  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  CheckoutProvider? _checkoutProvider;

  List<PaymentMethod> paymentMethods = [];
  List<VoucherModel> listChosenVoucher = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkoutProvider = context.read<CheckoutProvider>();
    _checkoutProvider!.addListener(_profileProviderListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _checkoutProvider?.removeListener(_profileProviderListener);
    super.dispose();
  }

  void _profileProviderListener() async {
    if (mounted) {
      final isLoading = _checkoutProvider!.httpResponseFlutter.isLoading;
      final flag = _checkoutProvider?.listenerFlag;
      if (flag == "METHOD_PAYMENT" || flag == "VOUCHER") {
      } else if (flag == "ORDER") {
        if (isLoading!) {
          LoadingScreen.instance().show(context: context);
        } else {
          LoadingScreen.instance().hide();
          if (_checkoutProvider!.httpResponseFlutter.errorMessage != null) {
            print(_checkoutProvider!.httpResponseFlutter.errorMessage);
          } else {
            print(_checkoutProvider!.httpResponseFlutter.result);

            final Uri url = Uri.parse(_checkoutProvider!
                .httpResponseFlutter.result?['data']['paymentUrl']);
            
            if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw Exception('Could not launch $url');
          }
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) {
            //     return SuccessPage();
            //   },
            // ));
          }
        }
      }
    }
  }

  List<Widget> listProducts({required List<CartModel> products}) {
    List<Widget> productReturn = [];

    for (int i = 0; i < products.length; i++) {
      final product = products[i].product;

      productReturn.add(Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image(
                              image: NetworkImage(product.image![0])),
                        )),
                    Expanded(
                        flex: 8,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${product.name}"),
                                Text(
                                    "Category: ${product.category![0]['name']}"),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Price: ${CurrencyConfig.convertTo(price: product.price!).toString()}"),
                                    Text("Quantity: ${products[i].quantity}")
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return productReturn;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final profile = context.read<AuthenticateProvider>().profile;
    print("checkout page");
    return FutureBuilder(
      future: context.read<CheckoutProvider>().getPaymentMethods(
          token: context.read<AuthenticateProvider>().token!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
            ),
       
          );
        }

        paymentMethods = List<PaymentMethod>.from(
            List<Map<String, dynamic>>.from(
                    snapshot.data?.result?['paymentMethods'])
                .map((e) => PaymentMethod.fromJson(e))
                .toList());
        return Scaffold(
     
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                
                )),
            automaticallyImplyLeading: false,
        
            scrolledUnderElevation: 0,
            title: Text("Checkout", style: Theme.of(context).textTheme.titleLarge,),
          ),
          body: Consumer<ProfileProvider>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      //Address
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shipping address",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Change",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?['username'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 18,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(profile?['phone']),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.home,
                                      size: 18,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(profile?['address']),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: listProducts(products: widget.products!),
                        ),
                      ),

                      //Voucher
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                shape: BoxShape.rectangle),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Consumer<CheckoutProvider>(
                                        builder: (context, value, child) {
                                          final flag = context
                                              .watch<CheckoutProvider>()
                                              .listenerFlag;
                                          print(flag);
                                          return Container(
                                            margin: const EdgeInsets.only(left: 2),
                                            alignment: Alignment.center,
                                            height: 40,
                                            child: Text(
                                              listChosenVoucher.isNotEmpty
                                                  ? listChosenVoucher[0]
                                                      .voucherName!
                                                  : "Have a promo code? Enter here",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 30,
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final voucher =
                                                await showModalBottomSheet(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              context: context,
                                              builder: (context) {
                                                return FutureBuilder(
                                                  future: context
                                                      .read<ShopProvider>()
                                                      .getAllVoucher(
                                                          domain: context
                                                              .read<
                                                                  AuthenticateProvider>()
                                                              .domain!),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container();
                                                    }
                                                    final result =
                                                        snapshot.data?.result;
                                                    final vouchers = List<
                                                            Map<String,
                                                                dynamic>>.from(
                                                        result?['vouchers']);
                                                    bool isChoose = true;

                                                    return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return Column(
                                                          children: [
                                                            Expanded(
                                                              flex: 10,
                                                              child: Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  width: double
                                                                      .infinity,
                                                                  child: ListView
                                                                      .separated(
                                                                    separatorBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            10,
                                                                      );
                                                                    },
                                                                    itemCount:
                                                                        vouchers
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final voucher =
                                                                          VoucherModel.fromJson(
                                                                              vouchers[index]);
                                                                      final expiredTime = DateFormat('dd-MM-yyyy').format(DateFormat(
                                                                              "EEE MMM dd yyyy HH:mm:ss 'GMT'Z")
                                                                          .parse(
                                                                              voucher.expireAt!)
                                                                          .toLocal());

                                                                      return Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            border: Border.all(
                                                                              color: Theme.of(context).colorScheme.secondary,
                                                                            )),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                                flex: 3,
                                                                                child: Container(
                                                                                  child: const Image(height: 100, width: 100, image: AssetImage("assets/images/voucher.png")),
                                                                                )),
                                                                            Expanded(
                                                                                flex: 7,
                                                                                child: Container(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        child: Text(
                                                                                          "${voucher.voucherCode}",
                                                                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        child: Text("Max discount: ${CurrencyConfig.convertTo(price: voucher.maxDiscount!).toString()}"),
                                                                                      ),
                                                                                      Container(
                                                                                        child: Text("Min order: ${CurrencyConfig.convertTo(price: voucher.minAppValue!).toString()}"),
                                                                                      ),
                                                                                      Container(child: Text("Expired $expiredTime"))
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                            Expanded(
                                                                                child: Checkbox(
                                                                              checkColor: Theme.of(context).colorScheme.secondary,
                                                                              shape: const CircleBorder(),
                                                                              side: WidgetStateBorderSide.resolveWith(
                                                                                (states) => BorderSide(width: 1.0, color: Theme.of(context).colorScheme.secondary),
                                                                              ),
                                                                              fillColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                                                                              value: listChosenVoucher.where((element) => element.id == voucher.id).isNotEmpty,
                                                                              onChanged: (value) {
                                                                                print(value);
                                                                                setState(
                                                                                  () {
                                                                                    if (value!) {
                                                                                      listChosenVoucher.add(voucher);
                                                                                    } else {
                                                                                      listChosenVoucher.removeWhere(
                                                                                        (element) {
                                                                                          return element.id == voucher.id;
                                                                                        },
                                                                                      );
                                                                                      print(listChosenVoucher);
                                                                                    }
                                                                                  },
                                                                                );
                                                                              },
                                                                            ))
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  )),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          "${listChosenVoucher.length} have been chosen"),
                                                                    )),
                                                                    Expanded(
                                                                      child: SizedBox(
                                                                          width: double.infinity,
                                                                          child: ElevatedButton(
                                                                              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(shape: const WidgetStatePropertyAll(BeveledRectangleBorder())),
                                                                              onPressed: () {
                                                                                context.read<CheckoutProvider>().listenerFlag = "VOUCHER";
                                                                                context.read<CheckoutProvider>().update();
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text("Agree"))),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: const Text("Apply"),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),

                      //Payment
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payment method",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (context) {
                                          print("object");
                                          return Container(
                                            height: 500,
                                            padding: const EdgeInsets.all(15),
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 5,
                                                  width: 50,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.grey),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        paymentMethods.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final paymentMethod =
                                                          paymentMethods[index];

                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    8),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                border: Border.all(
                                                                    color: context.watch<CheckoutProvider>().selectedPayMethod ==
                                                                            index
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .transparent)),
                                                            child: ListTile(
                                                              onTap: () {
                                                                context
                                                                        .read<
                                                                            CheckoutProvider>()
                                                                        .listenerFlag =
                                                                    "METHOD_PAYMENT";
                                                                context
                                                                    .read<
                                                                        CheckoutProvider>()
                                                                    .setSelectedPayMethod(
                                                                        index);

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              trailing: const Icon(Icons
                                                                  .arrow_forward_ios),
                                                              title: Text(
                                                                paymentMethod
                                                                    .type!,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                              leading: Image(
                                                                  height: 64,
                                                                  width: 64,
                                                                  image: AssetImage(
                                                                      (paymentMethod
                                                                          .imageUrl!))),
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Change",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            Consumer<CheckoutProvider>(
                              builder: (context, value, child) {
                                final selectedPaymentMethod =
                                    value.selectedPayMethod;
                                return SizedBox(
                                  height: size.width / 5,
                                 
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Image(
                                            height: 64,
                                            width: 64,
                                            image: AssetImage(paymentMethods[
                                                    selectedPaymentMethod]
                                                .imageUrl!)),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          paymentMethods[selectedPaymentMethod]
                                              .type!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // delivery method
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Method",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: size.width / 5,
                              width: size.width,
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(15),
                              //   boxShadow: [
                              //     BoxShadow(
                              //         color: Colors.grey.shade300, //New
                              //         blurRadius: 10.0,
                              //         offset: Offset(0, -2))
                              //   ],
                              // ),
                              child: ListView.builder(
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 150,
                                    width: size.width / 2,
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side:
                                              const BorderSide(color: Colors.black)),
                                      elevation: 1,
                                      child: const Column(
                                        children: [
                                          Text("Normal"),
                                          Text("2 - 3 day")
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      //description order
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Description Order",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Order:"),
                                    Text(
                                      "${CurrencyConfig.convertTo(price: (widget.total))}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery:"),
                                    Text(
                                      "${CurrencyConfig.convertTo(price: 15000)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Summary:"),
                                    Text(
                                      "${CurrencyConfig.convertTo(price: (widget.total) + 15000)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                    flex: 7,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Total"),
                          Text(
                            "${CurrencyConfig.convertTo(price: (widget.total) + 15000)}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.amber),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const BeveledRectangleBorder()),
                          onPressed: () async {
                            List<ProductModel> products = [];
                            widget.products?.forEach((element) {
                              products.add(element.product);
                            });
                            context.read<CheckoutProvider>().listenerFlag =
                                "ORDER";
                            final indexPaymentMethod = context
                                .read<CheckoutProvider>()
                                .selectedPayMethod;

                            await context.read<CheckoutProvider>().createOrder(
                                paymentMethod:
                                    paymentMethods[indexPaymentMethod].id!,
                                voucherId: listChosenVoucher.isNotEmpty
                                    ? listChosenVoucher[0].id
                                    : null,
                                token:
                                    context.read<AuthenticateProvider>().token!,
                                productsId: products.map((e) => e.id!).toList(),
                                quantities: widget.products!
                                    .map((e) => e.quantity)
                                    .toList(),
                                phone: profile?['phone'],
                                address: profile?['address']);
                          },
                          child: Text(
                            "Order",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
