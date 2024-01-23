import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  int? _currentSongIndex = 0;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Future<void> loadSongs() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    try {
      List<SongModel> songs = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      _songs = songs;
      notifyListeners();
    } catch (e) {
      // Handle any errors that might occur during song loading
      print("Error loading songs: $e");
    }
  }

  SongProvider() {
    // listenToDuration();
  }

  void play() async {
    final String? contentUri = _songs[currentSongIndex!].uri;

    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(contentUri!)));
    await _audioPlayer.play();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _songs.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _songs.length - 1;
      }
    }
  }

  // void listenToDuration() {
  //   _audioPlayer.onDurationChanged.listen((newDuration) {
  //     _totalDuration = newDuration;
  //     notifyListeners();
  //   });

  //   _audioPlayer.onPositionChanged.listen((newPosition) {
  //     _currentDuration = newPosition;
  //     notifyListeners();
  //   });

  //   _audioPlayer.onPlayerComplete.listen((event) {});
  // }

  List<SongModel> get songs => _songs;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set songs(List<SongModel> songs) {
    _songs = songs;
    notifyListeners();
  }

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
