import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/components/custom_search_delegate.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/views/cart_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/products_detail_2.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/filter_widget.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/product.dart';
import 'package:provider/provider.dart';

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
    // TODO: implement build

    List<String?> categoryList = [];
    categoryList.add("All");
    categoryList.addAll(context.read<ShopProvider>().categoryList);

    print(categoryList);
    return Scaffold(
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
                              domain: context.read<AuthenticateProvider>().domain!,
                              name: data
                            ),
                            builder:(context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting){
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent
                                  ),
                                );
                              }
                              final result = snapshot.data?.result;
                              final products = List<Map<String,dynamic>>.from(result?['products']);
                              return ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product =ProductModel.fromJson(products[index]);
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
                            } 
                          );
                        },
                        ));
                
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const CartPage();
                  },
                ));
              },
              icon: Icon(Icons.shopping_cart_outlined,
                  color: Theme.of(context).iconTheme.color))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: [
            //filter component
            Container(
              child: FilterWidget(categoryList: categoryList),
            ),
            //all products
            Expanded(
                flex: 20,
                child: Consumer<ShopProvider>(
                  builder: (context, value, child) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: value.filterProductList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = value.filterProductList?[index];
                        if (product == null) {
                          return  Container(
                            child: const Center(
                              child: Text("There is no product"),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ProductDetail2(product: product);
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
      ),
    );
  }
}
