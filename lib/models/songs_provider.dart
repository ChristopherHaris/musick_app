import 'package:flutter/material.dart';
import 'song.dart';

class MusicProvider with ChangeNotifier {
  final List<Song> _songs = [
    Song(
      songName: "Alley",
      artistName: "Far Cry",
      albumArtImagePath: "assets/images/album_1.jpg",
      audioPath: "audio/alley.mp3",
    ),
    Song(
      songName: "Alley2",
      artistName: "Far Cry2",
      albumArtImagePath: "assets/images/album_1.jpg",
      audioPath: "audio/alley.mp3",
    ),
  ];

  int? _currentSongIndex;

  List<Song> get songs => _songs;
  int? get currentSongIndex => _currentSongIndex;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    notifyListeners();
  }
}
