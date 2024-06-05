import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

Widget buildSkeleton(BuildContext context) => Column(
      children: <Widget>[
        SkeletonContainer.rounded(
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SkeletonContainer.rounded(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 25,
            ),
            const SizedBox(height: 8),
            SkeletonContainer.rounded(
              width: 60,
              height: 13,
            ),
          ],
        ),
      ],
    );

class _TestPageState extends State<TestPage> {
  List<Widget> listSkeletonWidget(BuildContext context) {
    List<Widget> data = [];
    for (int i = 0; i < 100; i++) {
      data.add(buildSkeleton(context));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    print("rebuil;d");
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text("Hello"),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: listSkeletonWidget(context),
            ),
          ),
          SliverGrid(
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
              childCount: 12,
              (context, index) => buildSkeleton(context),
            ),
          )
        ],
      ),
    );
  }
}

class FetchdataWidget extends StatelessWidget {
  const FetchdataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ShopProvider>().findProductTopSeller(
          domain: context.read<AuthenticateProvider>().domain!),
      builder: (context, snapshot) {
        final result = snapshot.data?.result;

        List<Map<String, dynamic>> products = [];

        if (result != null) {
          products = List<Map<String, dynamic>>.from(result['products']);
        }

        return Container(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: result == null ? 4 : products.length,
            itemBuilder: (context, index) {
              return result == null
                  ? buildSkeleton(context)
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(color: Colors.amber),
                    );
            },
          ),
        );
      },
    );
  }
}
