import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/components/custom_search_delegate.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/products_detail_2.dart';
import 'package:mobilefinalhcmus/feature/shop/views/show_all_product/widget/product.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.result, super.key, this.query});
  String? query;
  List<ProductModel>? result;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? queryController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    widget.query = arguments['query'];
    widget.result = List<ProductModel>.from(arguments['searchResults']);
    return Scaffold(
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
                    route: ModalRoute.of(context)!.settings.name,
                    callback: (data) {
                      return FutureBuilder(
                          future: context.read<ShopProvider>().searchProduct(
                              domain:
                                  context.read<AuthenticateProvider>().domain!,
                              name: data),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                decoration:
                                    const BoxDecoration(color: Colors.transparent),
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
              setState(() {
                widget.result = result;
              });
            },
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            
            ),
            decoration: InputDecoration(
              hintText: widget.query,
            
              focusedBorder: const OutlineInputBorder(
                  // borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black)),
              border: const OutlineInputBorder(
                  // borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: widget.result?.length,
            itemBuilder: (context, index) {
              final product = widget.result?[index];
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
          )),
    );
  }
}
