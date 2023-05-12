import 'package:audio_player/components/ap_scaffold.dart';
import 'package:audio_player/helpers/duration_to_string.dart';
import 'package:audio_player/models/episode.dart';
import 'package:audio_player/providers/player_provider.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    //* currently, the audioplayers package does not support the following feature:
    // await player.getDuration();
    //* that's why the duration of all paths is hardcoded
    final List<Episode> allEpisodes = [
      Episode(title: 'Path 1.', file: 'https://samplelib.com/lib/preview/mp3/sample-3s.mp3', duration: const Duration(seconds: 3)),
      Episode(title: 'Path 2.', file: 'https://samplelib.com/lib/preview/mp3/sample-9s.mp3', duration: const Duration(seconds: 9)),
      Episode(title: 'Path 3.', file: 'https://samplelib.com/lib/preview/mp3/sample-12s.mp3', duration: const Duration(seconds: 12)),
      Episode(title: 'Path 4.', file: 'https://samplelib.com/lib/preview/mp3/sample-15s.mp3', duration: const Duration(seconds: 19)),
    ];
    final provider = ref.read(playerProvider.notifier);
    final state = ref.watch(playerProvider);

    return APScaffold(
      context: context,
      title: 'Home screen',
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Opacity(
                  opacity: _isLoading ? 0.5 : 1,
                  child: ElevatedButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () async {
                      if (_isLoading) return;
                      setState(() {
                        _isLoading = true;
                      });
                      if (!state.isPlaying) await provider.initialize(allEpisodes);
                      setState(() {
                        _isLoading = false;
                      });
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              episodes: allEpisodes,
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Some mixed sound paths',
                          ),
                          if (_isLoading)
                            const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.allAudioPlayers.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          episodes: allEpisodes,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Some mixed sound paths'),
                              Text('${durationToString(state.currentPostion)} / ${durationToString(state.totalDuration)}'),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              state.isPlaying ? provider.pause() : provider.play();
                            },
                            icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
