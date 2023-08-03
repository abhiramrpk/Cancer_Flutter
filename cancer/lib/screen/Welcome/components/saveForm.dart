import 'package:flutter/material.dart';
import 'package:cancer/constants.dart';




saveForm(BuildContext ctx) async {
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
                height: defaultPadding*2,
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 70,
                ),
                onTap: () async {
                  // _profileImage =
                  //     await _image_picker.pickImage(source: ImageSource.gallery);
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 50,right: 50,top: 30),
                  child: Column(children: [
                    const TextField(
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                    SizedBox(height: defaultPadding,),
                    const TextField(
                      decoration: InputDecoration(hintText: "Age"),
                    ),
                    SizedBox(height: defaultPadding,),
                    Row(
                      children: [
                        const TextField(
                          decoration: InputDecoration(hintText: "Hieght"),
                        ),
                        SizedBox(height: defaultPadding,),
                        const TextField(
                          decoration: InputDecoration(hintText: "Weight"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding*2,
                    ),
                    SizedBox(
                      width: MediaQuery.of(ctx).size.width / 2,
                      child: TextButton(
                        onPressed: () {},
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