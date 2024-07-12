import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/components/custom_search_delegate.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/cart/views/cart_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/products_detail_2.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/filter_widget.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/product.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShowAllProduct extends StatefulWidget {
  ShowAllProduct({this.products, super.key});
  List<Map<String, dynamic>>? products;
  @override
  State<ShowAllProduct> createState() => _ShowAllProductState();
}

class _ShowAllProductState extends State<ShowAllProduct> {
  int selectedCategory = 0;
  ModalRoute? modalRoute;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                final searchProduct = await showSearch(
                    context: context,
                    delegate: CustomSearchDeligate( 
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
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              onPressed: () {
                if (context.read<AuthenticateProvider>().token != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const CartPage();
                    },
                  ));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ));
                }
              },
              icon: Icon(Icons.shopping_cart_outlined,
                  color: Theme.of(context).iconTheme.color))
        ],
      ),
      body: FutureBuilder(
        future: context.read<ShopProvider>().getAllProduct(
            domain: context.read<AuthenticateProvider>().domain!),
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
          final result = context.read<ShopProvider>().httpResponseFlutter;
          final products =
              List<Map<String, dynamic>>.from(result.result?['products'])
                  .map((e) => ProductModel.fromJson(e))
                  .toList();
          return products.length == 0
              ? Container(
                  child: const Center(
                    child: Text("There is no product"),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Column(
                    children: [
                      //filter component
                     
                      //all products
                      Expanded(
                          flex: 20,
                          child: Consumer<ShopProvider>(
                            builder: (context, value, child) {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.5,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetail2(
                                              product: product);
                                        },
                                      ));
                                    },
                                    child: ProductWidget(
                                      product: product,
                                    ),
                                  );
                                },
                              );
                            },
                          )),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
