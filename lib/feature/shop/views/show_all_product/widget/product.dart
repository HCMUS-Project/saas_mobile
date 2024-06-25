
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
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
    double sizeOfContainer = (size.width * 0.3) * 1.5;

    return Container(
      height: sizeOfContainer,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
      
      ),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  //must use Position.fill to use Expanded in that Stack
                  Positioned.fill(
                      child: Container(
                
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
                              
                              child: RatingBar(
                                glowColor: Theme.of(context).colorScheme.secondary,
                                ignoreGestures: true,
                                itemPadding: const EdgeInsets.all(2),
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
                      bottom: (sizeOfContainer * 0.7) * 0.20,
                      right: 0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
        
                              padding: EdgeInsets.zero,
                              shape: const CircleBorder(),
                              minimumSize: const Size(36, 36)),
                          onPressed: () {},
                          child: const ImageIcon(AssetImage("assets/images/heart_border.png"), color: Colors.amber,))),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(product.category![0]['name'])),
                      Expanded(child: Text(product.name!)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(CurrencyConfig.convertTo(price: product.price!).toString(),style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
