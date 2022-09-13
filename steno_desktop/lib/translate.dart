import 'package:flutter/material.dart';
import 'button.dart';
import 'main.dart';

class Translate extends StatefulWidget{
  final file;
  const Translate({Key? key, required this.file}) : super(key: key);

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  child: const Icon(Icons.arrow_back),
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  hoverColor: Colors.blue[800],
                ),
              ),
              Button(
                padding: 5.0,
                child: SizedBox(
                  width: 250.0,
                  height: 250.0,
                  child: FittedBox(
                    child: 
                      widget.file != null
                      ? Image.file(widget.file)
                      : const Icon(Icons.image),
                  ),
                ),
              ),
              // const SizedBox(height: 20.0,),
              const Button(
                padding: 5.0,
                child: SizedBox(
                  width: 250,
                  child: Center(
                    child: Text(
                      'TRANSLATION',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}