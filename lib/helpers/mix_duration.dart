import 'package:audio_player/models/episode.dart';

Duration mixDuration(List<Episode> episodes) {
  Duration duration = Duration.zero;
  for (var episode in episodes) {
    duration += episode.duration ?? Duration.zero;
  }

  return duration;
}
