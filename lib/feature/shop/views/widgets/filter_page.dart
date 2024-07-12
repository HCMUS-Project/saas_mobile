import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  FilterPage({super.key});
  int? selectedOption = 1;
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues values = RangeValues(1, 2000000);
  RangeLabels labels = RangeLabels(
      CurrencyConfig.convertTo(price: 1).toString(),
      CurrencyConfig.convertTo(price: 200000).toString());

  
  @override
  Widget build(BuildContext context) {
    print(identityHashCode(widget.selectedOption).toString());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price Range",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RangeSlider(
                    activeColor:
                        context.read<ThemeProvider>().theme?.buttonColor,
                    inactiveColor: Colors.white,
                    min: 1,
                    max: 2000000,
                    divisions: 4,
                    values: values,
                    labels: labels,
                    onChanged: (value) {
                      setState(() {
                        values = value;
                        labels = RangeLabels(
                            CurrencyConfig.convertTo(price: value.start.floor())
                                .toString(),
                            CurrencyConfig.convertTo(price: value.end.floor())
                                .toString());
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sort by",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Column(
                    children: List.generate(
                      5,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar(
                            itemPadding: const EdgeInsets.all(2),
                            itemSize: 18.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: index + 1,
                            ignoreGestures: true,
                            initialRating: double.parse((index + 1).toString()),
                            ratingWidget: RatingWidget(
                              full: Image.asset('assets/images/star_full.png'),
                              half: Image.asset('assets/images/star_half.png'),
                              empty:
                                  Image.asset('assets/images/star_border.png'),
                            ),
                            onRatingUpdate: (value) {},
                          ),
                          Radio(
                            activeColor:
                                Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                            value: index + 1,
                            groupValue: widget.selectedOption,
                            onChanged: (value) {
                              setState(() {
                                widget.selectedOption = value!;
                                print("rating: ${widget.selectedOption}");
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text(
                    "Reset",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
       
                    Navigator.of(context).pop({
                      "isApply":true,
                      "rating": widget.selectedOption,
                      "rangePrice": {
                        "start": values.start.floor(),
                        "end":values.end.floor()
                      }
                    });
                  },
                  child: Text(
                    "Apply",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({})?.color),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class SortByRating extends StatefulWidget {
  SortByRating({
    required this.selectedOption,
    super.key,
  });
  int? selectedOption;
  @override
  State<SortByRating> createState() => _SortByRatingState();
}

class _SortByRatingState extends State<SortByRating> {
  @override
  Widget build(BuildContext context) {
    print(identityHashCode(widget.selectedOption).toString());
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort by",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Column(
            children: List.generate(
              5,
              (index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.selectedOption = 3;
                        });
                      },
                      child: Text("Click")),
                  RatingBar(
                    itemPadding: const EdgeInsets.all(2),
                    itemSize: 18.0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: index + 1,
                    ignoreGestures: true,
                    initialRating: double.parse((index + 1).toString()),
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/images/star_full.png'),
                      half: Image.asset('assets/images/star_half.png'),
                      empty: Image.asset('assets/images/star_border.png'),
                    ),
                    onRatingUpdate: (value) {},
                  ),
                  Radio(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: index + 1,
                    groupValue: widget.selectedOption,
                    onChanged: (value) {
                      setState(() {
                        widget.selectedOption = value!;
                        print("rating: ${widget.selectedOption}");
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
