import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:sps/models/sps_updown.dart';
import 'package:sps/models/sps_usuario_class.dart';


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
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: ["spsSupplierPortal"],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "spsLogs",
        logsExportDirectoryName: "spsLogs/Exported",
        debugFileOperations: false,
        isDebuggable: false);
  }

  static void logDispositivo() async {
    //Obter informações do dispositivo
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> _deviceData = <String, dynamic>{};
    Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
      return <String, dynamic>{
        'version.securityPatch': build.version.securityPatch,
        'version.sdkInt': build.version.sdkInt,
        'version.release': build.version.release,
        'version.previewSdkInt': build.version.previewSdkInt,
        'version.incremental': build.version.incremental,
        'version.codename': build.version.codename,
        'version.baseOS': build.version.baseOS,
        'board': build.board,
        'bootloader': build.bootloader,
        'brand': build.brand,
        'device': build.device,
        'display': build.display,
        'fingerprint': build.fingerprint,
        'hardware': build.hardware,
        'host': build.host,
        'id': build.id,
        'manufacturer': build.manufacturer,
        'model': build.model,
        'product': build.product,
        'supported32BitAbis': build.supported32BitAbis,
        'supported64BitAbis': build.supported64BitAbis,
        'supportedAbis': build.supportedAbis,
        'tags': build.tags,
        'type': build.type,
        'isPhysicalDevice': build.isPhysicalDevice,
        'androidId': build.androidId,
        'systemFeatures': build.systemFeatures,
      };
    }

    Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
      return <String, dynamic>{
        'name': data.name,
        'systemName': data.systemName,
        'systemVersion': data.systemVersion,
        'model': data.model,
        'localizedModel': data.localizedModel,
        'identifierForVendor': data.identifierForVendor,
        'isPhysicalDevice': data.isPhysicalDevice,
        'utsname.sysname:': data.utsname.sysname,
        'utsname.nodename:': data.utsname.nodename,
        'utsname.release:': data.utsname.release,
        'utsname.version:': data.utsname.version,
        'utsname.machine:': data.utsname.machine,
      };
    }
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        usuarioAtual.tipo_dispositivo = "Android";
        usuarioAtual.versao_sistema_operacional = _deviceData['version.release'];
      } else if (Platform.isIOS) {
        _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        usuarioAtual.tipo_dispositivo = "IOS";
        usuarioAtual.versao_sistema_operacional = _deviceData['systemVersion'];
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    usuarioAtual.dados_dispositivo = _deviceData.toString();
    usuarioAtual.modelo_dispositivo = _deviceData['model'];

    spsLog.log(tipo: "INFO", msg: "Dados do dispositivo: " + usuarioAtual.dados_dispositivo);
    // spsLog.log(tipo: "INFO", msg: "Dados do usuario: codigo_usuario: " + usuarioAtual.codigo_usuario + ", nome_usuario: "+ usuarioAtual.nome_usuario + ", telefone_usuario: "+ usuarioAtual.telefone_usuario + ", email_usuario: "+ usuarioAtual.email_usuario + ", lingua_usuario: "+ usuarioAtual.lingua_usuario +  ", status_usuario: "+ usuarioAtual.status_usuario +  ", tipo: "+ usuarioAtual.tipo +  ", registro_usuario: "+ usuarioAtual.registro_usuario + ", mensagem: "+ usuarioAtual.mensagem + ", document_root_folder: "+ usuarioAtual.document_root_folder + ", status_sincronizacao: "+ usuarioAtual.status_sincronizacao.toString());
    //FIM - Obter informações do dispositivo
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
        logFileName: "spsSupplierPortal",
        overwrite: false,
        logMessage: "["+tipo+"]["+dataHoraAtual.toString()+"] "+msg+"\n", appendTimeStamp: false);
  }


  static void clearLog() {
    FlutterLogs.clearLogs();
  }

  static Future<int> uploadLogDiario() {
    DateTime now = new DateTime.now();
    String dataAtual = DateFormat('ddMMyyyy').format(now);
    Directory dir = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs');
    dir.list(recursive: false).forEach((f) async {
      String pasta = f.toString().replaceAll("'","").split("/").last;
      if(pasta.trim() != dataAtual.trim()){
        //Prepara dados para upload do arquivo.
        FormData formData = FormData.fromMap({
          "files": [ await MultipartFile.fromFile('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta+'/spsSupplierPortal.log',
              filename: 'spsSupplierPortal.log'),
          ],
          "codigo_usuario": usuarioAtual.codigo_usuario,
          "tipo_dispositivo": usuarioAtual.tipo_dispositivo,
          "modelo_dispositivo": usuarioAtual.modelo_dispositivo,
          "versao_sistema_operacional": usuarioAtual.versao_sistema_operacional,
          "data": pasta,
          "replace": "true",
        });
        spsUpDown objspsUpDown = spsUpDown();
        bool statusUpload = await objspsUpDown.uploadLog(formData);
        if (statusUpload == true) {
          spsLog.log(debug: 1, tipo: "INFO", msg: "Log foi enviado para o servidor. Apagando loglocal: "+pasta);
          final loglocal = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta);
          loglocal.deleteSync(recursive: true);
          spsLog.log(debug: 1, tipo: "INFO", msg: "loglocal: "+pasta+" foi apagado com sucesso!");
        } else {
          spsLog.log(debug: 1, tipo: "ERRO", msg: "Não foi possível enviar o Log para o servidor: " + pasta);
        }
      }
    });
  }

  static Future<int> uploadLogNow() {
    DateTime now = new DateTime.now();
    String dataAtual = DateFormat('ddMMyyyy').format(now);
    Directory dir = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs');
    dir.list(recursive: false).forEach((f) async {
      String pasta = f.toString().replaceAll("'","").split("/").last;
        //Prepara dados para upload do arquivo.
        FormData formData = FormData.fromMap({
          "files": [ await MultipartFile.fromFile('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta+'/spsSupplierPortal.log',
              filename: 'spsSupplierPortal.log'),
          ],
          "codigo_usuario": usuarioAtual.codigo_usuario,
          "tipo_dispositivo": usuarioAtual.tipo_dispositivo,
          "modelo_dispositivo": usuarioAtual.modelo_dispositivo,
          "versao_sistema_operacional": usuarioAtual.versao_sistema_operacional,
          "data": pasta,
          "replace": "true",
        });
        spsUpDown objspsUpDown = spsUpDown();
        bool statusUpload = await objspsUpDown.uploadLog(formData);
        if (statusUpload == true) {
          spsLog.log(debug: 1, tipo: "INFO", msg: "Log foi enviado para o servidor : "+pasta);
          if(pasta.trim() != dataAtual.trim()){
            final loglocal = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta);
            loglocal.deleteSync(recursive: true);
            spsLog.log(debug: 1, tipo: "INFO", msg: "loglocal: "+pasta+" foi apagado com sucesso!");
          }
        } else {
          spsLog.log(debug: 1, tipo: "ERRO", msg: "Não foi possível enviar o Log para o servidor: " + pasta);
        }
    });
  }

  static Future<int> uploadLogNowAndLogout() {
    DateTime now = new DateTime.now();
    String dataAtual = DateFormat('ddMMyyyy').format(now);
    Directory dir = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs');
    dir.list(recursive: false).forEach((f) async {
      String pasta = f.toString().replaceAll("'","").split("/").last;
      //Prepara dados para upload do arquivo.
      FormData formData = FormData.fromMap({
        "files": [ await MultipartFile.fromFile('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta+'/spsSupplierPortal.log',
            filename: 'spsSupplierPortal.log'),
        ],
        "codigo_usuario": usuarioAtual.codigo_usuario,
        "tipo_dispositivo": usuarioAtual.tipo_dispositivo,
        "modelo_dispositivo": usuarioAtual.modelo_dispositivo,
        "versao_sistema_operacional": usuarioAtual.versao_sistema_operacional,
        "data": pasta,
        "replace": "false",
      });
      spsUpDown objspsUpDown = spsUpDown();
      bool statusUpload = await objspsUpDown.uploadLog(formData);
      if (statusUpload == true) {
        spsLog.log(debug: 1, tipo: "INFO", msg: "Log foi enviado para o servidor : "+pasta);
      } else {
        spsLog.log(debug: 1, tipo: "ERRO", msg: "Não foi possível enviar o Log para o servidor: " + pasta);
      }
    });
  }


}
