import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobilefinalhcmus/components/skeleton_widget.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SockerConfig{
  IO.Socket? socket;
  SockerConfig._internal(){
    socket = IO.io("", IO.OptionBuilder().setTransports(['websocket']).build());

  }
  static SockerConfig? _sockerConfig  = SockerConfig._internal();

  static SockerConfig getInstance(){
    return _sockerConfig ?? SockerConfig._internal();
  }

  void init(){
    socket?.on('connect', (_) {
      print('Connected to server');
    });

    socket?.on('events', (data) {
      print(data);
    });
  }
}

class TestPage extends StatefulWidget {
  TestPage({
    super.key,
    this.product
  });
  ProductModel? product;
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
    // final socket = SockerConfig.getInstance();
    // socket.init();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuil;d");
    final product = widget.product;
    print(isToggle);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isToggle) {
            slidableController?.openEndActionPane(
                curve: Curves.linear, duration: Durations.medium1);
          } else 
          {
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
            title: Container(
              height: 56,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
              ),
              child: Text(
                "Let's find your booking!",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80), 
              child: Container(
                decoration: BoxDecoration(
              
                ),
                padding: EdgeInsets.all(20),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18
                  ),
                  decoration: InputDecoration(
                    prefixIconConstraints:BoxConstraints(
                      minWidth: 32,
                      minHeight: 32
                    ) ,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.search,size: 24,),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  ),
                ),
              )
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: bookingList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> bookingList (){
    List<Widget> data =[];
    for(int i =0 ; i < 5; i++){
      data.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
  
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
          ),
          height:300 ,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(image: NetworkImage("https://dpbostudfzvnyulolxqg.supabase.co/storage/v1/object/public/datn.serviceBooking/service/ca956d2f-de3b-48e2-8ce2-e8da3a2dfc46?fbclid=IwZXh0bgNhZW0CMTAAAR3nXis-D-fHoCBcAAYdSQEoWnBAFda_fePlO-iBXxWjnmLELhz7wj5Gn4s_aem_ZmFrZWR1bW15MTZieXRlcw",),fit: BoxFit.fill)
                  ),

                )
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                     borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade200
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Saturday, Oct 10th", style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold
                              ),),
                              Text("8:15 AM")
                            ],
                          ),
                        ) 
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.article_outlined),
                                    Row(
                                      children: [
                                        Text("id: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),),
                                        Text("db951a1f6430"),
                                      ],
                                    )
                                  ],
                                )),
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline),
                                    Row(
                                      children: [
                                        Text("service: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),),
                                        Text("Cat toc 123"),
                                      ],
                                    )
                                  ],
                                )),
                                 Expanded(
                                child: Row(
                                  children: [
                                    Image(image: AssetImage("assets/images/social-media.png"),height: 24,width: 24,),
                                    Row(
                                      children: [
                                        Text("status: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),),
                                        Text("paid"),
                                      ],
                                    )
                                  ],
                                )),
                                
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.people_outline),
                                    Row(
                                      children: [
                                        Text("employee: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),),
                                        Text("Nguyen Vu Khoi"),
                                      ],
                                    )
                                  ],
                              )),
                                
                            ], 
                          ),
                        ))
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      );
    }
    return data;
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
