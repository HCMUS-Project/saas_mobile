import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/models/order_model.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/widgets/cancle_widget.dart';
import 'package:mobilefinalhcmus/widgets/post_widget.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
    final total = widget.order.total;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(((AppLocalizations.of(context)!.translate('userOrders')!)['orderDetail']),
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      bottomNavigationBar: stateOfOrder == "pending"
          ? Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              height: 56,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                            BorderRadius.circular(5)))),
                        onPressed: () async {
                          final noteTextController = TextEditingController();
                          final rs = await cancelWidget(
                              context: context,
                              orderId: orderId,
                              textEditingController: noteTextController);
                          if (rs) {
                            await QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: "cancel successfully",
                                autoCloseDuration: Duration(seconds: 1));
                            await context
                                .read<ProfileProvider>()
                                .GetOrder(state: OrderState.pending.name);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('${((AppLocalizations.of(context)!.translate('cancel')!))}')),
                  ),
                  const SizedBox(
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
                                              BorderRadius.circular(5)))),
                          onPressed: () {},
                          child:  Text("${(AppLocalizations.of(context)!.translate('userOrders')!)['reorder']}")))
                ],
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                        child: Column(

                          children: [
                            Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${((AppLocalizations.of(context)!.translate('userOrders')!)['order'])}",style: Theme.of(context).textTheme.bodyMedium),
                                    Text(orderId.toString().split('-')[4].toUpperCase(),style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                                  ],
                                )),
                            Container(
                              height: constraints.maxHeight * 0.05,
                              decoration: const BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date",style: Theme.of(context).textTheme.bodyMedium),
                                  Text(
                                      "${dateOfOrder?.day}/${dateOfOrder?.month}/${dateOfOrder?.year}",style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            ((AppLocalizations.of(context)!.translate('userOrders')!)['status'])[stateOfOrder!] ,
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
                            color: Theme.of(context).textTheme.bodyMedium?.color,
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
                    ((AppLocalizations.of(context)!.translate('userOrders')!)['orderInformation']),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
      
                      border: Border.all(
                          width: 1,
                          color:
                              Theme.of(context).textTheme.bodyMedium!.color!)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text("${((AppLocalizations.of(context)!.translate('shippingAddress')!))}: "))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    address.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("${((AppLocalizations.of(context)!.translate('paymentMethod')!))}: ")),
                          Expanded(
                              child: Text(
                            "On cash",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("${((AppLocalizations.of(context)!.translate('deliveryMethod')!))}: ")),
                          Expanded(
                              child: Text(
                            "Xe om",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (voucherId != null)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(child: Text("Discount: ")),
                                Expanded(
                                    child: Text(
                                  voucherId.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text("${(AppLocalizations.of(context)!.translate('total')!)}: ")),
                          Expanded(
                              child: Text(
                            CurrencyConfig.convertTo(price: total!).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ))
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
                                                    .textTheme
                                                    .bodyMedium?.color,
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
