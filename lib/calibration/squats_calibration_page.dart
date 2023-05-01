// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revivetest2/postcalibration/squats_counter.dart';

class SquatsCalibration extends StatefulWidget {
  const SquatsCalibration({super.key});

  @override
  State<SquatsCalibration> createState() => _SquatsCalibrationState();
}

class _SquatsCalibrationState extends State<SquatsCalibration> {
  // Define variables to store the min and max values
  double _permanenttopSquatsYAngle = 0.0;
  double _permanentbottomSquatsYAngle = double.infinity;
  double _topSquatsYAngle = 0.0;
  double _bottomSquatsYAngle = 0.0;
  bool _istopSquatsCalibrated = false;
  bool _isbottomSquatsCalibrated = false;

  // Create a reference to the Firebase RTDB
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    _databaseRef.child('sensor_data').onChildChanged.listen((event) {
      if (event.snapshot.key == 'yAngle') {
        double yAngle = double.parse(event.snapshot.value.toString());
        if (mounted) {
          setState(() {
            if (_topSquatsYAngle == 0.0 || yAngle > _topSquatsYAngle) {
              _topSquatsYAngle = yAngle;
            }
            if (_bottomSquatsYAngle == 0.0 || yAngle < _bottomSquatsYAngle) {
              _bottomSquatsYAngle = yAngle;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              // Add back button for navigation
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Squats Calibration',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '''Let's calibrate the range of your squats!\n\n• For Initial Calibration: Stand in the starting position of the squat. \n\n • For Final Calibration: Stand in the final position of the squat. \n\n • When both calibrations have finished, press 'Ready to Start' to begin the exercise!''',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[800],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              // Create buttons to start min and max calibration
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _starttopSquatsCalibrationAsync();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: Text(
                      'Calibrate Initial Position',
                      style: GoogleFonts.raleway(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _startbottomSquatsCalibrationAsync();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: Text(
                      'Calibrate Final Position',
                      style: GoogleFonts.raleway(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: _istopSquatsCalibrated ||
                        _isbottomSquatsCalibrated, // show only when either min or max is visible
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[
                            400], // light green color with 40% opacity
                        borderRadius: BorderRadius.circular(
                            10), // set border radius to 10
                      ),
                      padding: EdgeInsets.all(
                          10), // add 10 pixels of padding to all sides
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_istopSquatsCalibrated)
                            Text(
                              'Initial Angle: ${_permanenttopSquatsYAngle.toStringAsFixed(2)}\u00B0',
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          SizedBox(height: 10),
                          if (_isbottomSquatsCalibrated)
                            Text(
                              'Final Angle: ${_permanentbottomSquatsYAngle.toStringAsFixed(2)}\u00B0',
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _istopSquatsCalibrated && _isbottomSquatsCalibrated
                        ? 1.0
                        : 0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Visibility(
                      visible:
                          _istopSquatsCalibrated && _isbottomSquatsCalibrated,
                      child: ElevatedButton(
                        onPressed: () async {
                          final userUid =
                              FirebaseAuth.instance.currentUser?.uid;
                          final DatabaseReference angleDataRef =
                              FirebaseDatabase.instance
                                  .ref()
                                  .child('users/$userUid/angle_data');
                          angleDataRef.update({
                            'squatsBool': true,
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SquatsCounter()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                        ),
                        child: Text(
                          'Ready to Start?',
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _starttopSquatsCalibrationAsync() async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference boolRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    boolRef.update({
      'squatsBool': false,
    });
    // Reset the min value before starting calibration
    if (mounted) {
      setState(() {
        _topSquatsYAngle = 0.0;
        _permanenttopSquatsYAngle = double.infinity;
      });
    }
    _istopSquatsCalibrated = false;
    // Display a dialog to indicate that calibration is in progress
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Calibrating...',
                        style: GoogleFonts.raleway(
                          decoration: TextDecoration.none,
                          color: Colors.lightGreen[800],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    if (_topSquatsYAngle < _permanenttopSquatsYAngle) {
      _permanenttopSquatsYAngle = _topSquatsYAngle;
    }
    // Save the min value to the Firebase RTDB
    final DatabaseReference angleDataRef =
        _databaseRef.child('users/$userUid/angle_data');
    final snapshot = await angleDataRef.once();
    if (snapshot.snapshot.value == null) {
      // There is no data at this location, so use .set() to create the data
      await angleDataRef.set({
        'topSquatsYAngle': _permanenttopSquatsYAngle,
      });
    } else {
      // Data already exists, so use .update() to update the existing data
      await angleDataRef.update({
        'topSquatsYAngle': _permanenttopSquatsYAngle,
      });
    }
    if (_permanenttopSquatsYAngle != 0.0 &&
        _permanenttopSquatsYAngle != double.infinity) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Calibration Successful',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Initial position has been calibrated. \nPress OK to continue...',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          _istopSquatsCalibrated = true;
                        },
                        child: Text(
                          'OK',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Calibration Error',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Initial position has not been calibrated, please try again. \nPress OK to continue...',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _startbottomSquatsCalibrationAsync() async {
    // Reset the min value before starting calibration
    if (mounted) {
      setState(() {
        _bottomSquatsYAngle = 0.0;
        _permanentbottomSquatsYAngle = 0.0;
      });
    }
    _isbottomSquatsCalibrated = false;

    // Display a dialog to indicate that calibration is in progress
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Calibrating...',
                        style: GoogleFonts.raleway(
                          decoration: TextDecoration.none,
                          color: Colors.lightGreen[800],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    if (_bottomSquatsYAngle > _permanentbottomSquatsYAngle) {
      _permanentbottomSquatsYAngle = _bottomSquatsYAngle;
    }

    // Save the min value to the Firebase RTDB
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final angleDataRef = _databaseRef.child('users/$userUid/angle_data');
    final snapshot = await angleDataRef.once();
    if (snapshot.snapshot.value == null) {
      // There is no data at this location, so use .set() to create the data
      await angleDataRef.set({
        'bottomSquatsYAngle': _permanentbottomSquatsYAngle,
      });
    } else {
      // Data already exists, so use .update() to update the existing data
      await angleDataRef.update({
        'bottomSquatsYAngle': _permanentbottomSquatsYAngle,
      });
    }
    if (_permanentbottomSquatsYAngle != 0.0 &&
        _permanentbottomSquatsYAngle != double.infinity) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Calibration Successful',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Final position has been calibrated. \nPress OK to continue...',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          _isbottomSquatsCalibrated = true;
                        },
                        child: Text(
                          'OK',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Calibration Error',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Final position has not been calibrated, please try again. \nPress OK to continue...',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: GoogleFonts.raleway(
                            decoration: TextDecoration.none,
                            color: Colors.lightGreen[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }
}
