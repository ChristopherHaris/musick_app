import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongProvider with ChangeNotifier {
  List<SongModel> _songs = [];
  int? _currentSongIndex = 0;

  List<SongModel> get songs => _songs;
  int? get currentSongIndex => _currentSongIndex;

  set songs(List<SongModel> songs) {
    _songs = songs;
    notifyListeners();
  }

  Future<void> loadSongs() async {
    OnAudioQuery audioQuery = OnAudioQuery();
    List<SongModel> songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    _songs = songs;
    notifyListeners();
  }

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    notifyListeners();
  }
}
