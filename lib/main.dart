import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/bottom_controls.dart';
import 'package:music_player/songs.dart';
import 'package:music_player/theme.dart';
import 'package:fluttery/gestures.dart';

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
      home: MyHomePage(title: 'Wave Audio Player'),
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
          color: lightAccentColor,
          onPressed: () {},
        ),
        title: Title(
          color: accentColor,
          title: 'WAVE Audio Player',
          child: Text('WAVE'),
        ),
      ),
      body: new Column(
        children: <Widget>[
          //////////////////////////////
          ////////// SEEK BAR ////////////
          /////////////////////////////////
          //To make seek bar draggable think about what type of things need to be done
          //Touch range/sensitivity; where should th euser have to touch
          //Probably want a big touch space and will have to make appropriate changes
          //Seek Bar Currrently just album artwork// Seekbar currently with static progress bar and seekbar
          //Adding the extra container inside the Expanded around the progressbar lets the progressbar remain modular after adding touch capablities
          new Expanded(
            child: new RadialSeekBar(), //Stateful Radial Seekbar widget with gestures
          ),
          //////////////////////////////
          ////////// VISUALIZER ////////////
          /////////////////////////////////
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          //////////////////////////////////////////
          ////////// Bottom Controls and Song////////////
          /////////////////////////////////////////////
          new BottomControls(),
        ],
      ),
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  double _seekPercentage = 0.0; // this must change based on start position and song duration
  PolarCoord _startDragCoord; //hold onto start drag coord to calculate net drag change at any poin in time
  double _startDragPercentage;
  double _currentDragPercent; //Used to calculate seek perdentage during play

  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercentage = _seekPercentage;
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(() => {
          //updating dragPercent using start drag coord
      _currentDragPercent = (_startDragPercentage + dragPercent) % 1.0 
          //keep it equal and lower than 100percent
    });
  }

  void _onDragEnd() {
    setState(() {
      _seekPercentage = _currentDragPercent;
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercentage = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RadialDragGestureDetector(
      //define these functions in state object to listen to changes//
      //functions for radial gesture detector
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: new Container(
        color: Color(0xFF11FFFF),
        width: double.infinity,
        height: double.infinity,
        child: new Center(
            child: new Container(
                width: 150.0,
                height: 150.0,
                child: RadialProgressBar(
                  //shows song's playback progress/seek bar
                  trackColor: Color(0xFFDDDDDD),
                  progressPercentage: _currentDragPercent ?? _seekPercentage, 
                  //percentage of circle for progress bar; uses current drag percent if its neither null nor zero
                  progressColor: accentColor,
                  thumbPosition: _currentDragPercent ?? _seekPercentage,
                  thumbColor: lightAccentColor,
                  innerPadding: EdgeInsets.all(10.0),
                  child: albumArt, //album artwork clip oval
                ))),
      ),
    );
  }
}

/////////////////////////////
//// Radial Progress Bar ////////
//////////////////////////////
class RadialProgressBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercentage;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final EdgeInsets outerPaddding; //padding around RadialProgressBar
  final EdgeInsets innerPadding; //padding between radial seekbar and
  final Widget child;

  RadialProgressBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.indigoAccent,
    this.progressWidth = 5.0,
    this.progressColor = Colors.deepOrangeAccent,
    this.progressPercentage = 0.0,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.deepPurpleAccent,
    this.thumbPosition = 0.0,
    this.outerPaddding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });
  @override
  _RadialProgressBarState createState() => new _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {
  EdgeInsets _insetsForPainter() {
    // Make room for the painted track, progress, and thumb.  We divide by 2.0
    // because we want to allow flush painting against the track, so we only
    // need to account the thickness outside the track, not inside.
    final outerThickness = max(
          widget.trackWidth,
          max(widget.progressWidth, widget.thumbSize),
        ) /
        2.0;
    return new EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: widget.outerPaddding,
      child: new CustomPaint(
        foregroundPainter: new RadialProgressBarPainter(
          //switch from painter to foregroundPainter
          progressColor: widget.progressColor,
          progressPercentage: widget.progressPercentage,
          progressWidth: widget.progressWidth,
          thumbColor: widget.thumbColor,
          thumbPosition: widget.thumbPosition,
          thumbSize: widget.thumbSize,
          trackColor: widget.trackColor,
          trackWidth: widget.trackWidth,
        ),
        child: new Padding(
          //padding to wrap arpund child widget
          child: widget.child,
          padding: _insetsForPainter() + widget.innerPadding,
        ),
      ),
    );
  }
}

////////////////////////////////////////
///// Radial Progress Bar PAINTER ///////
////////////////////////////////////////
class RadialProgressBarPainter extends CustomPainter {
  final double trackWidth;

  final Paint trackPaint;
  final double progressWidth;

  final double progressPercentage;
  final Paint progressPaint;
  final double thumbSize;

  final double thumbPosition;
  final Paint thumbPaint;

  RadialProgressBarPainter(
      {@required this.trackWidth,
      @required trackColor,
      @required this.progressWidth,
      @required progressColor,
      @required this.progressPercentage,
      @required this.thumbSize,
      @required thumbColor,
      @required this.thumbPosition})
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
    //the thickest width to account for around the seekbar container, th eamount of space between the bounds of the container and the seek bar
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    // New size to account for the outerThinkness
    Size constrainedSize = new Size(
      size.width - outerThickness,
      size.height - outerThickness,
    );

    //this is the center point of the rectangular bounds we are cofined to when painting this seekbar
    final center = new Offset(size.width / 2, size.height / 2);
    //radius of the circle we are painting. must be min value of whatever we are using
    //added constrained height to accomadate for outerThickness
    final radius = min(constrainedSize.height, constrainedSize.width) / 2;

    ////paint the track//
    /////
    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    ////paint progress/seek bar //
    /////
    final progressAngle =
        2 * pi * progressPercentage; // math for progress angle
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ), // bounds // bounds are a square around the centre
      -pi / 2, //top of the circle ,starting point
      progressAngle, //sweep angle for progress indicator
      false,
      progressPaint,
    );
    //// Paint thumb ///
    /////
    ////Finding  thumb position using angles around the circle
    final thumbAngle =
        2 * pi * thumbPosition - (pi / 2); //absolute angle of thumb position
    final thumbX = cos(thumbAngle) * radius; //x coordinate of thumb
    final thumbY = sin(thumbAngle) * radius; //y coordinate of thumb
    final thumbCanter = new Offset(thumbX, thumbY) +
        center; //Thumb center is center of thumb which is offset from actual circle center of the clip art
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
    demoPlaylist.songs[1].albumArtUrl,
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
