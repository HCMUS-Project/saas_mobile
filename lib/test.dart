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
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/review/review_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class TestPage extends StatefulWidget {
  TestPage({
    super.key,
    required this.product
  });
  ProductModel product;
  @override
  State<TestPage> createState() => _TestPageState();
}



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
    final product = widget.product;
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
          // SliverAppBar(
          //   pinned: true,
          //   title: Text("Hello"),
          // ),
          // SliverToBoxAdapter(
          //   child: FetchdataWidget()
          // ),
          // SliverGrid(
          //   gridDelegate: SliverQuiltedGridDelegate(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 4,
          //     crossAxisSpacing: 4,
          //     repeatPattern: QuiltedGridRepeatPattern.inverted,
          //     pattern: [
          //       QuiltedGridTile(1, 1),
          //       QuiltedGridTile(1, 1),
          //     ],
          //   ),
          //   delegate: SliverChildBuilderDelegate(
          //     childCount: 12,
          //     (context, index) => Slidable(
          //         enabled: true,
          //         controller: slidableController,
          //         endActionPane:
          //             ActionPane(motion: const ScrollMotion(), children: [
          //           SlidableAction(
          //             backgroundColor: Theme.of(context).colorScheme.secondary,
          //             foregroundColor: Theme.of(context).colorScheme.primary,
          //             icon: Icons.delete,
          //             onPressed: (context) {},
          //           ),
          //         ]),
          //         child: Container(
          //           child: Center(
          //             child: Text(("hello em")),
          //           ),
          //         )),
          //   ),
          // )

          SliverToBoxAdapter(
            child: Container(
              height: 400,
              child: ShowListImageOfProduct(product: product),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: Image(image: AssetImage("assets/images/star.png"))),
                      Text("${product.rating} (${product.numberRating})")
                    ],
                  ),
                  Container(
                    child: IconButton(onPressed: (){}, icon: Icon(Icons.share),
                  ))
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(CurrencyConfig.convertTo(price: product.price!).toString(),style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold
              ),),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name!, style: Theme.of(context).textTheme.titleMedium,),
                  Text("In stock: ${product.quantity! > 0 ?  'in stock' : "sold out"}",style: Theme.of(context).textTheme.bodyMedium,)
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold
                  ),),
                  ReadMoreText(
                    delimiterStyle: TextStyle(overflow: TextOverflow.fade),
                    product.description!,
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(
              thickness: 2,
              color: Colors.grey.shade300,

            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Reviews (${product.numberRating})", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    
                    child: IconButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ReviewPage(
                                  numberOfRating: product.numberRating,
                                  rating: product.rating,
                                  productId: product.id!,
                                );
                              },
                            ));
                    }, icon: Icon(Icons.arrow_forward_ios,size: 12)))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowListImageOfProduct extends StatefulWidget {
  const ShowListImageOfProduct({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<ShowListImageOfProduct> createState() => _ShowListImageOfProductState();
}

class _ShowListImageOfProductState extends State<ShowListImageOfProduct> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
        
          ),
          child: Image(image: NetworkImage(widget.product.image![selectedImage])),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
     
          ),
          padding: EdgeInsets.all(8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                  final image = widget.product.image![index];
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedImage = index;
                      });
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedImage == index ? Colors.black : Colors.transparent,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Material(
                        
                        elevation: 1,
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(image: NetworkImage(image),fit: BoxFit.fill,width: 80,)),
                      ),
                    ),
                  );
              }, 
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 10,
                );
              }, 
              itemCount: widget.product.image!.length),
          ),
        )
      ],  
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
