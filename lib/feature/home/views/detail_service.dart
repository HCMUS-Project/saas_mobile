import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/home/views/main_page.dart';
import 'package:provider/provider.dart';

class DetailService extends StatefulWidget {
  DetailService({super.key, required this.service});
  ServiceModel service;
  @override
  State<DetailService> createState() => _DetailServiceState();
}

class _DetailServiceState extends State<DetailService> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name!, style: Theme.of(context).textTheme.titleLarge,),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverMainAxisGroup(
                        
                      slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                height: 150,
                                width: 300,
                                fit: BoxFit.fill,
                                image:
                                    NetworkImage(widget.service.images![selectedImage]),
                              )),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(      
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.service.images?.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = index;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                                             
                                        margin: EdgeInsets.only(right: 5),
                                        child:ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                      image:
                                          NetworkImage(widget.service.images![index]),
                                    )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                child: Text(
                                  CurrencyConfig.convertTo(price: widget.service.price!).toString()
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 10,),
                    ),
                    SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text("Detail", style: Theme.of(context).textTheme.titleMedium,),
                        ),
                        SliverToBoxAdapter(
                          child: Text(widget.service.description!, style: Theme.of(context).textTheme.bodyLarge,),
                        ),

                      ])
                  ],
                ),
              ),
              Container(
                height: 56,
                child: ElevatedButton(onPressed: ()async{
                  
                  context.read<HomeProvider>().setIndex = 2;
                 
                  await Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false,);
                }, child: Text("BOOKING", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary
                ),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
