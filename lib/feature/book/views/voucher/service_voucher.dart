import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/voucher_model.dart';
import 'package:provider/provider.dart';

class ServiceVoucher extends StatefulWidget {
  ServiceVoucher({Key? key, required this.chosenVoucher}) : super(key: key);
  VoucherModel chosenVoucher;

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
                    "Agree",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            )
          : null,
      appBar: AppBar(
        title: Text("Voucher", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: vouchers == null
            ? context.read<BookingProvider>().getAllVoucher(
                token: context.read<AuthenticateProvider>().token!)
            : null,
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
          final rs = snapshot.data?.result;
          if (rs != null){
            vouchers = List<Map<String, dynamic>>.from(rs?['vouchers']);
            print(vouchers);
          }
          
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                ShowVoucher(
                  chosenVoucher: widget.chosenVoucher,
                  callback: () {
                    setState(() {});
                  },
                  vouchers: vouchers!.map((e) => VoucherModel.fromJson(e)).toList() ,
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
      required this.vouchers,
      required this.chosenVoucher,
      required this.callback});
  List<VoucherModel> vouchers;
  VoucherModel chosenVoucher;
  void Function() callback;
  @override
  State<ShowVoucher> createState() => _ShowVoucherState();
}

class _ShowVoucherState extends State<ShowVoucher> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: widget.vouchers.length,
            (context, index) {
      final voucher = widget.vouchers[index];
      bool isChoose = false;
      if (widget.chosenVoucher.id != null) {
        isChoose = voucher.id == widget.chosenVoucher.id;
      }

      // final expiredTime = DateFormat('dd-MM-yyyy').format(
      //     DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z")
      //         .parse(voucher.expireAt!)
      //         .toLocal());
      return VoucherItem(voucher, isChoose);
    }));
  }

  Widget VoucherItem(VoucherModel voucher, bool isChoose){
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
                          isChoose ? "Applied" : "Apply",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ))),
              ],
            ),
          ),
        ),
      );
  }
}
