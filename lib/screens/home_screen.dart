import 'package:audio_player/components/ap_scaffold.dart';
import 'package:audio_player/helpers/duration_to_string.dart';
import 'package:audio_player/models/episode.dart';
import 'package:audio_player/models/player_model.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //* currently, the audioplayers package does not support the following feature:
  // await player.getDuration();
  //* that's why the duration of all paths is hardcoded
  List<Episode> allEpisodes = [
    Episode(title: 'Path 1.', file: 'https://samplelib.com/lib/preview/mp3/sample-3s.mp3', duration: const Duration(seconds: 3)),
    Episode(title: 'Path 2.', file: 'https://samplelib.com/lib/preview/mp3/sample-9s.mp3', duration: const Duration(seconds: 9)),
    Episode(title: 'Path 3.', file: 'https://samplelib.com/lib/preview/mp3/sample-12s.mp3', duration: const Duration(seconds: 12)),
    Episode(title: 'Path 4.', file: 'https://samplelib.com/lib/preview/mp3/sample-15s.mp3', duration: const Duration(seconds: 19)),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerModel = Provider.of<PlayerModel>(context);
    return APScaffold(
      context: context,
      playerModel: playerModel,
      title: 'Home screen',
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        episodes: allEpisodes,
                        playerModel: playerModel,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Some mixed sound paths'),
                      Icon(playerModel.isPlaying ? Icons.pause : Icons.play_arrow),
                    ],
                  ),
                ),
              ),
              if (playerModel.allPlayers.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          episodes: allEpisodes,
                          playerModel: playerModel,
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
                              Text('${durationToString(playerModel.currentPosition)} / ${durationToString(playerModel.totalDuration)}'),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              playerModel.isPlaying ? playerModel.pause(playerModel) : playerModel.resume(playerModel);
                            },
                            icon: Icon(playerModel.isPlaying ? Icons.pause : Icons.play_arrow),
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
