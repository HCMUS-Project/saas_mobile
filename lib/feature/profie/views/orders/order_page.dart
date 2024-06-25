import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/models/order_model.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/profie/views/orders/order_detail.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
            "My orders",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          const SizedBox(height: 50, child: StateOfOrders()),
          Expanded(
              child: Container(
            child: const ShowOrders(),
          ))
        ],
      ),
    );
  }
}

class StateOfOrders extends StatefulWidget {
  const StateOfOrders({super.key});

  @override
  State<StateOfOrders> createState() => _StateOfOrdersState();
}

class _StateOfOrdersState extends State<StateOfOrders> {
  int _selectedStateIndex = 0;
  List<Widget> stateList = [];
  late ProfileProvider profileProvider;
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
  }
   
  @override
  Widget build(BuildContext context) {
    //declare again when rebuild
    stateList = [];
    for (int index = 0; index < OrderState.values.length; index++) {
      OrderState state = OrderState.values[index];
      stateList.add(Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: _selectedStateIndex == index
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
              ),
              onPressed: () async {
                await context.read<ProfileProvider>().GetOrder(state: state.name);
                setState(() {
                  _selectedStateIndex = index;
                });
              },
              child: Text(
                state.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        _selectedStateIndex == index ? Colors.white : Colors.black),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ));
    }
    return Container(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stateList,
          ),
        ));
  }
}

class ShowOrders extends StatelessWidget {
  const ShowOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileProvider>().state;
    // var orderList = context.read<ProfileProvider>().orderList;
    print(state);
    // orderList = orderList
    //     .where(
    //       (element) => element.stateOrder == state,
    //     )
    //     .toList();
    // print(orderList);
    return FutureBuilder(
      future: context.read<ProfileProvider>().getAllOrder(
          token: context.read<AuthenticateProvider>().token!, stage: state),
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
        final data = Map<String, dynamic>.from(context
            .read<ProfileProvider>()
            .httpResponseFlutter
            .result?['data']);
            
        final orderList = List<Map<String, dynamic>>.from(data['orders']);
        orderList.sort((a, b) {
          final orderA = OrderModel.toJson(a);
          final orderB = OrderModel.toJson(b);
          return orderB.date!.compareTo(orderA.date!);
        },);

        return Container(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                OrderModel order = OrderModel.toJson(orderList[index]);
             
                return OrderWidget(
                  orderModel: order,
                );
              },
            ));
      },
    );
  }
}

class OrderWidget extends StatelessWidget {
  OrderWidget({required this.orderModel, super.key});
  OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetail(order: orderModel),));
        },
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Row(
               
                  children: [
                    Expanded(
                      child:Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Image(image: AssetImage("assets/images/social-media.png", ), height: 32,width: 32,)),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(orderModel.stateOrder!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.blue
                              ),),
                              Text(DateFormat("dd MM yyyy").format(orderModel.date!),style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold
                              ),)
                            ],),
                          )
            
                        ],
                      ) 
                    ),
                    
                    const Expanded(
                     
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios,size: 12,)))
                  ],
                ),
                const SizedBox(
                      height: 10,
                    ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Icon(Icons.info_outline_rounded,size: 32, )),
                          Expanded(
                            flex: 8,
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order", style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600
                              ),),
                               Text(orderModel.trackingNumber!.split("-")[4].toUpperCase(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                
                                fontWeight: FontWeight.w600
                              ),)
                            ],
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Image(image: AssetImage('assets/images/price-tag.png'), width: 32,height: 32,)),
                          Expanded(
                            flex: 8,
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price", style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600
                              ),),
                               Text(CurrencyConfig.convertTo(price: orderModel.total!) .toString(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                
                                fontWeight: FontWeight.w600
                              ),)
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       flex: 7,
                //       child: Container(
                //         child: Text("Order Id: ${orderModel.trackingNumber}"),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 3,
                //       child: Container(
                //         alignment: Alignment.topRight,
                //         child: Text(
                //             "${orderModel.date?.day}/${orderModel.date?.month}/${orderModel.date?.year}"),
                //       ),
                //     )
                //   ],
                // ),
                // // Container(
                // //   alignment: Alignment.centerLeft,
                // //   child: Text("Tracking number: ${orderModel.trackingNumber}"),
                // // ),
                // Row(
                //   children: [
                //     Expanded(
                //         child: Row(
                //       children: [
                //         Text("Quantity: "),
                //         Text("${orderModel.quantity}")
                //       ],
                //     )),
                //     Expanded(
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Text("Total Amount: "),
                //           Text(
                //               "${CurrencyConfig.convertTo(price: orderModel.total!) .toString() }")
                //         ],
                //       ),
                //     )
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     //show detail of orders
                //     ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             elevation: 0.5,
                //             backgroundColor: Colors.white,
                //             side: BorderSide(color: Colors.black, width: 2)),
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetail(order: orderModel),));
                //         },
                //         child: Text(
                //           "Details",
                //           style: Theme.of(context)
                //               .textTheme
                //               .bodyMedium
                //               ?.copyWith(fontWeight: FontWeight.bold),
                //         )),
                //     //state of order
                //     Text(orderModel.stateOrder!)
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
