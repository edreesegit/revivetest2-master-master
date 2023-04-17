// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class HeelSlidesCalibration extends StatefulWidget {
  const HeelSlidesCalibration({super.key});

  @override
  State<HeelSlidesCalibration> createState() => _HeelSlidesCalibrationState();
}

class _HeelSlidesCalibrationState extends State<HeelSlidesCalibration> {
  // Define variables to store the min and max values
  double _minHeelSlidesXAngle = 0.0;
  double _maxHeelSlidesXAngle = 0.0;
  bool _isMinSlidesCalibrating = false;
  bool _isMaxSlidesCalibrating = false;
  bool _isMinSlidesCalibrated = false;
  bool _isMaxSlidesCalibrated = false;
  // Create a reference to the Firebase RTDB
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    // Listen to changes in the xAngle value in the sensor_data node
    _databaseRef.child('sensor_data').onChildChanged.listen((event) {
      if (event.snapshot.key == 'xAngle') {
        double xAngle = double.parse(event.snapshot.value.toString());
        // Update the min and max values based on the xAngle value
        setState(() {
          if (_minHeelSlidesXAngle == 0.0 || xAngle < _minHeelSlidesXAngle) {
            _minHeelSlidesXAngle = xAngle;
          }
          if (_maxHeelSlidesXAngle == 0.0 || xAngle > _maxHeelSlidesXAngle) {
            _maxHeelSlidesXAngle = xAngle;
          }
        });
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
                    'Heel Slides Calibration',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '''Before we start the exercise, we need to calibrate the range that you are capable of doing as of now.\n\nFirst, stand in the starting position of the squat and then press the minimum calibration button. Stand until it says calibration finished.\n\nThen, perform the squat as low as you can and press the maximum calibration button. Wait until calibration is finished.''',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Create buttons to start min and max calibration
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isMinSlidesCalibrating = true;
                      });
                      await _startMinCalibrationAsync();
                      setState(() {
                        _isMinSlidesCalibrating = false;
                      });
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
                      'Start Min. Calibration',
                      style: GoogleFonts.raleway(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isMaxSlidesCalibrating = true;
                      });
                      await _startMaxCalibrationAsync();
                      setState(() {
                        _isMaxSlidesCalibrating = false;
                      });
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
                      'Start Max. Calibration',
                      style: GoogleFonts.raleway(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // Display the current min and max values
              if (_isMinSlidesCalibrated) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Min X: ${_minHeelSlidesXAngle.toString()}',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isMaxSlidesCalibrated) ...[
                        Text(
                          'Max X: ${_maxHeelSlidesXAngle.toString()}',
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startMinCalibrationAsync() async {
    // Reset the min value before starting calibration
    setState(() {
      _minHeelSlidesXAngle = 0.0;
    });

    // Display a dialog to indicate that calibration is in progress
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrating...'),
        content: Text('Please stand in the starting position of the squat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    try {
      // Save the min value to the Firebase RTDB
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      await _databaseRef
          .child('users/$userUid')
          .child('angle_data')
          .update({'minimumHeelSlidesXAngle': _minHeelSlidesXAngle});
      // Set _iscalibrated to true if both min and max values have been saved
      if (_maxHeelSlidesXAngle != 0.0) {
        setState(() {
          _isMinSlidesCalibrated = true;
        });
      }
      // Display a success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Calibration Successful'),
          content: Text('Minimum calibration value saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // first pop
                Navigator.pop(context); // second pop
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      // Handle the error by showing an error dialog or printing to console
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save minimumX value: $error'),
        ),
      );
    }
  }

  Future<void> _startMaxCalibrationAsync() async {
    // Reset the max value before starting calibration
    setState(() {
      _maxHeelSlidesXAngle = 0.0;
    });

    // Display a dialog to indicate that calibration is in progress
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrating...'),
        content: Text('Please stand in the final position of the squat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    // Wait for 5 seconds to collect samples
    await Future.delayed(Duration(seconds: 5));

    try {
      // Save the max value to the Firebase RTDB
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      await _databaseRef
          .child('users/$userUid')
          .child('angle_data')
          .child('heel_slides')
          .update({'maximumHeelSlidesXAngle': _maxHeelSlidesXAngle});
      // Set _iscalibrated to true if both min and max values have been saved
      if (_minHeelSlidesXAngle != 0.0) {
        setState(() {
          _isMaxSlidesCalibrated = true;
        });
      }
      // Display a success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Calibration Successful'),
          content: Text('Maximum calibration value saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // pop once
                Navigator.pop(context); // pop twice
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      // Handle the error by showing an error dialog or printing to console
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save maximumX value: $error'),
        ),
      );
    }
  }
}
