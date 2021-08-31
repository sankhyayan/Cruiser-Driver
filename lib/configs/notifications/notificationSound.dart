import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cruiser_driver/main.dart';
///notification sound player
class NotificationSound {
  static Future<void> notificationSound() async {
    await assetsAudioPlayer.open(
      Audio("assets/sounds/alert.mp3"),
      autoStart: true,
      playInBackground: PlayInBackground.enabled,
    );
    await assetsAudioPlayer.play();
  }
}
