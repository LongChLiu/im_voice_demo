import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:im_voice_demo/tools/data/database.dart';




class VoicePlayer{

  static FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  static playVoice({String? path}) async {

    VoicePlayer.init();
    VoiceModel theModel = await DB().query_by_id("1") as VoiceModel;
    path ??= theModel.path;

    // print("InnerPath:封装里面打印路径: ${theModel.path}");
    print("InnerPath:封装里面打印路径: $path");

    try {

      await playerModule.startPlayer(fromURI: path, codec: Codec.aacADTS, whenFinished: () {
            print('==> 结束播放');
            stopPlayer();
      });

      playerModule.onProgress!.listen((e) {

      });

      print('===> 开始播放');
    } catch (err) {
      print('==> 错误: $err');
    }
  }

  /// 判断文件是否存在
  static Future<bool> _fileExists(String? path) async {
    return await File(path!).exists();
  }

  /// 结束播放
  static Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('===> 结束播放');
    } catch (err) {
      print('==> 错误: $err');
    }
  }


  static Future<void> _initializeExample(bool withUI) async {
    await playerModule.closeAudioSession();
    await playerModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await playerModule.setSubscriptionDuration(const Duration(milliseconds: 30));
    print("Open Record Success ~ !");
  }

  static Future<void> init() async {
    await _initializeExample(false);
    if (Platform.isAndroid) {

    }
  }





}