
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categoryList.length,
              itemBuilder: (context, index) {
                String? category = widget.categoryList[index];
                return Container(
                  
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: (){
                      context.read<ShopProvider>().filterByCategory(categoryId: index);
                      setState(() {
                        widget.selectedCategory = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
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
        
        
      ],
    );
  }
}
