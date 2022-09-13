import 'package:flutter/material.dart';
import 'bevel_box.dart';

void main() {
  runApp(const StenoTranslator());
}

class StenoTranslator extends StatelessWidget{
  const StenoTranslator({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey.shade300,
        scaffoldBackgroundColor: Colors.grey.shade300,
      ),
      home: Scaffold(
        // backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BevelBox(
                    height: 200,
                    width: 200,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Gregg\nShorthand\nTranslator',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}