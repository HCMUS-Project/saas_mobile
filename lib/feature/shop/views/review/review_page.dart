import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/model/review_model.dart';
import 'package:mobilefinalhcmus/feature/shop/views/widgets/review_widget.dart';
import 'package:mobilefinalhcmus/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage(
      {super.key,
      this.productId,
      this.numberOfRating,
      this.rating,
      this.serviceId});
  String? productId;
  String? serviceId;
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
    print("productId: ${widget.productId}");
    print("serviceId: ${widget.serviceId}");
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
                reviewId: widget.serviceId,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListReview extends StatefulWidget {
  ListReview({super.key, this.productId, this.reviewId});
  String? reviewId;
  String? productId;
  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  final controller = ScrollController();
  TextEditingController textController = TextEditingController();
  int page = 1;
  int _pageSize = 5;
  late ShopProvider shopProvider;
  PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopProvider = context.read<ShopProvider>();
    context.read<ShopProvider>().reviews = [];
    pagingController.addPageRequestListener(_fetchData);
  }

  Future<void> _fetchData(int pageKey) async {
    try {
      widget.productId != null
          ? await context.read<ShopProvider>().reviewOfProduct(
              domain: context.read<AuthenticateProvider>().domain,
              page: page,
              pageSize: _pageSize,
              productId: widget.productId)
          : await context.read<BookingProvider>().reviewOfService(
              domain: context.read<AuthenticateProvider>().domain!,
              serviceId: widget.reviewId!,
              page: page,
              pageSize: _pageSize);

      List<Map<String, dynamic>> reviews = [];
      if (widget.productId != null) {
        reviews = shopProvider.reviews;
      }

      final isLastPage = reviews.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(reviews);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(reviews, nextPageKey);
      }
    } catch (e) {
      if (mounted) {
        pagingController.error = e;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("PAGE: $page");
    return Expanded(
      flex: 8,
      child: PagedListView(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          noItemsFoundIndicatorBuilder: (context) {
            return Container(
              child: Center(
                child: Text(
                  "No items",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return const Center(
              child: Text("Somethings went wrong!"),
            );
          },
          newPageErrorIndicatorBuilder: (context) {
            return const Center(
              child: Text("Somethings went wrong!"),
            );
          },
          newPageProgressIndicatorBuilder: (context) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            );
          },
          animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 250),
          itemBuilder: (context, item, index) {
            final review = ReviewModel.fromJson(item as Map<String, dynamic>);
            String? email;
            
            if (context.read<AuthenticateProvider>().token != null) {
              print("Email: $email");
              email = context
                  .read<AuthenticateProvider>()
                  .profile?['email']
                  .toString()
                  .toLowerCase();
            }
            
            return LayoutBuilder(
              builder: (context, constraints) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  Expanded(child: ReviewWidget(context, review)),
                  if (review.user?.toLowerCase() == email)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () async {
                                                textController.text =
                                                    review.review!;
                                                final check = await PostReview(
                                                    context: context,
                                                    textController:
                                                        textController,
                                                    serviceId: widget.reviewId,
                                                    productId: widget.productId,
                                                    reviewRating:
                                                        review.rating!);
                                                if (check) {
                                                  pagingController.refresh();
                                                }
                                              },
                                              child: Text(
                                                "Edit",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ))),
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () async{
                                                final rs = await context.read<ShopProvider>().removeReviewProduct(
                                                  token: context.read<AuthenticateProvider>().token!, id: review.id!);
                                                if (rs.errorMessage == null){
                                                  pagingController.refresh();
                                                }
                                              },
                                              child: Text("Remove",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.more_horiz)),
                    )
                ]),
              ),
            );
          },
        ),
      ),
      // child: FutureBuilder(
      //   future: widget.productId != null
      //       ? context.read<ShopProvider>().reviewOfProduct(
      //           domain: context.read<AuthenticateProvider>().domain,
      //           page: page,
      //           pageSize: 5,
      //           productId: widget.productId)
      //       : context.read<BookingProvider>().reviewOfService(
      //           domain: context.read<AuthenticateProvider>().domain!,
      //           serviceId: widget.reviewId!,
      //           page: page,
      //           pageSize: 5),
      //   builder: (context, snapshot) {

      //     final reviews = context.read<ShopProvider>().reviews;

      //     return reviews.isEmpty && snapshot.data?.result != null
      //         ? Center(
      //           child: Text(
      //             "No comments yet",
      //             style: Theme.of(context)
      //                 .textTheme
      //                 .bodyMedium
      //                 ?.copyWith(fontWeight: FontWeight.bold),
      //           ),
      //         )
      //         : ListView.builder(

      //           controller: controller,
      //           itemCount: reviews.length + 1,
      //           itemBuilder: (context, index) {
      //             if (index >= reviews.length) {
      //               print(index);
      //               return  Padding(
      //                 padding: EdgeInsets.zero,
      //                 child: Center(child: CircularProgressIndicator(
      //                   color: Theme.of(context).textTheme.bodyMedium?.color,
      //                 )),
      //               );
      //             } else if (reviews.isNotEmpty) {
      //               final review = ReviewModel.fromJson(reviews[index]);
      //               return LayoutBuilder(
      //                 builder: (context, constraints) => Container(
      //                   margin: const EdgeInsets.symmetric(vertical: 5),
      //                   child: Row(children: [
      //                     Expanded(child: ReviewWidget(context, review)),
      //                     if (review.user?.toLowerCase() ==
      //                         context
      //                             .read<AuthenticateProvider>()
      //                             .profile?['email']
      //                             .toString()
      //                             .toLowerCase())
      //                       Align(
      //                         alignment: Alignment.centerRight,
      //                         child: IconButton(
      //                             onPressed: () {
      //                               showModalBottomSheet(
      //                                 context: context,
      //                                 builder: (context) {
      //                                   return Container(
      //                                     width: double.infinity,
      //                                     height: 100,
      //                                     child: Column(
      //                                       children: [
      //                                         Expanded(
      //                                             child: TextButton(
      //                                                 onPressed: () async {
      //                                                   textController
      //                                                           .text =
      //                                                       review.review!;
      //                                                   final check = await PostReview(
      //                                                       context:
      //                                                           context,
      //                                                       textController:
      //                                                           textController,
      //                                                       serviceId: widget
      //                                                           .reviewId,
      //                                                       productId: widget
      //                                                           .productId,
      //                                                       reviewRating:
      //                                                           review
      //                                                               .rating!);
      //                                                   if (check) {
      //                                                     setState(() {});
      //                                                   }
      //                                                 },
      //                                                 child: Text(
      //                                                   "Edit",
      //                                                   style: Theme.of(
      //                                                           context)
      //                                                       .textTheme
      //                                                       .bodyMedium
      //                                                       ?.copyWith(
      //                                                           fontWeight:
      //                                                               FontWeight
      //                                                                   .bold),
      //                                                 ))),
      //                                         Expanded(
      //                                             child: TextButton(
      //                                                 onPressed: () {},
      //                                                 child: Text("Remove",
      //                                                     style: Theme.of(
      //                                                             context)
      //                                                         .textTheme
      //                                                         .bodyMedium
      //                                                         ?.copyWith(
      //                                                             fontWeight:
      //                                                                 FontWeight
      //                                                                     .bold)))),
      //                                       ],
      //                                     ),
      //                                   );
      //                                 },
      //                               );
      //                             },
      //                             icon: Icon(Icons.more_horiz)),
      //                       )
      //                   ]),
      //                 ),
      //               );
      //             }
      //             return null;
      //           },
      //         );
      //   },
      // ),
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
                  empty: Image.asset('assets/images/star_border.png'),
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
