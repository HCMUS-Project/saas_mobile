import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';

Map<String,Color> StatusBooking = {
  "PENDING": Color(0xffca8f04),
  "SUCCESS": Colors.green.shade200,
  "CANCLE": Colors.red
};
class BookingDetailPage extends StatelessWidget {
  BookingDetailPage({super.key, required this.bookingDetail});
  Map<String, dynamic> bookingDetail;
  @override
  Widget build(BuildContext context) {
    print(bookingDetail);
    final date = DateFormat("hh:mm - dd/MM/yyyy")
        .format(DateTime.parse(bookingDetail['createdAt']));
    final employee = bookingDetail['employee']['firstName'] +
        " " +
        bookingDetail['employee']['lastName'];
    return Scaffold(
      bottomNavigationBar: Container(
        height: 56,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                  child:
                      ElevatedButton(onPressed: () {}, child: Text("Cancle",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),)))
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Booking detail",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Column(
                children: [
                  //price
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image:
                                    AssetImage('assets/images/price-tag.png'),
                                height: 32,
                                width: 32,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total price",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(CurrencyConfig.convertTo(
                                          price: bookingDetail['totalPrice'])
                                      .toString())
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  //status
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status"),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              shape: BoxShape.rectangle,
                              color: StatusBooking[bookingDetail['status']]),
                          child: Text(
                            bookingDetail['status'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  //time
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Time"),
                        Container(
                          child: Text(date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  const MySeparator(
                    color: Colors.grey,
                  ),
                  //id
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Id"),
                        Container(
                          child: Text(
                              bookingDetail['id'].toString().split("-")[4],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  //employee
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Employee"),
                        Container(
                          child: Text(employee,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            //note
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Note",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            Text(bookingDetail['note'])
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
