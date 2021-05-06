import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

class spsLog {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static void setUpLog() async {
    await FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_SIMPLE,
        directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
        logTypesEnabled: ["SPSsupplierPortal"],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        debugFileOperations: false,
        isDebuggable: false);

  }

  static void log({String tipo, String msg, int debug = 0}) {
    DateTime now = new DateTime.now();
    DateTime dataHoraAtual = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    if(debug == 1){
      tipo = "DEBUG SPS";
      debugPrint("["+tipo+"] "+msg);
    }else{
      if(tipo == "" || tipo == null){
        tipo = "INFO";
      }
    }
    FlutterLogs.logToFile(
        logFileName: "SPSsupplierPortal",
        overwrite: false,
        logMessage: "["+tipo+"]["+dataHoraAtual.toString()+"] "+msg+"\n", appendTimeStamp: false);
  }

  static void clearLog() {
    FlutterLogs.clearLogs();
  }

}
