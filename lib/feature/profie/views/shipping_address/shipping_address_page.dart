import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';

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
                minimumSize: const Size(56, 56),
                shape: const BeveledRectangleBorder()),
            onPressed: () async {
              final renderBox = context.findRenderObject() as RenderBox;
              final size = renderBox.size;
              print(size.height);
              print(size.width);
              final controller = showOverlay(
                  context: context,
                  child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 1,
                      color: Colors.black.withAlpha(150),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: size.height *0.2,
                          width: size.width*0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add success",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )));
              controller["show"]();
              await Future.delayed(Duration(seconds: 1));
              controller['hide']();
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
