// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revivetest2/intro/get_angle_info.dart';
import 'package:revivetest2/intro/get_current_angle_info.dart';

class HeelSlidesCounter extends StatefulWidget {
  const HeelSlidesCounter({super.key});

  @override
  State<HeelSlidesCounter> createState() => _HeelSlidesCounterState();
}

class _HeelSlidesCounterState extends State<HeelSlidesCounter> {
  @override
  void initState() {
    super.initState();
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    angleDataRef.update({
      'heelSlidesCounter': 0,
    }).then((_) {
      print(
          'heelSlides counter initialized at ${angleDataRef.child('heelSlidesCounter').path}');
    }).catchError((error) {
      print('Failed to initialize heelSlides counter: $error');
    });
  }

  @override
  void dispose() {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    angleDataRef.update({
      'heelSlidesBool': false,
    }).then((_) {
      print('Data updated at ${angleDataRef.path}');
    }).catchError((error) {
      print('Failed to update data: $error');
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Heel Slides Counter',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(2),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Initial Heel Slide Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetAngleInfo(
                          component: AngleComponent.topHeelSlidesYAngle),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Final Heel Slide Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetAngleInfo(
                        component: AngleComponent.bottomHeelSlidesYAngle,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Current Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetCurrentAngleInfo(
                        component: CurrentAngleComponent.currentYAngle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 1, right: 1, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Heel Slides:',
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GetAngleInfo(component: AngleComponent.heelSlidesCounter),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(double.infinity, 0),
                        ),
                        child: Text(
                          'End Session',
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
