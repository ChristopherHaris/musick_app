import 'package:flutter/material.dart';
import 'package:musick_app/components/artwork_widget.dart';
import 'package:musick_app/components/neu_box.dart';
import 'package:musick_app/models/songs_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, value, child) {
        final songs = value.songs;
        final currentSong = songs[value.currentSongIndex ?? 0];
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, bottom: 25, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text("S O N G"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  NeuBox(
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ArtworkWidget(
                              songId: currentSong.id,
                              key: ValueKey<int>(currentSong.id),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      currentSong.artist ?? "NN",
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Consumer<SongProvider>(
                    builder: (context, songProvider, _) {
                      Duration currentDuration = songProvider.currentDuration;
                      Duration totalDuration = songProvider.totalDuration;

                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatTime(currentDuration)),
                                IconButton(
                                    color: songProvider.isRandom
                                        ? Colors.blue
                                        : Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                    isSelected: songProvider.isRandom,
                                    onPressed: () {
                                      songProvider.randomize();
                                    },
                                    icon: const Icon(Icons.shuffle)),
                                IconButton(
                                    color: songProvider.isRepeat
                                        ? Colors.blue
                                        : Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                    onPressed: () {
                                      songProvider.repeat();
                                    },
                                    icon: const Icon(Icons.repeat)),
                                Text(formatTime(totalDuration)),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 0),
                            ),
                            child: Slider(
                              min: 0,
                              max: totalDuration.inSeconds.toDouble(),
                              value: currentDuration.inSeconds.toDouble(),
                              activeColor: Colors.blue,
                              onChanged: (double double) {},
                              onChangeEnd: (double double) {
                                songProvider
                                    .seek(Duration(seconds: double.toInt()));
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
