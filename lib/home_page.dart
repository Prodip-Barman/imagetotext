import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String result = "";
  File? image;
  ImagePicker? imagePicker;

  pickImageFromGallery() async{
    PickedFile? pickedFile = (await imagePicker!.pickImage(source: ImageSource.gallery)) as PickedFile;

    image = File(pickedFile.path);

    setState(() {
      image;
      performImageLabeling();
    });

  }

  pickImageFromCamera() async{
    PickedFile pickedFile = (await imagePicker!.pickImage(source: ImageSource.camera)) as PickedFile;

    image = File(pickedFile.path);

    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async{
    final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(image!);

    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    setState(() {
      for(TextBlock block in visionText.blocks){
        final String? txt = block.text;

        for(TextLine line in block.lines){
          for(TextElement element in line.elements){
            result += element.text!+ " ";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Text("git colaboration",style: TextStyle(fontSize: 30),),
      ),

    );
  }
}
