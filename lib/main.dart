import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/bottom_controls.dart';
import 'package:music_player/songs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'music_player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        primaryColorLight: Colors.green,
        primarySwatch: Colors.yellow,
        accentColor: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.deepPurpleAccent,
          onPressed: () {},
        ),
        title: Title(
          color: Colors.deepPurpleAccent,
          title: 'WAVE Audio Player',
          child: Text('WAVE'),
        ),
      ),
      body: new Column(
        children: <Widget>[
          //Seek Bar Currrently just album artwork
          new Expanded(
            child: new Center(
              child: new Container(
                width: 125.0, 
                height: 125.0, 
                child: RadialSeekBar( //shows song's playback progress/seek bar 
                  progressPercentage: 0.3, //percentage of circle for progress bar 
                  thumbPosition: 0.3,
                  child: albumArt, //album artwork clip oval 
                )
              )
            ),
          ),

          //visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          //Song title, artists name, player controls
          //A column with rows
          new BottomControls(),
        ],
      ),
    );
  }
}


/////////////////////////////
////Radial Seek Bar Widget////
//////////////////////////////
class RadialSeekBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercentage;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final Widget child;

  RadialSeekBar({ 
    this.trackWidth = 3.0,
    this.trackColor = Colors.indigoAccent,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black87,
    this.progressPercentage = 0.0,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.0,
    this.child,
  });
  @override
  _RadialSeekBarState createState() => new _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new RadialSeekBarPainter(
          progressColor: widget.progressColor,
          progressPercentage: widget.progressPercentage, 
          progressWidth: widget.progressWidth, 
          thumbColor: widget.thumbColor, 
          thumbPosition: widget.thumbPosition, 
          thumbSize: widget.thumbSize, 
          trackColor: widget.trackColor, 
          trackWidth: widget.trackWidth,
          
      ),
      child: widget.child,
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  
  final Paint trackPaint;
  final double progressWidth;
  
  final double progressPercentage;
  final Paint progressPaint;
  final double thumbSize;
 
  final double thumbPosition;
  final Paint thumbPaint;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercentage,
    @required this.thumbSize,
    @required thumbColor,
    @required this.thumbPosition
  })
    : trackPaint = new Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth,
      progressPaint = new Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = progressWidth
         ..strokeCap = StrokeCap.round,
      thumbPaint = new Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    //this is the center point of the rectangular bounds we are cofined to when painting this seekbar 
    final center = new Offset(size.width / 2, size.height / 2);
    //radius of the circle we are painting. must be min value of whatever we are using 
    final radius = min(size.height, size.width) / 2;
    
    ////paint the track//
    /////
    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    ////paint progress/seek bar //
    /////
    final progressAngle = 2 * pi * progressPercentage;// math for progress angle
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),// bounds // bounds are a square around the centre
      -pi / 2, //top of the circle ,starting point
      progressAngle, //sweep angle for progress indicator 
      false, 
      progressPaint, 
    );
    //// Paint thumb ///
    /////
    ////Finding  thumb position using angles around the circle
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2); //absolute angle of thumb position
    final thumbX = cos(thumbAngle) * radius; //x coordinate of thumb 
    final thumbY = sin(thumbAngle) * radius; //y coordinate of thumb 
    final thumbCanter = new Offset(thumbX, thumbY) + center; //Thumb center is center of thumb which is offset from                                              actual circle center of the clip art
    final thumbRadius = thumbSize / 2; // thumbSize is diameter, radius = D/2
    canvas.drawCircle(
      thumbCanter, 
      thumbRadius, 
      thumbPaint,
    );
  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

var albumArt = ClipOval(
  clipper: new CircleClipper(),
  child: new Image.network(
    demoPlaylist.songs[0].albumArtUrl,
    fit: BoxFit.cover,
  ),
);

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
