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
            Icons.arrow_back_ios ,
          ),
          color: Colors.deepPurpleAccent,
          onPressed: () {

          },
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

                child: ClipOval(
                  clipper: new CircleClipper(),
                                  child: new Image.network(
                    demoPlaylist.songs[0].albumArtUrl,
                    fit: BoxFit.cover,
                  ),
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


 