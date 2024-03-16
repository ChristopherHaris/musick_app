import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musick_app/components/artwork_widget.dart';
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const SongPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text("S O N G S"),
          ),
          drawer: const MyDrawer(),
          body: Selector<SongProvider, List<SongModel>>(
            selector: (context, songProvider) => songProvider.songs,
            builder: (context, songs, child) {
              if (songProvider.songs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: songProvider.songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(songs[index].title),
                      subtitle: Text(songs[index].displayName),
                      trailing: const Icon(Icons.more_vert),
                      leading: QueryArtworkWidget(
                        id: songs[index].id,
                        type: ArtworkType.AUDIO,
                      ),
                      onTap: () => goToSong(index));
                },
              );
            },
          ),
        ),
        Consumer<SongProvider>(
          builder: (context, value, child) {
            final songs = value.songs;
            final currentSongIndex = value.currentSongIndex;
            if (currentSongIndex != null && currentSongIndex < songs.length) {
              final currentSong = songs[currentSongIndex];
              return Stack(
                alignment: Alignment.centerRight,
                children: [
                  GestureDetector(
                    onVerticalDragStart: (detail) => goToSong(currentSongIndex),
                    onTap: () => goToSong(currentSongIndex),
                    child: Container(
                      height: 65,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: ArtworkWidget(
                                  songId: currentSong.id,
                                  key: ValueKey<int>(currentSong.id),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  currentSong.title,
                                  style: TextStyle(
                                    overflow: TextOverflow.fade,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  ".",
                                  style: TextStyle(
                                    overflow: TextOverflow.fade,
                                    height: 0.1,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 320,
                                  child: Text(
                                    currentSong.artist ?? "",
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Consumer<SongProvider>(
                          builder: (context, songProvider, _) {
                            Duration currentDuration =
                                songProvider.currentDuration;
                            Duration totalDuration = songProvider.totalDuration;
                            double progress = totalDuration.inSeconds > 0
                                ? currentDuration.inSeconds /
                                    totalDuration.inSeconds
                                : 0.0; // Set progress to zero if currentDuration or totalDuration is null or if totalDuration is zero
                            return CircularProgressIndicator.adaptive(
                              value: progress,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            );
                            // Data is still loading
                          },
                        ),
                        IconButton(
                          icon: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 20,
                          onPressed: () {
                            value.pauseOrResume();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
    }
  }
}
