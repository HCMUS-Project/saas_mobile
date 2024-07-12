import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/home/views/detail_service.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("dsadsadasdsd");
  }

  @override
  Widget build(BuildContext context) {
    print("home build");
    return FutureBuilder(
        future: Future.wait([
          context.read<BookingProvider>().getAllService(
              domain: context.read<AuthenticateProvider>().domain!),
          context.read<ShopProvider>().getAllProduct(
              domain: context.read<AuthenticateProvider>().domain!),
          context
              .read<HomeProvider>()
              .getBanner(domain: context.read<AuthenticateProvider>().domain!)
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
            body: RefreshIndicator(
              color: Theme.of(context).colorScheme.secondary,
              onRefresh: () async {
                setState(() {});
              },
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: CarosselWidget()),
                  result_1 == null
                      ? SliverGrid(
                          gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            repeatPattern: QuiltedGridRepeatPattern.inverted,
                            pattern: [
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
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
                            serviceName: AppLocalizations.of(context)!
                                .translate('topService')!,
                            image_path: "assets/images/image_214.png",
                          ),
                        ),
                  SliverMainAxisGroup(
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.all(8),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate('topSeller')!,
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
                                repeatPattern:
                                    QuiltedGridRepeatPattern.inverted,
                                pattern: [
                                  const QuiltedGridTile(2, 2),
                                  const QuiltedGridTile(1, 1),
                                  const QuiltedGridTile(1, 1),
                                ],
                              ),
                              delegate: SliverChildBuilderDelegate(
                                childCount: 3,
                                (context, index) => buildSkeleton(context),
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              sliver: SliverGrid(
                                gridDelegate: SliverQuiltedGridDelegate(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  repeatPattern:
                                      QuiltedGridRepeatPattern.inverted,
                                  pattern: [
                                    const QuiltedGridTile(2, 2),
                                    const QuiltedGridTile(1, 1),
                                    const QuiltedGridTile(1, 1),
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image(
                                            image:
                                                NetworkImage(product.image![0]),
                                            fit: BoxFit.fill),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
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
  late HomeProvider homeProvider;
  List<Map<String, dynamic>> banners = [];
  Timer? carasouelTmer;
  int pageNo = 0;
  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == homeProvider.banners.length) {
        pageNo = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(pageNo,
            duration: const Duration(seconds: 1), curve: Curves.easeInOutCirc);
        pageNo++;
      }
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    homeProvider = context.read<HomeProvider>();
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
    print("build carrosel");
    final banners =
        context.select((HomeProvider homeProvider) => homeProvider.banners);

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
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];

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
                    margin: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(banner['image']),
                            fit: BoxFit.fill),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              banners.length,
              (index) => Container(
                    margin: const EdgeInsets.all(2.0),
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
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.serviceName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              // decoration: BoxDecoration(color: Colors.amber),
              alignment: Alignment.topCenter,
              height: (constraints.maxWidth * 3) /
                  8 *
                  (widget.services.length / 2).ceil(),
              width: double.infinity,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 4 / 3,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5),
                physics: const NeverScrollableScrollPhysics(),
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
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Material(
                                borderRadius: BorderRadius.circular(15),
                                elevation: 1,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(service.images![0])),
                                  ),
                                )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  service.name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
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
  const AppBarHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final username = context.read<AuthenticateProvider>().username;
    print("TEN CUA TUI LA: ");
    print(username);
    return AppBar(
        centerTitle: false,
        title: username != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "have a nice day",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).appBarTheme.titleTextStyle?.color
                    ),
                  ),
                  Text(
                    username,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).appBarTheme.titleTextStyle?.color),
                  ),
                ],
              )
            : null);
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class ProductCategory extends StatelessWidget {
  const ProductCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [],
    );
  }
}
