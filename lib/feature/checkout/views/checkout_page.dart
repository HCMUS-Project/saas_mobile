import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/components/loading_screen.dart';
import 'package:mobilefinalhcmus/components/success_page.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/model/delivery_method_model.dart';
import 'package:mobilefinalhcmus/feature/checkout/providers/checkout_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

List<PaymentMethod> paymentMethodList = [
  PaymentMethod(
      imageUrl:
          "https://cdn.haitrieu.com/wp-content/uploads/2022/10/Icon-VNPAY-QR.png",
      nameOfMethod: "VNPAY"),
  PaymentMethod(
      imageUrl: "https://cdn-icons-png.flaticon.com/512/429/429777.png",
      nameOfMethod: "On Cash"),
];

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
  int selectedPaymentMethod = 0;

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

  void _profileProviderListener() {
    if (mounted) {
      final isLoading = _checkoutProvider!.httpResponseFlutter.isLoading;
      if (isLoading!) {
        LoadingScreen.instance().show(context: context);
      } else {
        LoadingScreen.instance().hide();
        if (_checkoutProvider!.httpResponseFlutter.errorMessage != null){
          print(_checkoutProvider!.httpResponseFlutter.errorMessage);
        }else{
          Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return SuccessPage();
          },
        ));
        }
        
      }
    }
  }

  List<Widget> listProducts({required List<CartModel> products}) {
    List<Widget> productReturn = [];
    for (int i = 0; i < products.length; i++) {
      final product = products[i].product;

      productReturn.add(
        Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nike",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              ),
                            child: Image(image: NetworkImage("${product.image![0]}")),
                          )
                        ),
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            )),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text("Checkout"),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  //Address
                  Container(
                    padding: EdgeInsets.all(5),
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
                                  .titleLarge
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
                                Icon(
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
                                Icon(
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
                 
                  //voucher
                  Container(
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text("Have a promo code? Enter here"),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            child: Text("Apply"),
                          ),
                        )
                      ],
                    )

                  ),

                  //Payment
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment method",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 500,
                                        padding: EdgeInsets.all(15),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 5,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey),
                                            ),
                                            Expanded(
                                              flex: 10,
                                              child: ListView.builder(
                                                itemCount:
                                                    paymentMethodList.length,
                                                itemBuilder: (context, index) {
                                                  final paymentMethod =
                                                      paymentMethodList[index];
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Colors
                                                                .grey.shade300,
                                                            border: Border.all(
                                                                color: selectedPaymentMethod ==
                                                                        index
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent)),
                                                        child: ListTile(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedPaymentMethod =
                                                                  index;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          trailing: Icon(Icons
                                                              .arrow_forward_ios),
                                                          title: Text(
                                                            paymentMethod
                                                                .nameOfMethod!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          leading: Image(
                                                              height: 64,
                                                              width: 64,
                                                              image: NetworkImage(
                                                                  paymentMethod
                                                                      .imageUrl!)),
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
                        Container(
                          height: size.width / 5,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Image(
                                    height: 64,
                                    width: 64,
                                    image: NetworkImage(
                                        paymentMethodList[selectedPaymentMethod]
                                            .imageUrl!)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                paymentMethodList[selectedPaymentMethod]
                                    .nameOfMethod!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // delivery method
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Method",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.black)),
                                  elevation: 1,
                                  child: Column(
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
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discription Order",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order:"),
                                Text(
                                  "${CurrencyConfig.convertTo(price: (widget.total))}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery:"),
                                Text(
                                  "${CurrencyConfig.convertTo(price: 15000)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Summary:"),
                                Text(
                                  "${CurrencyConfig.convertTo(price: (widget.total) + 15000)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
      bottomNavigationBar: Container(
        height: 56,
        child: Row(
          children: [
            Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Total"),
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
                decoration: BoxDecoration(color: Colors.amber),
                child: SizedBox.expand(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          
                          shape: BeveledRectangleBorder()),
                      onPressed: () async {
                        List<ProductModel> products = [];
                        widget.products?.forEach((element) {
                          products.add(element.product);
                        });

                        await context.read<CheckoutProvider>().createOrder(
                            token: context.read<AuthenticateProvider>().token!,
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
                            ?.copyWith(color: Theme.of(context).colorScheme.primary),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
