import 'package:flutter/material.dart';

Map<String, dynamic> showOverlay(
    {required BuildContext context, Widget? child}) {
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return child!;
    },
  );

  return {
    "show": () {
      overlayState.insert(overlayEntry);
    },
    "hide": () {
      
      if (overlayEntry.mounted){
        overlayEntry.remove();
      }
    }
  };
}
