import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';

class CustomSearchDeligate<T> extends SearchDelegate<T> {
  final Widget Function(String query) callback;
  String? route;
  TextStyle? textStyle;

  CustomSearchDeligate(
      {this.route,
      required this.callback,
      this.textStyle,
      InputDecorationTheme? inputDecorationTheme});

  @override
  String? get searchFieldLabel => "Search";

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        toolbarHeight: 56.0, // Minimize the AppBar height
        color: theme.colorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(maxHeight: 36),
        contentPadding:
            EdgeInsets.all(8.0), // Minimize padding within the search field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.black),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.black),
        ),
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }

  @override
  TextStyle get searchFieldStyle {
    return TextStyle(
      color: Colors.black,
      fontSize: 14.0, // Minimize the font size
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
      // Exit from the search screen.
    );
  }

  @override
  void showResults(BuildContext context) async {
    // TODO: implement showResults
    super.showResults(context);

    final result = await context.read<ShopProvider>().searchProduct(
        domain: context.read<AuthenticateProvider>().domain!, name: query);

    final products =
        List<Map<String, dynamic>>.from(result.result?['products']);
    final convertToProductModel =
        products.map((e) => ProductModel.fromJson(e)).toList();
    final searchResults = convertToProductModel
        .where((element) => element.name!.toLowerCase().trim().contains(query.toLowerCase().trim()))
        .toList();

    if (route != null) {
      Navigator.of(context).popUntil(ModalRoute.withName(route!));
      Navigator.of(context).pop();
    }

    Navigator.pushNamed(context, "/shop/search_page",
        arguments: {"searchResults": searchResults, "query": query});
  }

  @override
  Widget buildResults(BuildContext context) {
    return callback(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return callback(query);
  }
}
