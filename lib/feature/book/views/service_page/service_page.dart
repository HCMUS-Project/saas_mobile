import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/book/views/voucher/service_voucher.dart';
import 'package:mobilefinalhcmus/feature/shop/models/voucher_model.dart';
import 'package:mobilefinalhcmus/helper/cal_discount.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServicePage extends StatefulWidget {
  ServicePage({super.key, required this.voucher});
  VoucherModel voucher;
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with SingleTickerProviderStateMixin {
  ServiceModel? chosenService;
  List<Map<String, dynamic>>? services;
  AnimationController? controller;
  Animation<Offset>? offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller!);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    VoucherModel voucher = widget.voucher;
    int afterDiscountPrice = 0;
    if (chosenService != null && voucher.discountPercent != null) {
      afterDiscountPrice = CalculateDiscount(
          chosenService: chosenService!, voucher: widget.voucher);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose service",
            style: Theme.of(context).textTheme.titleLarge),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (chosenService != null)
            SlideTransition(
              position: offset!,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor)),
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor),
                padding: EdgeInsets.all(8),
                height: 46,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Image(
                                image:
                                    AssetImage('assets/images/coupon.png')))),
                    Expanded(
                        flex: 7,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              voucher.voucherName ?? "Voucher",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ))),
                    Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                alignment: Alignment.topCenter),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ServiceVoucher(
                                    chosenVoucher: widget.voucher,
                                  );
                                },
                              )).then((value) {
                                print("CHOSEN VOUCHER: $voucher");
                                print(voucher?.id);
                                setState(() {});
                              });
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              size: 12,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          Container(
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Chosen service"),
                              Text(chosenService?.name ?? "")
                            ],
                          ))),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Total"),
                          if (voucher?.id == null)
                            Text(CurrencyConfig.convertTo(
                                    price: chosenService?.price ?? 0)
                                .toString())
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/coupon.png'))),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    CurrencyConfig.convertTo(
                                            price: afterDiscountPrice)
                                        .toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            )
                        ],
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(chosenService);
                            },
                            child: Text("Done"),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(1)),
        child: FutureBuilder(
          future: services == null
              ? context.read<BookingProvider>().getAllService(
                  domain: context.read<AuthenticateProvider>().domain!)
              : null,
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Container(
            //     child: Center(
            //       child: CircularProgressIndicator(
            //         color: Theme.of(context).colorScheme.secondary,
            //       ),
            //     ),
            //   );
            // }
            print("troi oi la troi");
            print(snapshot.data?.result);
            if (snapshot.data?.result != null) {
              services = List<Map<String, dynamic>>.from(
                  snapshot.data?.result?['services']);
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(8),
                  sliver: snapshot.data?.result == null
                      ? SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisExtent: 300,
                                  mainAxisSpacing: 5),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> service = Map();
                            service['name'] = "item";
                            service['timeService'] = {
                              'duration':10
                            };
                            service['images'] = ["https://dpbostudfzvnyulolxqg.supabase.co/storage/v1/object/public/datn.serviceBooking/service/ca956d2f-de3b-48e2-8ce2-e8da3a2dfc46"];
                            service['description'] = "";
                            service['price'] = 0;
                            return Skeletonizer(
                                enabled: true, child: ServiceItem(service));
                          })
                      : SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisExtent: 300,
                                  mainAxisSpacing: 5),
                          itemCount: services?.length,
                          itemBuilder: (context, index) {
                            final service = services?[index];

                            return ServiceItem(service!);
                          },
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget ServiceItem(Map<String, dynamic> service) {
    return Container(
        child: Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                    image: NetworkImage(service['images'][0].toString()),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: Text(
                              service['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Icon(Icons.timer_sharp),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                    "${service['timeService']['duration'].toString()}"),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        service['description'],
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Standard Price"),
                          Text(CurrencyConfig.convertTo(price: service['price'])
                              .toString())
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                    fixedSize: MaterialStatePropertyAll(
                                        Size(150, 36))),
                            onPressed: () {
                              switch (controller?.status) {
                                case AnimationStatus.completed:
                                  controller?.forward();
                                  break;
                                case AnimationStatus.dismissed:
                                  controller?.reverse();
                                  break;
                                default:
                              }
                              setState(() {
                                final voucherUnkown = VoucherModel.unknown();
                                widget.voucher.update(voucherUnkown);
                                chosenService = ServiceModel.fromJson(service);
                              });
                            },
                            child: Text("choose"))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
