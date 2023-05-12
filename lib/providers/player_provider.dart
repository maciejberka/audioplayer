import 'package:audio_player/helpers/mix_duration.dart';
import 'package:audio_player/models/episode.dart';
import 'package:audio_player/models/player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier() : super(Player());

  void _updateState({
    Duration? currentPosition,
    List<AudioPlayer>? allAudioPlayers,
    bool? isPlaying,
    int? currentAudioPlayerIndex,
    List<Episode>? allEpisodes,
    Duration? totalDuration,
  }) {
    state = Player(
        currentPostion: currentPosition ?? state.currentPostion,
        allAudioPlayers: allAudioPlayers ?? state.allAudioPlayers,
        isPlaying: isPlaying ?? state.isPlaying,
        currentAudioPlayerIndex: currentAudioPlayerIndex ?? state.currentAudioPlayerIndex,
        allEpisodes: allEpisodes ?? state.allEpisodes,
        totalDuration: totalDuration ?? state.totalDuration);
  }

  Future<void> initialize(List<Episode> episodes) async {
    setAllEpisodes(episodes);
    await setAudioPlayers(episodes);
    setTotalDuration();
    await play();
    for (int i = 0; i < state.allAudioPlayers.length; i++) {
      _listenToAudioPlayerStateChanges(i);
      _listenToAudioPlayerPositionChanges(i);
    }
  }

  void setAllEpisodes(List<Episode> episodes) {
    _updateState(allEpisodes: episodes);
  }

  Future<void> setAudioPlayers(List<Episode> episodes) async {
    List<AudioPlayer> allAudioPlayers = [];
    for (var episode in episodes) {
      AudioPlayer newPlayer = AudioPlayer();
      await newPlayer.setSourceUrl(episode.file);
      allAudioPlayers.add(newPlayer);
    }
    _updateState(allAudioPlayers: allAudioPlayers);
  }

  void setCurrentAudioPlayerIndex(int currentAudioPlayerIndex) {
    _updateState(currentAudioPlayerIndex: currentAudioPlayerIndex);
  }

  Future<void> play() async {
    await state.allAudioPlayers[state.currentAudioPlayerIndex].resume();
    _updateState(isPlaying: true);
  }

  Future<void> pause() async {
    await state.allAudioPlayers[state.currentAudioPlayerIndex].pause();
    _updateState(isPlaying: false);
  }

  void setTotalDuration() {
    _updateState(totalDuration: mixDuration(state.allEpisodes));
  }

  Future<void> playNext() async {
    if (state.allAudioPlayers.length > state.currentAudioPlayerIndex + 1) {
      await pause();
      _updateState(currentAudioPlayerIndex: state.currentAudioPlayerIndex + 1);
      await play();
    } else {
      await _stop();
    }
  }

  Future<void> _stop() async {
    await pause();
    setCurrentAudioPlayerIndex(0);
    _updateState(currentPosition: const Duration(seconds: 0));
  }

  void playPrevious() async {
    if (state.currentAudioPlayerIndex > 0) {
      await pause();
      _updateState(currentAudioPlayerIndex: state.currentAudioPlayerIndex - 1);
      await play();
    }
  }

  void _listenToAudioPlayerStateChanges(int audioPlayerIndex) async {
    AudioPlayer audioPlayer = state.allAudioPlayers[audioPlayerIndex];
    audioPlayer.onPlayerStateChanged.listen((PlayerState audioPlayerState) async {
      if (audioPlayerState == PlayerState.completed) {
        await playNext();
      }
    });
  }

  void _listenToAudioPlayerPositionChanges(int audioPlayerIndex) {
    state.allAudioPlayers[audioPlayerIndex].onPositionChanged.listen((Duration currentPosition) {
      int previousEpisodesDurationInSeconds = 0;
      for (int i = 0; i < audioPlayerIndex; i++) {
        previousEpisodesDurationInSeconds = previousEpisodesDurationInSeconds + state.allEpisodes[i].duration!.inSeconds;
      }
      Duration currentPositionDuration = Duration(seconds: previousEpisodesDurationInSeconds + currentPosition.inSeconds);

      _updateState(currentPosition: currentPositionDuration);
    });
  }
}

final playerProvider = StateNotifierProvider.autoDispose<PlayerNotifier, Player>((ref) => PlayerNotifier());
