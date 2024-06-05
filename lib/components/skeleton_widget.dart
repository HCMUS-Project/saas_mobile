import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const SkeletonContainer._({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
  }) : super(key: key);

  const SkeletonContainer.square({
    double? width,
    double? height,
  }) : this._(width: width, height: height);

  const SkeletonContainer.rounded({
    double? width,
    double? height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  const SkeletonContainer.circular({
    double? width,
    double? height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(80)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
        //gradientColor: Colors.orange,
        //shimmerColor: Colors.red,
        //curve: Curves.easeInQuad,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: borderRadius,
          ),
        ),
      );
}

Widget buildSkeleton(BuildContext context) => Container(
  height: 120,
  child: Column(
        children: <Widget>[
          Expanded(
            child: SkeletonContainer.rounded(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SkeletonContainer.rounded(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 25,
                ),
                const SizedBox(height: 8),
                SkeletonContainer.rounded(
                  width: 60,
                  height: 13,
                ),
              ],
            ),
          ),
        ],
      ),
);
