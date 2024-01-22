import 'package:flutter/material.dart';
import 'package:musick_app/models/song.dart';
import 'package:musick_app/models/songs_provider.dart';
import 'package:musick_app/pages/song_page.dart';
import 'package:provider/provider.dart';
import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic musicProvider;

  @override
  void initState() {
    super.initState();
    // Load songs when the widget is initialized
    musicProvider = Provider.of<MusicProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    musicProvider.currentSongIndex = songIndex;

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
      appBar: AppBar(title: const Text("S O N G S")),
      drawer: const MyDrawer(),
      body: Consumer<MusicProvider>(
        builder: (context, value, child) {
          final List<Song> songs = value.songs;
          return ListView.builder(
            itemCount: value.songs.length,
            itemBuilder: (context, index) {
              final Song song = songs[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}
