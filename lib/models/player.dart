import 'package:audio_player/models/episode.dart';
import 'package:audioplayers/audioplayers.dart';

class Player {
  Player({
    this.currentPostion = Duration.zero,
    this.allAudioPlayers = const [],
    this.isPlaying = false,
    this.currentAudioPlayerIndex = 0,
    this.allEpisodes = const [],
    this.totalDuration = Duration.zero,
  });

  late Duration currentPostion;
  late List<AudioPlayer> allAudioPlayers;
  late bool isPlaying;
  late int currentAudioPlayerIndex;
  late List<Episode> allEpisodes;
  late Duration totalDuration;
}
