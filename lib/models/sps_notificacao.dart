import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class spsNotificacao {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static FlutterLocalNotificationsPlugin iniciarNotificacaoGrupo() {
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_stat_icone');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flip.initialize(initializationSettings);
    return flip;
  }

  static Future<int> notificarProgresso(int id, int maxProgress, int progresso, String title1, String title2, FlutterLocalNotificationsPlugin flip) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('progress channel', 'progress channel',
        'progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progresso,
        playSound: false,
        timeoutAfter: 3000,
        groupKey: 'com.android.example.sps');

    //Detalhes de especificções para IOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(androidPlatformChannelSpecifics,iOSPlatformChannelSpecifics);
    await flip.show(id, title1, title2, platformChannelSpecifics, payload: 'item x');
    return 1;
  }

  static Future<int> notificarErro(int id, String title1, String title2, FlutterLocalNotificationsPlugin flip) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('progress channel', 'progress channel',
        'progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true,
        playSound: false,
        groupKey: 'com.android.example.sps');

    //Detalhes de especificções para IOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(androidPlatformChannelSpecifics,iOSPlatformChannelSpecifics);
    await flip.show(id, title1, title2, platformChannelSpecifics, payload: 'item x');
    return 1;
  }


}
