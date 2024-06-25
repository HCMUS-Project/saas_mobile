import 'package:flutter/material.dart';

class ChoosingLocationPage extends StatelessWidget{
  const ChoosingLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        
        actions: [
          IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            
          },
        ),
        ],
      ),
      body: Container(),
    );
  }

}