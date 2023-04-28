// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class KneeExtensionsCalibration extends StatefulWidget {
  const KneeExtensionsCalibration({super.key});

  @override
  State<KneeExtensionsCalibration> createState() =>
      _KneeExtensionsCalibrationState();
}

class _KneeExtensionsCalibrationState extends State<KneeExtensionsCalibration> {
  // Define variables to store the min and max values
  double _minKneeExtensionsyAngle = 0.0;
  double _maxKneeExtensionsyAngle = 0.0;

  double _permanentMinKneeExtensionsyAngle = double.infinity;
  double _permanentMaxKneeExtensionsyAngle = 0.0;

  bool _isMinExtensionsCalibrated = false;
  bool _isMaxExtensionsCalibrated = false;
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
            if (_minKneeExtensionsyAngle == 0.0 ||
                yAngle < _minKneeExtensionsyAngle) {
              _minKneeExtensionsyAngle = yAngle;
            }
            if (_maxKneeExtensionsyAngle == 0.0 ||
                yAngle > _maxKneeExtensionsyAngle) {
              _maxKneeExtensionsyAngle = yAngle;
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
                    'Knee Extensions Calibration',
                    style: GoogleFonts.raleway(
                      fontSize: 22,
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
                  '''Let's calibrate the range of your knee extensions!\n\n• For Initial Calibration: Stand in the starting position of the knee extension. \n\n • For Final Calibration: Stand in the final position of the knee extension. \n\n • When both calibrations have finished, press 'Ready to Start' to begin the exercise!''',
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
                      await _startMinKneeExtensionsCalibrationAsync();
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
                      await _startMaxKneeExtensionsCalibrationAsync();
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
                    visible: _isMinExtensionsCalibrated ||
                        _isMaxExtensionsCalibrated, // show only when either min or max is visible
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
                          if (_isMinExtensionsCalibrated)
                            Text(
                              'Initial Angle: ${_permanentMinKneeExtensionsyAngle.toStringAsFixed(2)}\u00B0',
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          SizedBox(height: 10),
                          if (_isMaxExtensionsCalibrated)
                            Text(
                              'Final Angle: ${_permanentMaxKneeExtensionsyAngle.toStringAsFixed(2)}\u00B0',
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
                    opacity:
                        _isMinExtensionsCalibrated && _isMaxExtensionsCalibrated
                            ? 1.0
                            : 0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Visibility(
                      visible: _isMinExtensionsCalibrated &&
                          _isMaxExtensionsCalibrated,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add functionality for ready button
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
                          'Ready to Start ?',
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

  Future<void> _startMinKneeExtensionsCalibrationAsync() async {
    // Reset the min value before starting calibration
    if (mounted) {
      setState(() {
        _minKneeExtensionsyAngle = 0.0;
        _permanentMinKneeExtensionsyAngle = double.infinity;
      });
    }
    _isMinExtensionsCalibrated = false;
    // Display a dialog to indicate that calibration is in progress
    showDialog(
      barrierDismissible: false, // set barrierDismissible to false
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrating...'),
        content: Text(
            'Please stand in the starting position of the knee extension.'),
      ),
    );

    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    if (_minKneeExtensionsyAngle < _permanentMinKneeExtensionsyAngle) {
      _permanentMinKneeExtensionsyAngle = _minKneeExtensionsyAngle;
    }
    // Save the min value to the Firebase RTDB
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final angleDataRef = _databaseRef.child('users/$userUid/angle_data');
    final snapshot = await angleDataRef.once();
    if (snapshot.snapshot.value == null) {
      // There is no data at this location, so use .set() to create the data
      await angleDataRef.set({
        'minKneeExtensionsyAngle': _permanentMinKneeExtensionsyAngle,
      });
    } else {
      // Data already exists, so use .update() to update the existing data
      await angleDataRef.update({
        'minKneeExtensionsyAngle': _permanentMinKneeExtensionsyAngle,
      });
    }
    if (_permanentMinKneeExtensionsyAngle != 0.0 &&
        _permanentMinKneeExtensionsyAngle != double.infinity) {
      if (mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Calibration Successful'),
            content: Text('Minimum calibration value saved.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // first pop
                  Navigator.pop(context); // second pop
                  _isMinExtensionsCalibrated = true;
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // set barrierDismissible to true
          builder: (context) => AlertDialog(
            title: Text('Calibration Error'),
            content:
                Text('Please ensure that the sensor is calibrated correctly.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // first pop
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _startMaxKneeExtensionsCalibrationAsync() async {
    // Reset the min value before starting calibration
    if (mounted) {
      setState(() {
        _maxKneeExtensionsyAngle = 0.0;
        _permanentMaxKneeExtensionsyAngle = 0.0;
      });
    }
    _isMaxExtensionsCalibrated = false;

    // Display a dialog to indicate that calibration is in progress
    showDialog(
      barrierDismissible: false, // set barrierDismissible to false
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrating...'),
        content:
            Text('Please stand in the final position of the knee extension.'),
      ),
    );
    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    if (_maxKneeExtensionsyAngle > _permanentMaxKneeExtensionsyAngle) {
      _permanentMaxKneeExtensionsyAngle = _maxKneeExtensionsyAngle;
    }
    print(_permanentMaxKneeExtensionsyAngle);
    // Save the min value to the Firebase RTDB
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final angleDataRef = _databaseRef.child('users/$userUid/angle_data');
    final snapshot = await angleDataRef.once();
    if (snapshot.snapshot.value == null) {
      // There is no data at this location, so use .set() to create the data
      await angleDataRef.set({
        'maxKneeExtensionsyAngle': _permanentMaxKneeExtensionsyAngle,
      });
    } else {
      // Data already exists, so use .update() to update the existing data
      await angleDataRef.update({
        'maxKneeExtensionsyAngle': _permanentMaxKneeExtensionsyAngle,
      });
    }
    if (_permanentMaxKneeExtensionsyAngle != 0.0 &&
        _permanentMaxKneeExtensionsyAngle != double.infinity) {
      if (mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Calibration Successful'),
            content: Text('Maximum calibration value saved.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // first pop
                  Navigator.pop(context); // second pop
                  _isMaxExtensionsCalibrated = true;
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Calibration Error'),
            content:
                Text('Please ensure that the sensor is calibrated correctly.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // first pop
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
