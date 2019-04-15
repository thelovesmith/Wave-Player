import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/songs.dart';
import 'package:music_player/theme.dart';

class BottomControls extends StatelessWidget {
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
                          child: new Container(), ////////empty container
                        ),

                        ////////////////////////////////
                        ///// PLAY SONG BUTTON ////////
                        ////////////////////////////////
                        new PlayPauseButton(),
                        //Space
                        new Expanded(
                          child: new Container(), ////////empty container
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
              )),
        ));
  }
}

class TrackInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder:
          (BuildContext context, Playlist playlist, Widget child) {
            final songTitle = demoPlaylist.songs[playlist.activeIndex].songTitle;
            final artistName = demoPlaylist.songs[playlist.activeIndex].artist;
        return new RichText(
          textAlign: TextAlign.center,
            text: new TextSpan(text: '', children: [
          //Song Title
          new TextSpan(
            text: '${songTitle.toUpperCase()}\n',
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
              text: '${artistName.toUpperCase()}',
              style: new TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 12.0,
                letterSpacing: 3.0,
                height: 1.5,
              ))
        ]));
      },
    );
  }
}

class PreviousButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return new IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.lightGreen,
          icon: new Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.previous,
        );
      },
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      //looks for audio widget and lets you control the state of the audio wigdet
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon;
        Function onPressed;
        Color buttonColor = lightAccentColor;
        //theses if statements changes play/pause button based on state of audio player
        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttonColor = Colors.white;
        }

        return new RawMaterialButton(
          shape: new CircleBorder(),
          fillColor: buttonColor,
          splashColor: accentColor,
          highlightColor: Colors.lightGreen.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Icon(
                icon,
                color: darkAccentColor,
                size: 35.0,
              )),
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(playlistBuilder:
        (BuildContext context, Playlist playlist, Widget child) {
      return new IconButton(
        splashColor: lightAccentColor,
        highlightColor: Colors.lightGreen,
        icon: new Icon(
          Icons.skip_next,
          color: Colors.white,
          size: 35.0,
        ),
        onPressed: playlist.next,
      );
    });
  }
}
