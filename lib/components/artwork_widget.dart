import 'package:flutter/material.dart';
import 'package:musick_app/models/songs_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtworkWidget extends StatelessWidget {
  final int songId;

  const ArtworkWidget({Key? key, required this.songId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _ArtworkWidgetContent(); // Use const constructor here
  }
}

class _ArtworkWidgetContent extends StatelessWidget {
  const _ArtworkWidgetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context.read<SongProvider>();
    final currentSong = value.songs[value.currentSongIndex ?? 0];

    return QueryArtworkWidget(
      id: currentSong.id,
      type: ArtworkType.AUDIO,
      artworkQuality: FilterQuality.none,
      artworkBorder: BorderRadius.zero,
      artworkFit: BoxFit.cover,
      artworkWidth: MediaQuery.of(context).size.width,
      artworkHeight: MediaQuery.of(context).size.width,
    );
  }
}
