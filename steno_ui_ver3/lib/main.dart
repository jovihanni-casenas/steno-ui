import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:camera_windows/camera_windows.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  double minWidth = 750.0;
  double minHeight = 550.0;

  // setting up minimum screen size
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Gregg Shorthand Translator');
    setWindowMinSize(Size(minWidth, minHeight));
  }

  // getting the camera
  // final cameras = await availableCameras();
  // final firstCam = cameras.first;

  runApp(const MyApp());
  // runApp(MyApp(camera: firstCam,));
}

class MyApp extends StatelessWidget {
  // final CameraDescription camera;

  const MyApp({super.key});
  // const MyApp({super.key, required this.camera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gregg Shorthand Translator',
      color: Colors.grey[300],
      home: const SplashScreen(),
      // home: SplashScreen(camera: camera,),
    );
  }
}

class LandingScreen extends StatefulWidget{
  // final CameraDescription camera;

  const LandingScreen({super.key});
  // const LandingScreen({super.key, required this.camera});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // late CameraController _controller;
  // late Future<void> _initializeControllerFuture;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _controller = CameraController(widget.camera, ResolutionPreset.medium);
  //   _initializeControllerFuture = _controller.initialize();
  // }

  // @override
  // void dispose(){
  //   _controller.dispose();
  //   super.dispose();
  // }

  List<CameraDescription> _cameras = <CameraDescription>[];
  bool _isReady = false;
  final ResolutionPreset _resolutionPreset = ResolutionPreset.medium;
  bool _initialized = false;
  int _cameraId = -1;
  late final Size _previewSize;
  late var _snapPicPath;
  bool _snappedPic = false;

  List<String> selections = ["Shorthand to Longhand","Longhand to Shorthand"];
  late String dropDownValue;

  bool isStoL = true;

