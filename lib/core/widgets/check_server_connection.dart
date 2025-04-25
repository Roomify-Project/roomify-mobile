
import 'package:rommify_app/core/widgets/signal_R_service.dart';

class CheckServerConnection {
  static Future<bool> checkServerConnection() async {
    if (!SignalRService.isConnected) {
      try {
        await SignalRService.initializeConnection();
        SignalRService.connection(channelName: 'ReceiveMessage');

      } catch (error) {
        return false;
      }
    }
    return true;
  }
}
