import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../models/songs_provider.dart';

class ArtworkWidget extends StatefulWidget {
  final int songId;

  const ArtworkWidget({Key? key, required this.songId}) : super(key: key);

  @override
  _ArtworkWidgetState createState() => _ArtworkWidgetState();
}

class _ArtworkWidgetState extends State<ArtworkWidget> {
  @override
  Widget build(BuildContext context) {
    return const _ArtworkWidgetContent();
  }
}

class _ArtworkWidgetContent extends StatelessWidget {
  const _ArtworkWidgetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context.read<SongProvider>();
    final currentSong = value.songs[value.currentSongIndex ?? 0];

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: QueryArtworkWidget(
        key: ValueKey<int>(currentSong.id),
        id: currentSong.id,
        type: ArtworkType.AUDIO,
        artworkQuality: FilterQuality.high,
        artworkBorder: BorderRadius.zero,
        artworkFit: BoxFit.cover,
        artworkWidth: MediaQuery.of(context).size.width,
        artworkHeight: MediaQuery.of(context).size.width,
      ),
    );
  }
}
