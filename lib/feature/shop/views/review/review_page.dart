import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/model/review_model.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage(
      {super.key, required this.productId, this.numberOfRating, this.rating});
  String productId;
  int? numberOfRating;
  double? rating;
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController reviewTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
      
                      child: Text(
                        "Rating&Reviews",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        widget.rating.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                      ),
                                    ),
                                    Text("${widget.numberOfRating} ratings")
                                  ],
                                )),
                            Expanded(
                                flex: 8,
                                child: Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    RatingHeader(
                                      itemCount: 5,
                                    ),
                                    RatingHeader(
                                      itemCount: 4,
                                    ),
                                    RatingHeader(
                                      itemCount: 3,
                                    ),
                                    RatingHeader(
                                      itemCount: 2,
                                    ),
                                    RatingHeader(
                                      itemCount: 1,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListReview(
                productId: widget.productId,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,

          // fixedSize: Size(170, 15)
        ),
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Write a review",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class ListReview extends StatefulWidget {
  ListReview({super.key, required this.productId});

  String productId;
  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    controller.addListener(() async {
      print("scroll ");
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          print('scroll di');
          page++;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ShopProvider>().reviewOfProduct(
          domain: context.read<AuthenticateProvider>().domain,
          page: page,
          pageSize: 5,
          productId: widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Center(),
          );
        }
        final result = context.read<ShopProvider>().httpResponseFlutter.result!;
        final reviews = List<Map<String, dynamic>>.from(result['reviews']);

        return Expanded(
            flex: 8,
            child: ListView.builder(
              itemCount: reviews.length + 1,
              itemBuilder: (context, index) {
                if (index >= reviews.length) {
                  return const Padding(
                    padding: EdgeInsets.zero,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (reviews.isNotEmpty) {
                  final review = ReviewModel.fromJson(reviews[index]);
                  return LayoutBuilder(
                    builder: (context, constraints) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            margin: const EdgeInsets.only(top: 5),
                            width: constraints.maxWidth,
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(review.user!),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Text(review.review!),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 35,
                              child: CircleAvatar(
                                child: Image(
                                    image:
                                        AssetImage("assets/images/avatar.png")),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return null;
              },
            ));
      },
    );
  }
}

class RatingHeader extends StatelessWidget {
  int itemCount;
  RatingHeader({
    required this.itemCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              RatingBar(
                itemPadding: const EdgeInsets.all(2),
                itemSize: 18.0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: itemCount,
                ignoreGestures: true,
                initialRating: 0,
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/images/star_full.png'),
                            half: Image.asset('assets/images/star_half.png'),
                            empty:
                                Image.asset('assets/images/star_border.png'),
                ),
                onRatingUpdate: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
