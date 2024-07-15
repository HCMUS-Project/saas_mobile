import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';

Map<String, dynamic> LoadingWidget(BuildContext context) {
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
              height: size.height * 0.15,
              width: size.width * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Loading ...",
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
  return controller;
}
