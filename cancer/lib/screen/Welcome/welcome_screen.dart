import 'package:flutter/material.dart';
import 'package:cancer/components/background.dart';
import 'package:cancer/responsive.dart';
import 'components/saveForm.dart';
import 'components/welcome_image.dart';
import 'package:cancer/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'dart:io';
import 'package:dio/dio.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: WelcomeImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        //child: LoginAndSignupBtn(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatefulWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileWelcomeScreen> createState() => _MobileWelcomeScreenState();
}

class _MobileWelcomeScreenState extends State<MobileWelcomeScreen> {
  List? _output;
  var _image, accuracy;
  bool _loading = false;
  final _image_picker = ImagePicker();
  var _pImage;
  @override
  void initState() {
    super.initState();
    _loading = true;
  }

  
  stateSet(image) {
    setState(() {
      _pImage = image;
    });
  }

  pickImage(source) async {
    var image = await _image_picker.pickImage(source: source);

    if (image == null) {
      return null;
    }

    //----------------------------------------------------
    print((image.path));
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    var dio = Dio();
    accuracy = null;
    try {
      Response response =
          await dio.get('http://172.105.35.214:8000/get-csrf-token');
      dio.options.headers['X-CSRF-TOKEN'] = response.headers['csrf-token'];

      File file = File(image.path);
      MultipartFile multipartFile = MultipartFile.fromFileSync(file.path,
          filename: file.path.split('/').last);
      print(multipartFile);
      FormData data = FormData.fromMap({'image_url': multipartFile});
      print(data.files);
      var apiResponse =
          await dio.post("http://172.105.35.214:8000/scan/", data: data);
      print(apiResponse.data);
      accuracy = double.parse(apiResponse.data);
      setState(() {
        if (accuracy < 0.5) {
          _output = ["Cancer", 1 - accuracy];
        } else {
          _output = ["Non Cancer", accuracy];
        }
        _loading = false;
      });
    } catch (e) {
      print('Error fetching CSRF token: $e');
    }
    // classifyImage(_image);
  }
//-------------------------------------------------------------------------------------
  // classifyImage(File image) async {
  //   var output = await Tflite.runModelOnImage(
  //       path: image.path,
  //       numResults: 2,
  //       threshold: 0.5,
  //       imageMean: 127.5,
  //       imageStd: 127.5);

  //}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:2.0),
          child: const WelcomeImage(),
        ),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: _image != null
                  ? Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 350,
                          width: 350,
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: defaultPadding * 2),
                        card(),
                      ],
                    )
                  : InkWell(
                      child: Image.asset("assets/images/photo.png"),
                      onTap: () => {imageOption(context)},
                    ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Column card() {
    return Column(
      children: [
        accuracy == null ? loading() : reportCard(),
        // TextButton(onPressed: ()=>{}, child: Text("Save",style: TextStyle(fontSize: 30),))
        const SizedBox(
          height: defaultPadding * 2,
        ),
        accuracy != null ? saveButton() : const SizedBox(),
        const SizedBox(
          height: defaultPadding * 2,
        ),
        accuracy != null ? scanButton() : const SizedBox(),
      ],
    );
  }

  Container saveButton() {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: () => saveForm(context, _image, _output),
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryColor, Color.fromARGB(255, 209, 186, 240)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: const Text(
              "Save",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Container scanButton() {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: () => imageOption(context),
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryColor, Color.fromARGB(255, 209, 186, 240)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: const Text(
              "Scan Again?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  imageOption(BuildContext ctx) async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      backgroundColor: kPrimaryColor,
      context: ctx,
      builder: (ctx) {
        return SizedBox(
          height: 80,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              onPressed: () {
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.image,
                size: 40,
                color: kPrimaryLightColor,
              ),
            ),
            IconButton(
              onPressed: () {
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.camera,
                color: kPrimaryLightColor,
                size: 40,
              ),
            )
          ]),
        );
      },
    );
  }

  Row reportCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _output != null
            ? Text(
                "${(_output?[0])}",
                style: const TextStyle(fontSize: 30, color: kPrimaryColor),
              )
            : const Text(""),
        CircularPercentIndicator(
          radius: 50,
          animation: true,
          progressColor: kPrimaryColor,
          percent: _output?[1],
          lineWidth: 10,
          center: Text(
            "${(_output?[1] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(fontSize: 25, color: kPrimaryColor),
          ),
        )
      ],
    );
  }

  Row loading() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Loading", style: TextStyle(fontSize: 30, color: kPrimaryColor)),
        CircularProgressIndicator(
          color: kPrimaryColor,
        )
      ],
    );
  }

}
