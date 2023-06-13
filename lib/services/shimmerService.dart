import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerService{


  Widget salaryShimmer(BuildContext context)
  {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height*0.19,
          width: MediaQuery.of(context).size.width*0.9,
          child: Text(""),
        ),
      ),
    );
  }

  Widget listShimmer(BuildContext context)
  {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height*0.6,
          width: MediaQuery.of(context).size.width*0.9,
          child: Text(""),
        ),
      ),
    );
  }
}


/*
*
* SizedBox(
  width: 200.0,
  height: 100.0,
  child: Shimmer.fromColors(
    baseColor: Colors.red,
    highlightColor: Colors.yellow,
    child: Text(
      'Shimmer',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40.0,
        fontWeight:
        FontWeight.bold,
      ),
    ),
  ),
);
*
*
*
* */