  late String longhandInput;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _getCameras();
    // if(_isReady){
    //   print("entering _initializeCamera()");
    //   _initializeCamera();
    //   print("exited _initializeCamera()");
    // }
  }

  @override
  void dispose(){
    _disposeCamera();
    super.dispose();
  }

  Future<void> _getCameras() async{
    List<CameraDescription> cameras = <CameraDescription>[];
    try{
      cameras = await CameraPlatform.instance.availableCameras();
      if(cameras.isEmpty){
        print("no cameras detected");
      }
    } on CameraException {
      print("camera exception");
    }
    if(mounted){
      setState(() {
        _cameras = cameras;
        _isReady = true;
      });
    }
    print("value of isReady : $_isReady");
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async{
    if(_cameras.isEmpty){
      print("_cameras is empty");
      return;
    }
    int cameraId = -1;
    try{
      final CameraDescription camera = _cameras.first;
      print("1cameraId = $cameraId");
      cameraId = await CameraPlatform.instance.createCamera(
        camera,
        _resolutionPreset);
      print("2cameraId = $cameraId");
      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;
      await CameraPlatform.instance.initializeCamera(cameraId);
      final CameraInitializedEvent event = await initialized;
      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );
      if(mounted){
        setState(() {
          _initialized = true;
          _cameraId = cameraId;
        });
      }
      print("value of initialized: $_initialized");
    } on CameraException{
      print("cannot initialize camera");
    }
  }

  Future<void> _disposeCamera() async{
    await CameraPlatform.instance.dispose(_cameraId);
    if(mounted){
      _isReady = false;
      _initialized = false;
      _cameraId = -1;
    }
    else{
      print("cannot mount cam on dispose method");
    }
  }

  Widget _buildPreview(){
    return CameraPlatform.instance.buildPreview(_cameraId);
  }

  void _pausePreview() async{
    await CameraPlatform.instance.pausePreview(_cameraId);
  }

  void _takePicture() async{
    XFile picture = await CameraPlatform.instance.takePicture(_cameraId);
    setState(() {
      _snapPicPath = picture.path;
      _snappedPic = true;
    });
  }

  void _resumePreview() async{
    setState(() {
      _snappedPic = false;
    });
    await CameraPlatform.instance.resumePreview(_cameraId);
  }

  void getDropDownValue(){
    dropDownValue = selections.first;
  }

  Widget _LeftButton(){
    return Frame(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      if(isStoL){
                        _takePicture();
                        _pausePreview();
                      }
                      else{
                        //code here for searching matching label
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                      overlayColor: MaterialStateProperty.all(Colors.grey[500]),
                    ),
                    child: isStoL ?
                    const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    )
                    : const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
  }

  Widget _DropDownSelection(){
      // String dropDownValue = selections.first;
      getDropDownValue();
      return SizedBox(
        width: 400,
        child: DropdownButtonFormField(
        value: dropDownValue,
        icon: const Icon(Icons.arrow_downward_outlined),
        dropdownColor: Colors.grey[500],
        alignment: Alignment.center,
        elevation: 8,
        // focusColor: Colors.grey[300],
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!)
          )
        ),
        onChanged: (String? value) {
          setState(() {
            dropDownValue = value!;
          });
          //insert code here to change the page of the UI
          if(value == selections.last){
            isStoL = false;
          }
          else{
            isStoL = true;
          }
        },
        // onSaved: (String? value) {
        //   setState(() {
        //     dropDownValue = value!;
        //   });
        //   //insert code here to change the page of the UI
        // },
        items: selections.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
    ),
      );
  }

  @override 
  Widget build(BuildContext context){
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //buttons to toggle between S-L and L-S translation
          Frame(
            child: Container(
              alignment: Alignment.center,
              width: 500,
              child: _DropDownSelection(),
            ),
          ),
          const SizedBox(height: 20,),
          // place image or cam preview here
          Frame(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              // height: 300,
              width: 500,
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              // child: FutureBuilder<void>(
              //   future: _initializeControllerFuture,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       // If the Future is complete, display the preview.
              //       return CameraPreview(_controller);
              //     } else {
              //       // Otherwise, display a loading indicator.
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //   },
              // ),
              // child: FittedBox(child: Icon(Icons.image)),
              child: _initialized && isStoL ?
                AspectRatio(
                  aspectRatio: _previewSize.width/_previewSize.height, 
                  child: _snappedPic ?
                    Image.file(File(_snapPicPath))
                    : _buildPreview(),
                )
                : const SizedBox(
                  height: 300,
                  child: FittedBox(child: Icon(Icons.image))
                ),
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // snap pic button
              _LeftButton(),
              const SizedBox(width: 30,),
              // translation word output
              Frame(
                child: SizedBox(
                  height: 50,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: isStoL ?
                        MainAxisAlignment.spaceAround
                        : MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: isStoL ?
                          Text(
                            isStoL ?
                            'TRANSLATION'
                            : 'LONGHAND INPUT',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          )
                          : SizedBox(
                            height: 40,
                            width: 400,
                            child: TextField(
                              onChanged: (value){
                                longhandInput = value;
                                print(longhandInput);
                              },
                              // controller: TextEditingController(),
                              decoration: const InputDecoration(
                                label: Text("Input a word"),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                            ),
                          ),
                        ),
                        if(!isStoL)
                        FloatingActionButton(
                          onPressed: (){},
                          backgroundColor: Colors.grey[300],
                          hoverColor: Colors.grey[500],
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.mic),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30,),
              // refresh button
              Frame(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      _resumePreview();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                      overlayColor: MaterialStateProperty.all(Colors.grey[500]),
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatelessWidget{
  // final CameraDescription camera;

  const SplashScreen({super.key});
  // const SplashScreen({super.key, required this.camera});

  @override 
  Widget build(BuildContext context){
    Future.delayed(
      const Duration(seconds: 3), 
      () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Scaffold(body: LandingScreen(),)))
    );
    // Future.delayed(
    //   const Duration(seconds: 3), 
    //   () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LandingScreen(camera: camera,)))
    // );
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/logo.png'),
          ),
          const SizedBox(
            height: 50,
            child: Text(
              'GREGG SHORTHAND TRANSLATOR',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Frame extends StatelessWidget{
  var child;

  Frame({Key? key, required this.child}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            offset: const Offset(5, 5),
            color: Colors.grey[500]!,
          ),
          const BoxShadow(
            blurRadius: 5.0,
            offset: Offset(-5, -5),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}




// sample code using dropdownbutton
// import 'package:flutter/material.dart';

// const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

// void main() => runApp(const DropdownButtonApp());

// class DropdownButtonApp extends StatelessWidget {
//   const DropdownButtonApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('DropdownButton Sample')),
//         body: const Center(
//           child: DropdownButtonExample(),
//         ),
//       ),
//     );
//   }
// }

// class DropdownButtonExample extends StatefulWidget {
//   const DropdownButtonExample({super.key});

//   @override
//   State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
// }

// class _DropdownButtonExampleState extends State<DropdownButtonExample> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: dropdownValue,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       items: list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
