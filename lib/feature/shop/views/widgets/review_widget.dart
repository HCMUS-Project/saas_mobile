import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/model/review_model.dart';
import 'package:provider/provider.dart';

Widget ReviewWidget(BuildContext context, ReviewModel review) {
  TextEditingController textController = TextEditingController();
  return Container(
    child: Row(
      children: [
        Flexible(
            fit: FlexFit.loose,
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/man.png"),
              ),
            )),
        Flexible(
            fit: FlexFit.loose,
            flex: 8,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.user!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Image(
                                height: 32,
                                width: 32,
                                image: AssetImage('assets/images/star.png'),
                                color: Color(0xFFFFC107),
                              ),
                              Text(review.rating.toString()),
                              
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 9,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        review.review!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ],
    ),
  );
}
