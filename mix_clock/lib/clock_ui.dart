// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

// import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_hand.dart';
import 'package:flutter_clock_helper/model.dart';



final radiansPerTick = radians(360 / 60);

final radiansPerHour = radians(360/12);

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final date = DateFormat.yMMMd().format(_dateTime);
    
    final weekDay = DateFormat.EEEE().format(_dateTime);
    
    final time = DateFormat.jm().format(_dateTime);
   
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            

          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.grey,Colors.grey.shade200,Colors.grey.shade400,Colors.grey.shade600,Colors.grey],
                stops: [0.0, 0.45, 0.5, 0.75, 1],
                center: Alignment(-0.425,0),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration( 
              gradient: LinearGradient(
                colors: [Colors.grey,Colors.black12,Colors.black26,Colors.black45,Colors.black87],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
            ),
          ),
          Align(
            alignment: Alignment(-0.889,0),
            child: Container(
              width: 300,
              height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(300)),
              gradient: SweepGradient(
                colors: [Colors.brown.shade500,Colors.brown.shade200.withOpacity(0.9),Colors.brown.shade600.withOpacity(0.1),Colors.brown],
                stops: [0.0,  0.34, 0.65, 1],
                center: Alignment(0,0),
                startAngle: 0.0,
                endAngle: pi/4,
                tileMode: TileMode.repeated
              ),
            ),
          ),
          ),
          Align(
            alignment: Alignment(-0.83,0),
            child: ClipRect(
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX:0.0, sigmaY: 0.0),
                  child: Container(
                    width: 280.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                    ),
                  ),
                ),
              ),
          ),
          Align(
            alignment: Alignment(-0.705, 0),
            child: ClipRect(
                child: BackdropFilter( 
                filter: ImageFilter.blur(sigmaX:0.0, sigmaY: 0.0),
                child: Container(
                  width: 225.0,
                  height: 225.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.55,0),
            child: ClipRect(
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX:0.0, sigmaY: 0.0),
                  child: Container(
                    width: 135.0,
                    height: 135.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ),
          ),

          CustomPaint(
              painter: BackgroundPainter(),
              child: Container(),
            ),

          DrawnHand(
                color: Colors.black,
                thickness: 2.3,
                size: 0.798,
                angleRadians: _dateTime.second * radiansPerTick,
          ),
          DrawnHand(
            color: Colors.black45,
            thickness: 7.23,
            size: 0.629,
            angleRadians: _dateTime.minute * radiansPerTick,
          ),
          DrawnHand(
            color: Colors.black54,
            thickness: 12.23,
            size: 0.345,
            angleRadians: _dateTime.hour*radiansPerHour + (_dateTime.minute/60) * radiansPerHour,
          ),
          
            Positioned(
              right: 15,
              top: 45,
              child: Text(
                time,
                style: GoogleFonts.montserrat(
                  fontSize: 60,
                  fontWeight: FontWeight.w300
                )
              ),
            ),
            
            Positioned( 
              right: 17,
              bottom: 125,
              child: Text ( 
                date,
                style: GoogleFonts.pacifico(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle( letterSpacing: 1),
                )
              ),
            ), 

            Positioned( 
              right: 20,
              bottom: 55,
              child: Text( 
                '-'+weekDay,
                style: GoogleFonts.dancingScript(
                  fontSize: 54,
                  fontWeight: FontWeight.w400,
                  textStyle: TextStyle(letterSpacing: 2.5)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
 DateTime _dateTime = DateTime.now();
 

  @override
  void paint(Canvas canvas, Size size) {

    final double hour12 = double.parse(DateFormat('hh').format(_dateTime));

    Offset center = Offset(size.width/3.5, size.height/2);

    

    

    

    

    Paint paint1 = Paint()
    ..color = Colors.black54
    ..strokeWidth = 3.5
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.shortestSide*0.5 - 35), -pi/2, _dateTime.second * radiansPerTick, false, paint1);

    
    
    
   
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.shortestSide*0.5 - 62.0), -pi/2,  _dateTime.minute * radiansPerTick, false, paint1);


   
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.shortestSide*0.5 - 109.0), -pi/2, hour12 * radiansPerHour + (_dateTime.minute / 60) * radiansPerHour, false, paint1);


    
    paint1.color = Colors.black;
    paint1.style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, paint1);

    Paint paint = Paint();
    paint.color=Colors.brown.shade700.withOpacity(0.8);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.9;
    
    canvas.drawCircle(center,size.shortestSide*0.5 - 25,paint);
    
  }


  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BackgroundPainter oldDelegate) => false;
}