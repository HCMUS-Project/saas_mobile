import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/components/success_page.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/home/views/detail_service.dart';
import 'package:mobilefinalhcmus/feature/home/views/main_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          context.read<BookingProvider>().getAllService(
              domain: context.read<AuthenticateProvider>().domain!),
          context.read<ShopProvider>().getAllProduct(
              domain: context.read<AuthenticateProvider>().domain!)
        ]),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Container(
          //     child: Center(
          //       child: CircularProgressIndicator(
          //         color: Theme.of(context).colorScheme.secondary,
          //       ),
          //     ),
          //   );
          // }

          final result_1 =
              context.read<BookingProvider>().httpResponseFlutter.result;
          List<Map<String, dynamic>> services = [];
          List<Map<String, dynamic>> products = [];
          if (result_1 != null) {
            services = List<Map<String, dynamic>>.from(result_1['services']);
          }

          final result_2 =
              context.read<ShopProvider>().httpResponseFlutter.result;
          if (result_2 != null) {
            products = List<Map<String, dynamic>>.from(result_2['products']);
          }

          print(products);
          return Scaffold(
            appBar: AppBarHomePage(),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: CarosselWidget()),
                result_1 == null
                    ? SliverGrid(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                          ],
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: 4,
                          (context, index) => buildSkeleton(context),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: ServiceCategory(
                          services: services,
                          serviceName: "Top Service",
                          image_path: "assets/images/image_214.png",
                        ),
                      ),
                SliverMainAxisGroup(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.all(8),
                      sliver: SliverToBoxAdapter(
                        child: Text("Top seller",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    result_2 == null
                        ? SliverGrid(
                            gridDelegate: SliverQuiltedGridDelegate(
                              crossAxisCount: 3,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              repeatPattern: QuiltedGridRepeatPattern.inverted,
                              pattern: [
                                QuiltedGridTile(2, 2),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                              ],
                            ),
                            delegate: SliverChildBuilderDelegate(
                              childCount: 3,
                              (context, index) => buildSkeleton(context),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.all(8.0),
                            sliver: SliverGrid(
                              gridDelegate: SliverQuiltedGridDelegate(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                repeatPattern:
                                    QuiltedGridRepeatPattern.inverted,
                                pattern: [
                                  QuiltedGridTile(2, 2),
                                  QuiltedGridTile(1, 1),
                                  QuiltedGridTile(1, 1),
                                ],
                              ),
                              delegate: SliverChildBuilderDelegate(
                                childCount: products.isNotEmpty ? 3 : 0,
                                (context, index) {
                                  final product =
                                      ProductModel.fromJson(products[index]);
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Image(
                                        image: NetworkImage(product.image![0]),
                                        fit: BoxFit.fill),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class CarosselWidget extends StatefulWidget {
  const CarosselWidget({super.key});

  @override
  State<CarosselWidget> createState() => _CarosselWidgetState();
}

class _CarosselWidgetState extends State<CarosselWidget> {
  late final PageController pageController;
  Timer? carasouelTmer;
  int pageNo = 0;
  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == 4) {
        pageNo = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(pageNo,
            duration: Duration(seconds: 1), curve: Curves.easeInOutCirc);
        pageNo++;
      }
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    carasouelTmer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    pageController.dispose();
    carasouelTmer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            onPageChanged: (value) {
              pageNo = value;
              setState(() {});
            },
            controller: pageController,
            itemCount: 5,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  return child!;
                },
                child: GestureDetector(
                  onPanDown: (d) {
                    print("Hello");
                    carasouelTmer?.cancel();
                    carasouelTmer = null;
                  },
                  onPanCancel: () {
                    print("thoi ma");
                    carasouelTmer = getTimer();
                  },
                  child: Container(
                    margin: EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://skintdad.co.uk/wp-content/uploads/2022/03/ff-clothing-sale.png"),
                            fit: BoxFit.fill),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              5,
              (index) => Container(
                    margin: EdgeInsets.all(2.0),
                    child: SizedBox(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color:
                            pageNo == index ? Colors.indigoAccent : Colors.grey,
                      ),
                    ),
                  )),
        ),
      ],
    );
  }
}

class ShowListService extends StatelessWidget {
  const ShowListService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ServiceCategory extends StatefulWidget {
  ServiceCategory(
      {super.key,
      required this.serviceName,
      required this.image_path,
      required this.services});
  String serviceName;
  String image_path;
  List<Map<String, dynamic>> services;
  @override
  State<ServiceCategory> createState() => _ServiceCategoryState();
}

class _ServiceCategoryState extends State<ServiceCategory> {
  int selectedService = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.serviceName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              // decoration: BoxDecoration(color: Colors.amber),
              alignment: Alignment.topCenter,
              height:
                  (constraints.maxWidth * 3) / 8 * widget.services.length / 2,
              width: double.infinity,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 4 / 3,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5),
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.services.length,
                itemBuilder: (context, index) {
                  final service = ServiceModel.fromJson(widget.services[index]);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return DetailService(service: service);
                        },
                      ));
                    },
                    child: Container(
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image(
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(service.images![0])),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        color: Theme.of(context).colorScheme.secondary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              service.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    )))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppBarHomePage extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final username = context.read<AuthenticateProvider>().username;

    return AppBar(
        centerTitle: true,
        leading: username != null
            ? Container(
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                child: Image.asset("assets/images/avatar.png"))
            : null,
        title: username != null ? Text(username, style: Theme.of(context).textTheme.titleLarge,) : null);
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class ProductCategory extends StatelessWidget {
  const ProductCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
