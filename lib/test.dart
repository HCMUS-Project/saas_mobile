import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
            child: FetchdataWidget() 
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

class FetchdataWidget extends StatefulWidget {
   FetchdataWidget({super.key});

  @override
  State<FetchdataWidget> createState() => _FetchdataWidgetState();
}

class _FetchdataWidgetState extends State<FetchdataWidget> {
  String a = "ae";
  Stream? steam;
  StreamController _streamController = StreamController();
  Future<void> getStream()async{
    try {
      final client = http.Client();
      final request = http.Request(
        "get", Uri.parse("http://192.168.189.216:3000/api/ecommerce/voucher/testStream")
      )..headers['Accept'] = 'application/json';
      print(request);
      final response  = await client.send(request);
      print("Response: $response");
      response.stream.listen((value) { 
        print(String.fromCharCodes(value));
        setState(() {
          a = String.fromCharCodes(value);
        });
      });
    } on FlutterException catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: getStream(),
      builder: (context, snapshot) {
        // final result = snapshot.data?.result;
      
        // List<Map<String, dynamic>> products = [];

        // if (result != null) {
        //   products = List<Map<String, dynamic>>.from(result['products']);
        // }
        if (snapshot.connectionState == ConnectionState.waiting){
          return Container();
        }
        return StreamBuilder(
          stream:_streamController.stream ,
          builder:(context, snapshot) {
            print(snapshot.data);
            return Container(
            child: Text(a)
          );
      });
      },
    );
  }
}
