import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:path_provider/path_provider.dart';
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

    if (Platform.isIOS) {
      DateTime now = new DateTime.now();
      String nomelog = DateFormat('ddMMyyyy').format(now);
      FlutterLogs.logToFile(
          logFileName: nomelog,
          overwrite: false,
          logMessage: "start file log", appendTimeStamp: false);
    }
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

    if (Platform.isAndroid) {
      FlutterLogs.logToFile(
          logFileName: "spsSupplierPortal",
          overwrite: false,
          logMessage: "["+tipo+"]["+dataHoraAtual.toString()+"] "+msg+"\n", appendTimeStamp: false);
    } else if (Platform.isIOS) {
      FlutterLogs.logThis(
          logMessage: "["+tipo+"]["+dataHoraAtual.toString()+"] "+msg+"\n");
    }

  }


  static void clearLog() {
    FlutterLogs.clearLogs();
  }

  static Future<int> uploadLogDiario() async {
    DateTime now = new DateTime.now();
    String dataAtual = DateFormat('ddMMyyyy').format(now);
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs');
    } else if (Platform.isIOS) {
      Directory docios = await getApplicationDocumentsDirectory();
      String docios_path = docios.toString();
      docios_path = docios_path.replaceAll("'","").replaceAll("Directory: ","").replaceAll("/Documents", "");
      dir = Directory(docios_path+"/Library/Application Support/Logs");
    }
    dir.list(recursive: false).forEach((f) async {
      String pasta;
      String caminho_arquivo;
      String arquivo;
      if (Platform.isAndroid) {
        pasta = f.toString().replaceAll("'","").split("/").last;
        caminho_arquivo = '/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta+'/spsSupplierPortal.log';
        arquivo = 'spsSupplierPortal.log';
      } else if (Platform.isIOS) {
        caminho_arquivo = f.path.toString();
        arquivo = f.toString().split('/').last.replaceAll("'","");
        pasta = arquivo.split('-').first;
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        var _deviceData = await deviceInfoPlugin.iosInfo;
        usuarioAtual.modelo_dispositivo = _deviceData.name;
      }
      if(pasta.trim() != dataAtual.trim()){
        spsUpDown objspsUpDown = spsUpDown();
        bool statusUpload = false;
        if (Platform.isAndroid || (Platform.isIOS && arquivo.trim() != '.DS_Store')) {
          //Prepara dados para upload do arquivo.
          FormData formData = FormData.fromMap({
            "files": [ await MultipartFile.fromFile(caminho_arquivo,
                filename: arquivo),
            ],
            "codigo_usuario": usuarioAtual.codigo_usuario,
            "tipo_dispositivo": usuarioAtual.tipo_dispositivo,
            "modelo_dispositivo": usuarioAtual.modelo_dispositivo,
            "versao_sistema_operacional": usuarioAtual.versao_sistema_operacional,
            "data": pasta,
            "replace": "true",
          });
          statusUpload = await objspsUpDown.uploadLog(formData);
        }
        if (statusUpload == true) {
          spsLog.log(debug: 1, tipo: "INFO", msg: "Log foi enviado para o servidor. Apagando loglocal: "+pasta);
          if (Platform.isAndroid) {
            final loglocal = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta);
            loglocal.deleteSync(recursive: true);
          } else if (Platform.isIOS) {
            final file = File(caminho_arquivo);
            await file.delete();
          }
          spsLog.log(debug: 1, tipo: "INFO", msg: "loglocal: "+pasta+" foi apagado com sucesso!");
        } else {
          spsLog.log(debug: 1, tipo: "ERRO", msg: "Não foi possível enviar o Log para o servidor: " + pasta);
        }
      }
    });
  }

  static Future<int> uploadLogNow() async {
    DateTime now = new DateTime.now();
    String dataAtual = DateFormat('ddMMyyyy').format(now);
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs');
    } else if (Platform.isIOS) {
      Directory docios = await getApplicationDocumentsDirectory();
      String docios_path = docios.toString();
      docios_path = docios_path.replaceAll("'","").replaceAll("Directory: ","").replaceAll("/Documents", "");
      dir = Directory(docios_path+"/Library/Application Support/Logs");
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var _deviceData = await deviceInfoPlugin.iosInfo;
      usuarioAtual.modelo_dispositivo = _deviceData.name;
    }
    dir.list(recursive: false).forEach((f) async {
      String pasta;
      String caminho_arquivo;
      String arquivo;
      if (Platform.isAndroid) {
        pasta = f.toString().replaceAll("'","").split("/").last;
        caminho_arquivo = '/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta+'/spsSupplierPortal.log';
        arquivo = 'spsSupplierPortal.log';
      } else if (Platform.isIOS) {
        caminho_arquivo = f.path.toString();
        arquivo = f.toString().split('/').last.replaceAll("'","");
        pasta = arquivo.split('-').first;
      }
        spsUpDown objspsUpDown = spsUpDown();
        bool statusUpload = false;
        if (Platform.isAndroid || (Platform.isIOS && arquivo.trim() != '.DS_Store')) {
          //Prepara dados para upload do arquivo.
          FormData formData = FormData.fromMap({
            "files": [ await MultipartFile.fromFile(caminho_arquivo,
                filename: arquivo),
            ],
            "codigo_usuario": usuarioAtual.codigo_usuario,
            "tipo_dispositivo": usuarioAtual.tipo_dispositivo,
            "modelo_dispositivo": usuarioAtual.modelo_dispositivo,
            "versao_sistema_operacional": usuarioAtual.versao_sistema_operacional,
            "data": pasta,
            "replace": "true",
          });
          statusUpload = await objspsUpDown.uploadLog(formData);
        }
        if (statusUpload == true) {
          spsLog.log(debug: 1, tipo: "INFO", msg: "Log foi enviado para o servidor : "+pasta);
          if(pasta.trim() != dataAtual.trim()){
            if (Platform.isAndroid) {
              final loglocal = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta);
              loglocal.deleteSync(recursive: true);
            } else if (Platform.isIOS) {
              final file = File(caminho_arquivo);
              await file.delete();
            }
            spsLog.log(debug: 1, tipo: "INFO", msg: "loglocal: "+pasta+" foi apagado com sucesso!");
          }
        } else {
          spsLog.log(debug: 1, tipo: "ERRO", msg: "Não foi possível enviar o Log para o servidor: " + pasta);
        }

    });
  }

  static Future<int> uploadLogNowAndLogout() async {
    DateTime now = new DateTime.now();
    String dataAtual = DateFormat('ddMMyyyy').format(now);
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs');
    } else if (Platform.isIOS) {
      Directory docios = await getApplicationDocumentsDirectory();
      String docios_path = docios.toString();
      docios_path = docios_path.replaceAll("'","").replaceAll("Directory: ","").replaceAll("/Documents", "");
      dir = Directory(docios_path+"/Library/Application Support/Logs");
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var _deviceData = await deviceInfoPlugin.iosInfo;
      usuarioAtual.modelo_dispositivo = _deviceData.name;
    }
    dir.list(recursive: false).forEach((f) async {
      String pasta;
      String caminho_arquivo;
      String arquivo;
      if (Platform.isAndroid) {
        pasta = f.toString().replaceAll("'","").split("/").last;
        caminho_arquivo = '/sdcard/Android/data/com.schuler.sps/files/spsLogs/Logs/'+pasta+'/spsSupplierPortal.log';
        arquivo = 'spsSupplierPortal.log';
      } else if (Platform.isIOS) {
        caminho_arquivo = f.path.toString();
        arquivo = f.toString().split('/').last.replaceAll("'","");
        pasta = arquivo.split('-').first;
      }
      spsUpDown objspsUpDown = spsUpDown();
      bool statusUpload = false;
      if (Platform.isAndroid || (Platform.isIOS && arquivo.trim() != '.DS_Store')) {
        //Prepara dados para upload do arquivo.
        FormData formData = FormData.fromMap({
          "files": [ await MultipartFile.fromFile(caminho_arquivo,
              filename: arquivo),
          ],
          "codigo_usuario": usuarioAtual.codigo_usuario,
          "tipo_dispositivo": usuarioAtual.tipo_dispositivo,
          "modelo_dispositivo": usuarioAtual.modelo_dispositivo,
          "versao_sistema_operacional": usuarioAtual.versao_sistema_operacional,
          "data": pasta,
          "replace": "false",
        });
        statusUpload = await objspsUpDown.uploadLog(formData);
      }
      if (statusUpload == true) {
        spsLog.log(debug: 1, tipo: "INFO", msg: "Log foi enviado para o servidor : "+pasta);
          if (Platform.isIOS) {
            final file = File(caminho_arquivo);
            await file.delete();
            spsLog.log(debug: 1, tipo: "INFO", msg: "loglocal: "+pasta+" foi apagado com sucesso!");
          }
      } else {
        spsLog.log(debug: 1, tipo: "ERRO", msg: "Não foi possível enviar o Log para o servidor: " + pasta);
      }

    });
  }


}
