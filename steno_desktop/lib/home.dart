import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'button.dart';
import 'translate.dart';

class Home extends StatefulWidget{

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var file;

  @override 
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Button(
            padding: 8.0,
            child: Column(
              children: [
                Image.asset('assets/gregg shorthand translator_shorthand.png'),
                const SizedBox(height: 25.0),
                const Text(
                  'GREGG SHORTHAND TRANSLATOR',
                  style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              ],
            ),
          ),
          SizedBox(
            width: 200.0,
            height: 45.0,
            child: Button(
              padding: 0.0,
              child: ElevatedButton(
                onPressed: ()async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    setState(() {
                      file = File(result.files.single.path.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Translate(file: file)),
                      );
                    });
                  }
                }, 
                style: ButtonStyle(                      
                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  overlayColor: MaterialStateProperty.all(Colors.blue[800]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.camera_alt_sharp),
                    Text(
                      'CHOOSE IMAGE',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}