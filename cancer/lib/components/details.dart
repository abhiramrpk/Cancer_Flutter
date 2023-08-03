import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var _profileImage;
  String _name = 'Name';
  String _id = 'ID';
  String _age='32';
  String _weight = '68';
  String _hieght = '1.75';
  var _scanImage=AssetImage('assets/images/photo.png');
  var _report = ['Cancer',0.0145];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        extendBodyBehindAppBar: true,
        body: ListView(padding: EdgeInsets.all(0), children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/diagnosing-oral-cancer.jpeg'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                  bottom: -70,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 75,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? (_profileImage)
                          : AssetImage(''),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 70,
          ),
          Container(
            child: Column(
              children: [
                titleSubtitle(_name, _id, titleSize: 30, subtitleSize: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  child: Container(
                    height: 70,
                    padding:
                        const EdgeInsets.only(top: 10, left: 50, right: 50),
                    decoration: shadowBox(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleSubtitle(_age, "Age"),
                        titleSubtitle(_weight, "Wieght"),
                        titleSubtitle(_hieght, "Hieght"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Scan Report"),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image:_scanImage),
                  ),
                )),
                SizedBox(
                  height: 20,
                ),
                Text("Prediction"),
                reportCard(_report)
              ],
            )),
          )
        ]));
  }

  BoxDecoration shadowBox() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 213, 213, 213),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(4, 4)),
        ]);
  }

  Column titleSubtitle(String title, String subtitle,
      {double titleSize = 25, double subtitleSize = 12}) {
    return Column(
      children: [
        Text(
          "${title}",
          style: TextStyle(
              fontSize: titleSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Text("${subtitle}")
      ],
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Icon(Icons.arrow_back, color: Colors.black),
  );
}

Row reportCard(List predict) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        predict[0],
        style: TextStyle(
            fontSize: 30, color: kPrimaryColor, fontWeight: FontWeight.w600),
      ),
      CircularPercentIndicator(
        radius: 30,
        animation: true,
        progressColor: kPrimaryColor,
        percent: predict[1],
        lineWidth: 10,
        center: Text(
          (predict[1]*100).toStringAsFixed(0),
          style: TextStyle(fontSize: 15, color: kPrimaryColor),
        ),
      )
    ],
  );
}