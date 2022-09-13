import 'package:flutter/material.dart';

class BevelBox extends StatelessWidget{
  double height, width;
  final child;

  BevelBox({Key? key, required this.height, required this.width, required this.child}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Container(
      height: height,
      width: width,
      child: child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
              blurRadius: 15,
              offset: const Offset(5, 5)
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            offset: Offset(-5, -5)
          )
        ]
      ),
    );
  }
}