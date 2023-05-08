import 'package:audio_player/components/ap_scaffold.dart';
import 'package:audio_player/helpers/mix_duration.dart';
import 'package:audio_player/models/episode.dart';
import 'package:audio_player/models/player_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  final List<Episode> episodes;
  final PlayerModel playerModel;
  const PlayerScreen({super.key, required this.episodes, required this.playerModel});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PlayerState playerState = PlayerState.stopped;

  void _setPlayers() async {
    List<AudioPlayer> allPlayers = [];
    for (var episode in widget.episodes) {
      AudioPlayer newPlayer = AudioPlayer();
      await newPlayer.setSourceUrl(episode.file);
      allPlayers.add(newPlayer);
    }

    widget.playerModel.updateTotalDuration(mixDuration(widget.episodes));
    widget.playerModel.updatePlayers(allPlayers);
    _play(0);
  }

  void _play(int playerIndex) async {
    await widget.playerModel.resume(widget.playerModel, playerIndex: playerIndex);
    widget.playerModel.updateCurrentPlayerIndex(playerIndex);
    _listenToPlayerChanges(playerIndex);
  }

  void _listenToPlayerChanges(int playerIndex) {
    AudioPlayer player = widget.playerModel.allPlayers[playerIndex];

    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed && (playerIndex + 1) < widget.playerModel.allPlayers.length) {
        _play(playerIndex + 1);
      } else if (state == PlayerState.completed && (playerIndex + 1) == widget.playerModel.allPlayers.length) {
        widget.playerModel.updateCurrentPlayerIndex(0);
        widget.playerModel.updateIsPlaying(false);
        _pause();
      }
    });

    Duration previousEpisodesDuration = Duration.zero;

    if (widget.playerModel.currentPlayerIndex > 0) {
      for (int i = 0; i < widget.playerModel.currentPlayerIndex; i++) {
        previousEpisodesDuration += widget.episodes[i].duration ?? Duration.zero;
      }
    }

    player.onPositionChanged.listen((Duration currentPosition) {
      widget.playerModel.updateCurrentPosition(previousEpisodesDuration + currentPosition);
      if (mounted) setState(() {});
    });
  }

  void _resume() {
    widget.playerModel.resume(widget.playerModel);
  }

  void _pause() {
    widget.playerModel.allPlayers[widget.playerModel.currentPlayerIndex].pause();

    if (mounted) {
      setState(() {
        widget.playerModel.updateIsPlaying(false);
      });
    }
  }

  @override
  void initState() {
    if (widget.playerModel.allPlayers.isEmpty) {
      _setPlayers();
    } else {
      _listenToPlayerChanges(widget.playerModel.currentPlayerIndex);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return APScaffold(
      context: context,
      playerModel: widget.playerModel,
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
              Text('Currently playing path: ${widget.playerModel.isPlaying ? widget.playerModel.currentPlayerIndex : "-"}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IgnorePointer(
                    ignoring: widget.playerModel.currentPlayerIndex == 0,
                    child: Opacity(
                      opacity: widget.playerModel.currentPlayerIndex == 0 ? 0.5 : 1,
                      child: IconButton(
                        iconSize: 48.0,
                        onPressed: () {
                          _pause();
                          _play(widget.playerModel.currentPlayerIndex - 1);
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
                      if (!widget.playerModel.isPlaying) {
                        if (widget.playerModel.allPlayers.isNotEmpty) {
                          _resume();
                        } else {
                          _play(0);
                        }
                      } else {
                        _pause();
                      }
                    },
                    icon: Icon(
                      widget.playerModel.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                  IgnorePointer(
                    ignoring: widget.playerModel.currentPlayerIndex == widget.playerModel.allPlayers.length - 1,
                    child: Opacity(
                      opacity: widget.playerModel.currentPlayerIndex == widget.playerModel.allPlayers.length - 1 ? 0.5 : 1,
                      child: IconButton(
                        iconSize: 48.0,
                        onPressed: () {
                          _pause();
                          _play(widget.playerModel.currentPlayerIndex + 1);
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
