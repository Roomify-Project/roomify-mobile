import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

Future<void> playSound(String path) async {
  await player.play(AssetSource(path));
}
