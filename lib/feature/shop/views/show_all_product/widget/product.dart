import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';

class ProductWidget extends StatelessWidget {
  ProductWidget(
    {
      super.key,
      required this.product
    });
  
  ProductModel product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizeOfContainer = (size.width * 0.3) * 2.5;

    return Container(
      height: sizeOfContainer,
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Stack(
              children: [
                //must use Position.fill to use Expanded in that Stack
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage((product.image![0])),fit: BoxFit.fill),
                                color: Colors.blue.shade200),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            
                            alignment: Alignment.centerLeft,
                            decoration:
                                BoxDecoration(color: Colors.white),
                            child: RatingBar(
                              glowColor: Theme.of(context).colorScheme.secondary,
                              ignoreGestures: true,
                              itemPadding: EdgeInsets.all(2),
                              itemSize: 18.0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              initialRating:product.rating! ,
                              ratingWidget: RatingWidget(
                               full: Image.asset('assets/images/star_full.png'),
                            half: Image.asset('assets/images/star_half.png'),
                            empty:
                                Image.asset('assets/images/star_border.png'),
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          ))
                    ],
                  ),
                )),
                Positioned(
                    bottom: (sizeOfContainer * 0.7) * 0.15,
                    right: 0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: CircleBorder(),
                            minimumSize: Size(36, 36)),
                        onPressed: () {},
                        child: ImageIcon(AssetImage("assets/images/heart_border.png"), color: Colors.amber,))),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.category![0]['name']),
                    Text(product.name!),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
