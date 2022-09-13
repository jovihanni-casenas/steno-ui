import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  final child, padding;

  const Button({Key? key, required this.child, required this.padding}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Container(
      child: child,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
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
          ),
        ]
      ),
    );
  }
}