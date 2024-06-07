import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/components/success_page.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isToggle = true;
  List<Widget> listSkeletonWidget(BuildContext context) {
    List<Widget> data = [];
    for (int i = 0; i < 100; i++) {
      data.add(buildSkeleton(context));
    }
    return data;
  }

  final Uri _url = Uri.parse(
    'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=10000000&vnp_Command=pay&vnp_CreateDate=20240607122138&vnp_CurrCode=VND&vnp_IpAddr=1.1.1.1&vnp_Locale=vn&vnp_OrderInfo=ipsum+et&vnp_OrderType=210000&vnp_ReturnUrl=https%3A%2F%2Fnvukhoi.id.vn&vnp_TmnCode=H0OFYK66&vnp_TxnRef=905720-1717762898394&vnp_Version=2.1.0&vnp_SecureHash=92f20e2fa59c8888e6e2f847c3521e469f6ed04afd00bb961cac26e284e5e27f01d35a17613d2c4051f23306c23a924c49addf813cd441c0925b3d9cc1873d38');
  SlidableController? slidableController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slidableController = SlidableController(this);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuil;d");
  
    print(isToggle);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isToggle) {
            slidableController?.openEndActionPane(
                curve: Curves.linear, duration: Durations.medium1);
          } else {
            slidableController?.close(duration: Durations.medium1);
          }

          if (await canLaunchUrl(_url)) {
            await launchUrl(_url);
          } else {
            throw Exception('Could not launch $_url');
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text("Hello"),
          ),
          // SliverToBoxAdapter(
          //   child: FetchdataWidget()
          // ),
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
              (context, index) => Slidable(
                  enabled: true,
                  controller: slidableController,
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      icon: Icons.delete,
                      onPressed: (context) {},
                    ),
                  ]),
                  child: Container(
                    child: Center(
                      child: Text(("hello em")),
                    ),
                  )),
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
  Future<void> getStream() async {
    try {
      final client = http.Client();
      final request = http.Request(
          "get",
          Uri.parse(
              "http://192.168.189.216:3000/api/ecommerce/voucher/testStream"))
        ..headers['Accept'] = 'application/json';
      print(request);
      final response = await client.send(request);
      print("Response: $response");
      response.stream.listen((value) {
        print(String.fromCharCodes(value));
        setState(() {
          a = String.fromCharCodes(value);
        });
      });
    } on FlutterException catch (e) {}
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              print(snapshot.data);
              return Container(child: Text(a));
            });
      },
    );
  }
}
