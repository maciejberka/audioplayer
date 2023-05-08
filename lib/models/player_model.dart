import 'package:audio_player/models/episode.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class PlayerModel extends ChangeNotifier {
  Duration _currentPosition = const Duration(seconds: 0);
  Duration get currentPosition => _currentPosition;

  void updateCurrentPosition(Duration duration) {
    _currentPosition = duration;
    notifyListeners();
  }

  List<AudioPlayer> _allPlayers = const [];
  List<AudioPlayer> get allPlayers => _allPlayers;

  void updatePlayers(List<AudioPlayer> players) {
    _allPlayers = players;
    notifyListeners();
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void updateIsPlaying(bool playing) {
    _isPlaying = playing;
    notifyListeners();
  }

  int _currentPlayerIndex = 0;
  int get currentPlayerIndex => _currentPlayerIndex;

  void updateCurrentPlayerIndex(int index) {
    _currentPlayerIndex = index;
    notifyListeners();
  }

  List<Episode> _episodes = [];
  List<Episode> get episodes => _episodes;

  void updateEpisodes(List<Episode> listOfEpisodes) {
    _episodes = listOfEpisodes;
    notifyListeners();
  }

  Duration _totalDuration = Duration.zero;
  Duration get totalDuration => _totalDuration;

  void updateTotalDuration(Duration duration) {
    _totalDuration = duration;
    notifyListeners();
  }

  Future<void> resume(PlayerModel playerModel, {int? playerIndex}) async {
    playerModel.allPlayers[playerIndex ?? playerModel.currentPlayerIndex].resume();
    playerModel.updateIsPlaying(true);
  }

  Future<void> pause(PlayerModel playerModel) async {
    playerModel.allPlayers[playerModel.currentPlayerIndex].pause();
    playerModel.updateIsPlaying(false);
  }
}
