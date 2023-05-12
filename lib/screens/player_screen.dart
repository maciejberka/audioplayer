import 'package:audio_player/components/ap_scaffold.dart';
import 'package:audio_player/models/episode.dart';
import 'package:audio_player/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final List<Episode> episodes;
  const PlayerScreen({super.key, required this.episodes});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(playerProvider.notifier);
    final state = ref.watch(playerProvider);
    return APScaffold(
      context: context,
      title: 'Player screen',
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Text('Currently playing: ${state.isPlaying ? state.allEpisodes[state.currentAudioPlayerIndex].title : "-"}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IgnorePointer(
                    ignoring: state.currentAudioPlayerIndex == 0,
                    child: Opacity(
                      opacity: state.currentAudioPlayerIndex == 0 ? 0.5 : 1,
                      child: IconButton(
                        iconSize: 48.0,
                        onPressed: () {
                          provider.playPrevious();
                        },
                        icon: const Icon(
                          Icons.keyboard_double_arrow_left_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 48.0,
                    onPressed: () {
                      if (!state.isPlaying) {
                        provider.play();
                      } else {
                        provider.pause();
                      }
                    },
                    icon: Icon(
                      state.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                  IgnorePointer(
                    ignoring: state.currentAudioPlayerIndex == state.allAudioPlayers.length - 1,
                    child: Opacity(
                      opacity: state.currentAudioPlayerIndex == state.allAudioPlayers.length - 1 ? 0.5 : 1,
                      child: IconButton(
                        iconSize: 48.0,
                        onPressed: () {
                          provider.playNext();
                        },
                        icon: const Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
