// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class SquatsCalibration extends StatefulWidget {
  const SquatsCalibration({super.key});

  @override
  State<SquatsCalibration> createState() => _SquatsCalibrationState();
}

class _SquatsCalibrationState extends State<SquatsCalibration> {
  // Define variables to store the min and max values
  double _permanentMinSquatsXAngle = double.infinity;
  double _permanentMaxSquatsXAngle = 0.0;
  double _minSquatsXAngle = 0.0;
  double _maxSquatsXAngle = 0.0;
  bool _isMinSquatsCalibrated = false;
  bool _isMaxSquatsCalibrated = false;

  // Create a reference to the Firebase RTDB
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _databaseRef.child('sensor_data').onChildChanged.listen((event) {
      if (event.snapshot.key == 'xAngle') {
        double xAngle = double.parse(event.snapshot.value.toString());
        if (mounted) {
          setState(() {
            if (_minSquatsXAngle == 0.0 || xAngle < _minSquatsXAngle) {
              _minSquatsXAngle = xAngle;
            }
            if (_maxSquatsXAngle == 0.0 || xAngle > _maxSquatsXAngle) {
              _maxSquatsXAngle = xAngle;
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
                      await _startMinCalibrationAsync();
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
                      await _startMaxCalibrationAsync();
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
                    visible: _isMinSquatsCalibrated ||
                        _isMaxSquatsCalibrated, // show only when either min or max is visible
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
                          if (_isMinSquatsCalibrated)
                            Text(
                              'Initial Angle: ${_permanentMinSquatsXAngle.toStringAsFixed(2)}\u00B0',
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          SizedBox(height: 10),
                          if (_isMaxSquatsCalibrated)
                            Text(
                              'Final Angle: ${_permanentMaxSquatsXAngle.toStringAsFixed(2)}\u00B0',
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
                    opacity: _isMinSquatsCalibrated && _isMaxSquatsCalibrated
                        ? 1.0
                        : 0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Visibility(
                      visible: _isMinSquatsCalibrated && _isMaxSquatsCalibrated,
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

  Future<void> _startMinCalibrationAsync() async {
    // Reset the min value before starting calibration
    if (mounted) {
      setState(() {
        _minSquatsXAngle = 0.0;
        _permanentMinSquatsXAngle = double.infinity;
      });
    }
    _isMinSquatsCalibrated = false;
    // Display a dialog to indicate that calibration is in progress
    showDialog(
      barrierDismissible: false, // set barrierDismissible to false
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrating...'),
        content: Text('Please stand in the starting position of the squat.'),
      ),
    );

    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    if (_minSquatsXAngle < _permanentMinSquatsXAngle) {
      _permanentMinSquatsXAngle = _minSquatsXAngle;
    }
    // Save the min value to the Firebase RTDB
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final angleDataRef = _databaseRef.child('users/$userUid/angle_data');
    final snapshot = await angleDataRef.once();
    if (snapshot.snapshot.value == null) {
      // There is no data at this location, so use .set() to create the data
      await angleDataRef.set({
        'minSquatsXAngle': _permanentMinSquatsXAngle,
      });
    } else {
      // Data already exists, so use .update() to update the existing data
      await angleDataRef.update({
        'minSquatsXAngle': _permanentMinSquatsXAngle,
      });
    }
    if (_permanentMinSquatsXAngle != 0.0 &&
        _permanentMinSquatsXAngle != double.infinity) {
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
                  _isMinSquatsCalibrated = true;
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

  Future<void> _startMaxCalibrationAsync() async {
    // Reset the min value before starting calibration
    if (mounted) {
      setState(() {
        _maxSquatsXAngle = 0.0;
        _permanentMaxSquatsXAngle = 0.0;
      });
    }
    _isMaxSquatsCalibrated = false;

    // Display a dialog to indicate that calibration is in progress
    showDialog(
      barrierDismissible: false, // set barrierDismissible to false
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrating...'),
        content: Text('Please stand in the final position of the squat.'),
      ),
    );
    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    if (_maxSquatsXAngle > _permanentMaxSquatsXAngle) {
      _permanentMaxSquatsXAngle = _maxSquatsXAngle;
    }
    print(_permanentMaxSquatsXAngle);
    // Save the min value to the Firebase RTDB
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final angleDataRef = _databaseRef.child('users/$userUid/angle_data');
    final snapshot = await angleDataRef.once();
    if (snapshot.snapshot.value == null) {
      // There is no data at this location, so use .set() to create the data
      await angleDataRef.set({
        'maxSquatsXAngle': _permanentMaxSquatsXAngle,
      });
    } else {
      // Data already exists, so use .update() to update the existing data
      await angleDataRef.update({
        'maxSquatsXAngle': _permanentMaxSquatsXAngle,
      });
    }
    if (_permanentMaxSquatsXAngle != 0.0 &&
        _permanentMaxSquatsXAngle != double.infinity) {
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
                  _isMaxSquatsCalibrated = true;
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
