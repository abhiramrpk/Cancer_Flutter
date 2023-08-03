import 'package:flutter/material.dart';
import 'package:cancer/constants.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

saveForm(BuildContext ctx) async {
  var formData = <String, dynamic>{};
  var _profileImage;
  final _image_picker = ImagePicker();

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    backgroundColor: Colors.white,
    context: ctx,
    builder: (ctx) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding * 2,
            ),
            InkWell(
              child: const CircleAvatar(
                radius: 70,
              ),
              onTap: () async {
                _profileImage =
                    await _image_picker.pickImage(source: ImageSource.gallery);
                File file = File(_profileImage.path);
                MultipartFile multipartFile = MultipartFile.fromFileSync(
                    file.path,
                    filename: file.path.split('/').last);
                formData["image_url"] = multipartFile;
              },
            ),
            Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
                child: Column(children: [
                  TextField(
                    decoration: const InputDecoration(hintText: "Name"),
                    onChanged: (value) => formData["name"] = value,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Age"),
                    onChanged: (value) => formData["age"] = value,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Blood Group"),
                    onChanged: (value) => formData["blood_group"] = value,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(hintText: "Hieght"),
                          onChanged: (value) => formData["height"] = value,
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(hintText: "Weight"),
                          onChanged: (value) => formData["weight"] = value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  SizedBox(
                    width: MediaQuery.of(ctx).size.width / 2,
                    child: TextButton(
                      onPressed: () async {
                        var dio = Dio();
                        try {
                          Response response = await dio
                              .get('http://192.168.56.1:8000/get-csrf-token');
                          dio.options.headers['X-CSRF-TOKEN'] =
                              response.headers['csrf-token'];

                          FormData data = FormData.fromMap(formData);
                          var apiResponse = await dio.post(
                              "http://192.168.56.1:8000/upload/",
                              data: data);
                          print(apiResponse.data);
                        } catch (e) {
                          print('Error fetching CSRF token: $e');
                        }
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(kPrimaryColor),
                          foregroundColor:
                              MaterialStatePropertyAll(kPrimaryLightColor)),
                      child: const Text("Save"),
                    ),
                  )
                ]))
          ],
        ),
      );
    },
  );
}
