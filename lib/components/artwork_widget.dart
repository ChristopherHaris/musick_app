import 'package:flutter/material.dart';
import 'package:musick_app/models/songs_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtworkWidget extends StatelessWidget {
  final int songId;

  const ArtworkWidget({Key? key, required this.songId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: QueryArtworkWidget(
        key: ValueKey<int>(songId),
        id: songId,
        type: ArtworkType.AUDIO,
        artworkQuality: FilterQuality.none,
        artworkBorder: BorderRadius.zero,
        artworkFit: BoxFit.cover,
        artworkWidth: MediaQuery.of(context).size.width,
        artworkHeight: MediaQuery.of(context).size.width,
      ),
    );
  }
}
