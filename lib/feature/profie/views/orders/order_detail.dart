import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/models/order_model.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/widgets/review_widget.dart';
import 'package:provider/provider.dart';

class OrderDetail extends StatefulWidget {
  OrderModel order;
  OrderDetail({super.key, required this.order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // TODO: implement build
    final orderId = widget.order.trackingNumber;
    final dateOfOrder = widget.order.date;
    final stateOfOrder = widget.order.stateOrder;
    final numberOfProduct = widget.order.products?.length;
    final products = widget.order.products;
    final address = widget.order.address;
    // final phone = widget.order.phone;
    final voucherId = widget.order.voucherId;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Order Details",
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 56,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child:
                  ElevatedButton(onPressed: () {}, child: const Text("Cancel")),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Reorder")))
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 8,
                                child: Container(
                                    child: Text("OrderId: $orderId"))),
                            Flexible(
                                flex: 2,
                                child: Container(
                                  height: constraints.maxHeight * 0.05,
                                  decoration: const BoxDecoration(),
                                  child: Text(
                                      "${dateOfOrder?.day}/${dateOfOrder?.month}/${dateOfOrder?.year}"),
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            stateOfOrder!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                //quantity items
                Row(
                  children: [
                    Text(
                      "$numberOfProduct ${numberOfProduct.toString() == 1.toString() ? "item" : "items"}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                FutureBuilder(
                  future: fetchItem(context: context, products: products!),
                  builder: (context, snapshot) {
                    final product = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: snapshot.data!,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // order information
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Order information",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: const Text("Shipping address: "))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(address.toString()))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Expanded(child: Text("Payment method: ")),
                          Expanded(child: Text("On cash"))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Expanded(child: Text("Delivery method: ")),
                          Expanded(child: Text("Xe om"))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: Text("Discount: ")),
                          Expanded(child: Text(voucherId.toString()))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text("Total Amount: ")),
                          Expanded(child: Text(""))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> fetchItem(
      {required List<Map<String, dynamic>> products,
      required BuildContext context}) async {
    List<Widget> data = [];
    for (int i = 0; i < products.length; i++) {
      //before
      final product = products[i];
      print(product);
      HttpResponseFlutter response =
          await context.read<ShopProvider>().findProduct(
                domain: context.read<AuthenticateProvider>().domain!,
                productId: product['productId'],
              );

      //after
      final convertToProduct = ProductModel.fromJson(response.result?['data']);
      data.add(Container(
        margin: const EdgeInsets.only(top: 5),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Image(
                        width: 100,
                        height: 100,
                        image: NetworkImage(convertToProduct.image![0]),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //title
                                      Text(
                                        convertToProduct.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      //desc
                                      Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        convertToProduct.description!,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child:
                                      context.read<ProfileProvider>().state ==
                                              OrderState.completed.name
                                          ? TextButton(
                                              onPressed: () {
                                                PostReview(
                                                    context: context,
                                                    textController:
                                                        commentController,
                                                    productId:
                                                        product['productId']);
                                              },
                                              child: Icon(
                                                Icons.comment,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            )
                                          : null,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Quantity: ${product['quantity'].toString()}"),
                                Text(CurrencyConfig.convertTo(
                                        price: convertToProduct.price!)
                                    .toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ));
    }
    return data;
  }
}
