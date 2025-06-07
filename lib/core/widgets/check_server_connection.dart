
import 'package:rommify_app/core/widgets/signal_R_service.dart';
import 'package:rommify_app/core/widgets/signal_r_notification.dart';

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
class CheckServerNotificationConnection {
  static Future<bool> checkServerNotificationConnection() async {
    if (!NotificationSignalRService.isConnected) {
      try {
        await NotificationSignalRService.initializeConnection();
        // NotificationSignalRService.startConnection();

      } catch (error) {
        return false;
      }
    }
    return true;
  }
}


