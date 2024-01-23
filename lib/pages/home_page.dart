import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musick_app/models/songs_provider.dart';
import 'package:musick_app/pages/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic songProvider;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    // Load songs when the widget is initialized
    songProvider = Provider.of<SongProvider>(context, listen: false);
    songProvider.loadSongs();
  }

  void goToSong(int songIndex) {
    songProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("S O N G S"),
      ),
      drawer: const MyDrawer(),
      body: Consumer<SongProvider>(
        builder: (context, songProvider, child) {
          if (songProvider.songs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: songProvider.songs.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(songProvider.songs[index].title),
                  subtitle: Text(songProvider.songs[index].displayName),
                  trailing: const Icon(Icons.more_vert),
                  leading: QueryArtworkWidget(
                    id: songProvider.songs[index].id,
                    type: ArtworkType.AUDIO,
                  ),
                  onTap: () => goToSong(index));
            },
          );
        },
      ),
    );
  }

  // Consumer<MusicProvider>(
  //   builder: (context, value, child) {
  //     final List<Song> songs = value.songs;
  //     return ListView.builder(
  //       itemCount: value.songs.length,
  //       itemBuilder: (context, index) {
  //         final Song song = songs[index];
  //         return ListTile(
  //           title: Text(song.songName),
  //           subtitle: Text(song.artistName),
  //           leading: Image.asset(song.albumArtImagePath),
  //           onTap: () => goToSong(index),
  //         );
  //       },
  //     );
  //   },
  // ),

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
    }
  }
}
