import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/shop/models/voucher_model.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServiceVoucher extends StatefulWidget {
  ServiceVoucher({Key? key, required this.chosenVoucher, required this.service})
      : super(key: key);
  VoucherModel chosenVoucher;
  ServiceModel service;

  @override
  State<ServiceVoucher> createState() => _ServiceVoucherState();
}

class _ServiceVoucherState extends State<ServiceVoucher> {
  List<Map<String, dynamic>>? vouchers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.chosenVoucher.id != null
          ? Container(
              height: 56,
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('done')!,
                    style: Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
                  )),
            )
          : null,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('voucher')!, style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                ShowVoucher(
                  service: widget.service,
                  chosenVoucher: widget.chosenVoucher,
                  callback: () {
                    setState(() {});
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShowVoucher extends StatefulWidget {
  ShowVoucher(
      {super.key,
      required this.chosenVoucher,
      required this.callback,
      required this.service});

  ServiceModel service;
  VoucherModel chosenVoucher;
  void Function() callback;

  @override
  State<ShowVoucher> createState() => _ShowVoucherState();
}

class _ShowVoucherState extends State<ShowVoucher> {
  List<VoucherModel>? vouchers;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: vouchers == null
          ? context.read<BookingProvider>().getAllVoucher(
              serviceId: widget.service.id,
              token: context.read<AuthenticateProvider>().token!)
          : null,
      builder: (context, snapshot) {
        final rs = snapshot.data?.result;
        if (rs != null) {
          final rawVouchers = List<Map<String, dynamic>>.from(rs['vouchers']);
          vouchers = rawVouchers.map((e) => VoucherModel.fromJson(e)).toList();
        }
        return rs == null
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 5,
                  (context, index) {
                    final voucher = VoucherModel(
                      voucherCode: "",
                      maxDiscount: 30,
                      minAppValue: 30,
                    );
                    bool isChoose = false;
                    return Skeletonizer(
                        enabled: true, child: VoucherItem(voucher, isChoose));
                  },
                ),
              )
            : vouchers?.length == 0
                ? SliverFillRemaining(
                  child: Container(

                    alignment: Alignment.center,
                    decoration: BoxDecoration(

                    ),
                    child: Center(
                      child: Text("Service has no vouchers", style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                          ),
                )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: vouchers?.length, (context, index) {
                    final voucher = vouchers?[index];
                    bool isChoose = false;
                    if (widget.chosenVoucher.id != null) {
                      isChoose = voucher?.id == widget.chosenVoucher.id;
                    }

                    // final expiredTime = DateFormat('dd-MM-yyyy').format(
                    //     DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z")
                    //         .parse(voucher.expireAt!)
                    //         .toLocal());
                    return VoucherItem(voucher!, isChoose);
                  }));
      },
    );
  }

  Widget VoucherItem(VoucherModel voucher, bool isChoose) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: 100,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child:
                        Image(image: AssetImage('assets/images/voucher.png')),
                  )),
              Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        voucher.voucherCode!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Text("Max discount: "),
                          Text(CurrencyConfig.convertTo(
                                  price: voucher.maxDiscount!)
                              .toString())
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Text("Min order: "),
                          Text(CurrencyConfig.convertTo(
                                  price: voucher.minAppValue!)
                              .toString())
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [Text("Expired: "), Text("")],
                      )),
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isChoose ? Colors.grey.shade200 : null),
                      onPressed: () {
                        setState(() {
                          widget.chosenVoucher.update(voucher);
                        });
                        widget.callback();
                      },
                      child: Text(
                        isChoose ? AppLocalizations.of(context)!.translate('applied')! :AppLocalizations.of(context)!.translate('apply')!,
                        style: isChoose ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({}),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
