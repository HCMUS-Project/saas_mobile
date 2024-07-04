import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/booking_status.dart';
import 'package:mobilefinalhcmus/widgets/review_widget.dart';

class BookingDetailPage extends StatelessWidget {
  BookingDetailPage({super.key, required this.bookingDetail});
  Map<String, dynamic> bookingDetail;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(bookingDetail);
    final date = DateFormat("hh:mm - dd/MM/yyyy")
        .format(DateTime.parse(bookingDetail['createdAt']));
    final employee = bookingDetail['employee']['firstName'] +
        " " +
        bookingDetail['employee']['lastName'];
    final textButton = bookingDetail['status'] == "SUCCESS"
        ? "Review"
        : bookingDetail['status'] == "PENDING"
            ? "Cancle"
            : null;
    final buttonColor = bookingDetail['status'] == "SUCCESS"
        ? Colors.green.shade200
        : bookingDetail['status'] == "PENDING"
            ? Colors.red
            : null;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 56,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (textButton != null)
                Expanded(
                    child: ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStatePropertyAll(buttonColor)
                        ),
                        onPressed: () {
                          if (textButton == "Review" ){
                            PostReview(context: context, textController: textEditingController, serviceId: bookingDetail['service']['id']);
                          }
                        },
                        child: Text(
                          textButton,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )))
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Image(
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status"),
                        Container(
                          padding: const EdgeInsets.all(5),
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Time"),
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Id"),
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Employee"),
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

            const SizedBox(
              height: 10,
            ),
            //note
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
