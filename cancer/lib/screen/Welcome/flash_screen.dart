import 'dart:async';

import 'package:cancer/constants.dart';
import 'package:cancer/screen/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
   void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const WelcomeScreen())));
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(child: Container(padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image.asset('assets/images/logo.png'),
            const CircularProgressIndicator(color: kPrimaryColor,),
  
          ],
        ),)));
  }
}



