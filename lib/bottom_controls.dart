import 'package:flutter/material.dart';
import 'package:music_player/theme.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      color: accentColor,
      child: Material(
        color: accentColor,
        shadowColor: Colors.black12,
        child: new Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
          //Column with controls
          child: new Column(
            children: <Widget>[
              
              new TrackInfo(),
              
              new Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: new Row(
                  children: <Widget>[

                    //EXpanded is just taking up space.
                    new Expanded(
                      child: new Container(),
                    ),


                    ////////////////////////////////
                    ///// Previous Song Button ////////
                    ////////////////////////////////
                    new PreviousButton(),

                    //Space
                    new Expanded(
                      child: new Container(),////////empty container
                    ),


                    ////////////////////////////////
                    ///// PLAY SONG BUTTON ////////
                    ////////////////////////////////
                    new PlayButton(),
                    //Space
                    new Expanded(
                      child: new Container(),////////empty container
                    ),

                    ////////////////////////
                    //////NEXT SONG BUTTON////////
                    ////////////////////////
                    new NextButton(),
                    new Expanded(
                      child: new Container(),
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      )
    );
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RichText(
      text: new TextSpan(
        text: '',
        children: [

          //Song Title
          new TextSpan(
            text: 'Song Title\n',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0,
              height: 1.5,
            ),
          ),

          //Artist Name
          new TextSpan(
            text: 'Artist Name',
            style: new TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12.0,
              letterSpacing: 3.0,
              height: 1.5,
            )
          )
        ]
      )

    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.lightGreen,
      icon: new Icon(
        Icons.skip_previous,
        color: Colors.white,  
        size: 35.0,            
      ),
      onPressed: (){
        //TODO: ////////
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
      shape: new CircleBorder(),
      fillColor: Colors.white,
      splashColor: accentColor,
      highlightColor: Colors.lightGreen.withOpacity(0.5),
      elevation: 10.0,
      highlightElevation: 5.0,
      onPressed: () {
        //TODO: //////
      },
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Icon(
          Icons.play_arrow,
          color: darkAccentColor,
          size: 35.0,
        )
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.lightGreen,
      icon: new Icon(
        Icons.skip_next,
        color: Colors.white,   
        size: 35.0,           
      ),
      onPressed: (){
        //TODO: ////////
      },
    );
  }
}

