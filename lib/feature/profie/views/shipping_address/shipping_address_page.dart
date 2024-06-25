import 'package:flutter/material.dart';

class ShippingAdderssPage extends StatelessWidget {
  const ShippingAdderssPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              child: Material(
                elevation: 1,
                color: Colors.grey.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "My home",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "Nguyen Trai",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "0918234567",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(56, 56), shape: const BeveledRectangleBorder()),
            onPressed: () async {
              // final renderBox = context.findRenderObject() as RenderBox;
              // final size = renderBox.size;
              // print(size.height);
              // print(size.width);
              // final controller = showOverlay(context: context,child: Container(
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: Colors.transparent
              //   ),
              //   child: Container(
                  
              //     height: size.height * 0.3,
              //     width: size.width *0.5,
              //     child: Material(

              //       borderRadius: BorderRadius.circular(15),
              //       elevation: 1,
              //       color: Theme.of(context).colorScheme.primary.withAlpha(150),
              //       child: Column(
              //         children: [
              //           Container(
              //             child: Image(
              //               image: AssetImage("assets/images/logo_0.png"),
              //             ),
              //           ),
              //           Container(
              //             child: Text("Add success",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //               fontWeight: FontWeight.bold
              //             ),),
              //           )
              //         ],
              //       )),
              //   ),
              // ));
              // controller["show"]();
              // await Future.delayed(Duration(seconds: 1));
              // controller['hide']();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ADD ADDRESS",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.add)
              ],
            )),
      ),
    );
  }
}
