import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/components/custom_search_delegate.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/products_detail_2.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/filter_widget.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/product.dart';
import 'package:mobilefinalhcmus/feature/shop/views/widgets/filter_page.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key, this.query});
  String? query;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? queryController;
  late ShopProvider shopProvider;
  List<String?> categoryList = ["All"];
  Map<String, dynamic>? filterPrice;
  int? rating;
  @override
  void initState() {
    shopProvider = context.read<ShopProvider>();
    print("INIT SEARCH PAGE");
    shopProvider.productList = [];
    shopProvider.selectedCategory = "";
    super.initState();
  }

  void reset() {
    context.read<ShopProvider>().setProductList = [];
    categoryList.removeWhere((element) => element != "All");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: SizedBox(
            height: 36,
            child: TextFormField(
              initialValue: widget.query,
              readOnly: true,
              textAlignVertical: TextAlignVertical.bottom,
              cursorColor: Theme.of(context).colorScheme.secondary,
              onTap: () async {
                final result = await showSearch(
                    context: context,
                    query: widget.query,
                    delegate: CustomSearchDeligate(
                      route: "/shop/search",
                      callback: (data) {
                        return FutureBuilder(
                            future: context.read<ShopProvider>().searchProduct(
                                domain: context
                                    .read<AuthenticateProvider>()
                                    .domain!,
                                name: data),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent),
                                );
                              }
                              final result = snapshot.data?.result;
                              final products = List<Map<String, dynamic>>.from(
                                  result?['products']);

                              return ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      ProductModel.fromJson(products[index]);
                                  return Container(
                                    child: ListTile(
                                      onTap: () {},
                                      leading: Image(
                                        width: 64,
                                        height: 64,
                                        image: NetworkImage(product.image![0]),
                                      ),
                                      subtitle: Text(CurrencyConfig.convertTo(
                                              price: product.price!)
                                          .toString()),
                                      title: Text(product.name!),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                    ));
              },
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              decoration: InputDecoration(
                hintText: widget.query,
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.black)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return FilterPage();
                    },
                  )).then((value) {
                    if (value != null) {
                      final filterValue = Map<String, dynamic>.from(value);
                      reset();
                      setState(() {
                        filterPrice = filterValue['rangePrice'];
                        rating = filterValue['rating'];
                      });
                    } else {
                      reset();
                      setState(() {
                        filterPrice = null;
                        rating = null;
                      });
                    }
                  });
                },
                icon: Image(
                    width: 24,
                    height: 24,
                    image: AssetImage("assets/images/filter.png")))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Builder(builder: (context) {
                context.select((ShopProvider value) => value.productList);
                print("REBUILD CATEGORY");
                print(
                    "AFTER REBUILD: ${context.read<ShopProvider>().categoryList}");
                categoryList.addAll(context.read<ShopProvider>().categoryList);
                return Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: FilterWidget(categoryList: categoryList));
              }),
              Expanded(
                flex: 15,
                child: SearchProductList(
                  widget: widget,
                  rangePrice: filterPrice,
                  rating: rating,
                ),
              ),
            ],
          ),
        ));
  }
}

class SearchProductList extends StatelessWidget {
  SearchProductList(
      {super.key, required this.widget, this.rangePrice, this.rating});

  Map<String, dynamic>? rangePrice;
  int? rating;
  final SearchPage widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ShopProvider>().searchProduct(
          rating: rating,
          minPrice: rangePrice?['start'],
          maxPrice: rangePrice?['end'],
          category:
              context.select((ShopProvider value) => value.selectedCategory),
          domain: context.read<AuthenticateProvider>().domain!,
          name: widget.query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              // fake data to display skeleton
              final product = ProductModel(
                  category: [
                    {"name": ""}
                  ],
                  description: "",
                  id: "",
                  image: [
                    "https://dpbostudfzvnyulolxqg.supabase.co/storage/v1/object/public/datn.serviceBooking/service/ca956d2f-de3b-48e2-8ce2-e8da3a2dfc46"
                  ],
                  name: "",
                  numberRating: 0,
                  price: 0,
                  quantity: 0,
                  rating: 0);
              return Skeletonizer(
                enabled: true,
                child: ProductWidget(
                  product: product,
                ),
              );
            },
          );
        }

        List<ProductModel>? products = [];
        final rs = context.read<ShopProvider>().httpResponseFlutter.result;

        products = List<Map<String, dynamic>>.from(rs?['products'])
            .map((e) => ProductModel.fromJson(e))
            .toList();
        // print("PRODUCTS: $products");
        print(context.read<ShopProvider>().categoryList.isEmpty);
        if (snapshot.connectionState == ConnectionState.done &&
            context.read<ShopProvider>().categoryList.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.read<ShopProvider>().setProductList = products!;
          });
        }
        return Container(
            child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: products?.length,
          itemBuilder: (context, index) {
            final product = products?[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ProductDetail2(product: product);
                  },
                ));
              },
              child: ProductWidget(
                product: product!,
              ),
            );
          },
        ));
      },
    );
  }
}
