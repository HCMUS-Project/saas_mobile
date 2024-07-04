import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/review_page.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class DetailService extends StatefulWidget {
  DetailService({super.key, required this.service});
  ServiceModel service;
  @override
  State<DetailService> createState() => _DetailServiceState();
}

class _DetailServiceState extends State<DetailService> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service.name!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverMainAxisGroup(slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                height: 150,
                                width: 300,
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    widget.service.images![selectedImage]),
                              )),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.service.images?.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = index;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: 5),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.fill,
                                              image: NetworkImage(widget
                                                  .service.images![index]),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        child: Text(
                          CurrencyConfig.convertTo(price: widget.service.price!)
                              .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverMainAxisGroup(slivers: [
                      SliverToBoxAdapter(
                        child: Text(
                          "Detail",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ReadMoreText(
                          delimiterStyle:
                              const TextStyle(overflow: TextOverflow.fade),
                          widget.service.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          trimMode: TrimMode.Line,
                          trimLines: 2,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reviews",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return ReviewPage(
                                              numberOfRating:
                                                  widget.service.numberRating,
                                              rating: widget.service.rating,
                                              serviceId: widget.service.id!,
                                            );
                                          },
                                        ));
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios,
                                          size: 12)))
                            ],
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                    onPressed: () async {
                      context.read<HomeProvider>().setIndex = 2;

                      await Navigator.of(context).pushNamedAndRemoveUntil(
                        "/home",
                        (route) => false,
                      );
                    },
                    child: Text(
                      "BOOKING",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
