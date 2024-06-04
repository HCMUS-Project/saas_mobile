
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  List<String?> categoryList;
  int selectedCategory = 0;
  FilterWidget({
    super.key,
    required this.categoryList});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categoryList.length,
                itemBuilder: (context, index) {
                  String? category = widget.categoryList[index];
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: (){
                        context.read<ShopProvider>().filterByCategory(categoryId: index);
                        setState(() {
                          widget.selectedCategory = index;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor:widget.selectedCategory == index ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary
                      ),
                      child: Text(
                        category!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: widget.selectedCategory == index ? Colors.white : Colors.black),
                    )
                    ),
                  );
                },
              ),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/filter.svg"),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Filter")
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/incr_decr.svg"),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Price: lowest to high")
                      ],
                    ),
                  ),
                  
                  Container(
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/grid.svg"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
