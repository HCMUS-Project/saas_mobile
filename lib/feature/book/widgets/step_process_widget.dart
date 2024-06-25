import 'dart:async';

import 'package:flutter/material.dart';

class StepProcessWidget extends StatefulWidget{
  Widget Function(Function? setActive,Function? startTimer ) functionA;
  int index;
  int selectedStep;
  StepProcessWidget({
    required this.selectedStep,
    super.key,
    required this.index, 
    required this.functionA
  });
  @override
  State<StepProcessWidget> createState() => _StepProcessWidgetState();
}

class _StepProcessWidgetState extends State<StepProcessWidget> {
  bool _show = true;
  Timer? timer;
  bool active = false;
  @override
  void initState() {
    startTimer();
    super.initState();
  }
  
  void startTimer(){
    print(widget.index);
    if (widget.index == widget.selectedStep){
      timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _show = !_show;
        });
      });
    }else{
      stopTimer();
    }
  }

  void stopTimer(){
    timer?.cancel();
    timer= null;
    _show = true;
  }
  
  @override
  void didUpdateWidget(covariant StepProcessWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedStep != widget.selectedStep){
      startTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setActive() {
    print(active);
    setState(() {
      timer?.cancel();
      timer= null;
      _show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration:BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle
                      ),
                    ),
                    AnimatedOpacity(
                        curve: Curves.bounceInOut,
                        opacity: _show ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration:_show ? BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle
                          ):const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle
                          ) ,
                        ),
                      ),
                  ],
                ),
                
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: widget.functionA(setActive,startTimer)
          )
        ],
      ),
    );
  }
}