// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revivetest2/intro/get_angle_info.dart';
import 'package:revivetest2/intro/get_current_angle_info.dart';

class KneeExtensionsCounter extends StatefulWidget {
  const KneeExtensionsCounter({super.key});

  @override
  State<KneeExtensionsCounter> createState() => _KneeExtensionsCounterState();
}

class _KneeExtensionsCounterState extends State<KneeExtensionsCounter> {
  @override
  void initState() {
    super.initState();
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    angleDataRef.update({
      'KneeExtensionsCounter': 0,
    }).then((_) {
      print(
          'KneeExtensions counter initialized at ${angleDataRef.child('kneeExtensionsCounter').path}');
    }).catchError((error) {
      print('Failed to initialize kneeExtensions counter: $error');
    });
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
                    'Knee Extensions Counter',
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
                        'Initial Knee Extension Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetAngleInfo(
                          component: AngleComponent.topKneeExtensionsYAngle),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Final Knee Extension Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetAngleInfo(
                        component: AngleComponent.bottomKneeExtensionsYAngle,
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
                      'Total Knee Extensions:',
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GetAngleInfo(
                        component: AngleComponent.kneeExtensionsCounter),
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
