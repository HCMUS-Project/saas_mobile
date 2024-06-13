import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      
      ),
      body: Column(
        children: [
          Text(
            "My orders",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Container(height: 50, child: StateOfOrders()),
          Expanded(
              child: Container(
            child: ShowOrders(),
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
      stateList.add(ElevatedButton(
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
          )));
    }
    return Container(
        padding: EdgeInsets.all(8),
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
        
        return Container(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                OrderModel order = OrderModel.toJson(orderList[index]);
                print(order.products);
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
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      child: Text("Order Id: ${orderModel.trackingNumber}"),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          "${orderModel.date?.day}/${orderModel.date?.month}/${orderModel.date?.year}"),
                    ),
                  )
                ],
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   child: Text("Tracking number: ${orderModel.trackingNumber}"),
              // ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("Quantity: "),
                      Text("${orderModel.quantity}")
                    ],
                  )),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Total Amount: "),
                        Text(
                            "${CurrencyConfig.convertTo(price: orderModel.total!) .toString() }")
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //show detail of orders
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.5,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.black, width: 2)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetail(order: orderModel),));
                      },
                      child: Text(
                        "Details",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )),
                  //state of order
                  Text(orderModel.stateOrder!)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
