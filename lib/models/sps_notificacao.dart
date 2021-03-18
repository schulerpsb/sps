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
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flip.initialize(initializationSettings);
    return flip;
  }

  static Future<int> notificarProgresso(int id, int maxProgress, int progresso, String title1, String title2, FlutterLocalNotificationsPlugin flip) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('progress channel', 'progress channel',
        'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progresso,
        playSound: false,
        timeoutAfter: 1000,
        enableVibration: false,
        groupKey: 'com.android.schuler.sps');

    //Detalhes de especificções para IOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: false);

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flip.show(id, title1, title2, platformChannelSpecifics, payload: 'item x');
    return 1;
  }

  static Future<int> notificarInicioProgressoIndeterminado(int id, String title1, String title2, FlutterLocalNotificationsPlugin flip) async {

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'indeterminate progress channel',
        'indeterminate progress channel',
        'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true,
        playSound: false,
        enableVibration: false,
        groupKey: 'com.android.schuler.sps'
    );

    //Detalhes de especificções para IOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: false);

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flip.show(id, title1, title2, platformChannelSpecifics, payload: 'item x');

    return 1;
  }

  static Future<int> notificarProgressosilencioso(int id, int maxProgress, int progresso, String title1, String title2, FlutterLocalNotificationsPlugin flip) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('silent channel id', 'silent channel name',
        'silent channel description',
        playSound: false,
        styleInformation: DefaultStyleInformation(true, true));

    //Detalhes de especificções para IOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: false);

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flip.show(id, title1, title2, platformChannelSpecifics, payload: 'item x');
    return 1;
  }

  static Future<int> notificarErro(int id, String title1, String title2, FlutterLocalNotificationsPlugin flip) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('progress channel', 'progress channel',
        'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        playSound: false,
        groupKey: 'com.android.schuler.sps');

    //Detalhes de especificções para IOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flip.show(id, title1, title2, platformChannelSpecifics, payload: 'item x');
    return 1;
  }

  static Future<int> cancelarNotificacao(int id, FlutterLocalNotificationsPlugin flip) async {
    await flip.cancel(id);
    return 1;
  }

}
