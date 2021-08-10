import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:im_voice_demo/tools/data/database.dart';
import 'package:im_voice_demo/tools/date.dart';
import 'package:im_voice_demo/ui/dialog/voice_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



typedef VoiceFile = void Function(String path);
typedef TimeShowFunc = void Function(String path);

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}

class ChatVoice extends StatefulWidget {

  final VoiceFile voiceFile;
  final TimeShowFunc timeShowFunc;

  ChatVoice({required this.voiceFile,required this.timeShowFunc});

  @override
  _ChatVoiceWidgetState createState() => _ChatVoiceWidgetState();

}


class _ChatVoiceWidgetState extends State<ChatVoice> {

  double startY = 0.0;
  double offset = 0.0;

  late Permission _permission;//final
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  RecordPlayState _state = RecordPlayState.record;

  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "images/voice_volume_1.png";

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry? overlayEntry;

  double _dbLevel = 0.0;
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();

  var _maxLength = 59.0;

  late StreamSubscription _recorderSubscription;

  @override
  void initState() {
    super.initState();
    init();
    initializeDateFormatting();
  }

  Future<void> init() async {
    recorderModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await recorderModule.setSubscriptionDuration(const Duration(milliseconds: 30));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

  /// 开始录音
  _startRecorder() async {
    try {

      init();
      _permission = Permission.microphone;
      var status = await _permission.status;

      if (status != PermissionStatus.granted) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        print("未获取到麦克风权限");
        requestPermission(_permission);
        return;
      }else{
        print('===>  获取了权限');
        Directory tempDir = await getTemporaryDirectory();
        String path = '${tempDir.path}/voice${ext[Codec.aacADTS.index]}';
        print('===>  准备开始录音。 录音路径:  $path');
        await recorderModule.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
          bitRate: 8000,
          sampleRate: 8000,
        );
        print('===>  开始录音');
        widget.voiceFile(path);
        /// 监听录音
        _recorderSubscription = recorderModule.onProgress!.listen((e){

          print("当前录音进度: $e, 当前录音路径: $path");
          VoiceModel model = VoiceModel(id: "1", path: path);
          DB().insertVoice(model);

          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          print("当前录音时间: $txt");

          widget.timeShowFunc(txt);

          if (date.second >= _maxLength) {
            _stopRecorder();
          }

          setState(() {
            // _recorderTxt = txt.substring(0, 8);
            _dbLevel = e.decibels!;
            print("当前振幅：$_dbLevel");
          });

        });

        setState(() {
          _state = RecordPlayState.recording;
          print("path == $path");
        });

      }

    } catch (err) {

      print("打印异常：${err.toString()}");
      setState(() {
        _stopRecorder();
        _state = RecordPlayState.record;
      });

    }

  }


  ///结束录音
  _stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('结束录音：stopRecorder');
      VoiceModel theModel = await DB().query_by_id("1") as VoiceModel;
      print("ABCDEFG查询出来的路径：${theModel.path}");
      _releaseFlauto();
    } catch (err) {
      print('结束录音捕获异常：stopRecorder error: $err');
    }
    setState(() {
      _dbLevel = 0.0;
      _state = RecordPlayState.play;
    });
  }

  /// 释放录音和播放
  Future<void> _releaseFlauto() async {
    try {
      await recorderModule.closeAudioSession();
    } catch (e) {
      print(e);
    }
  }

  showVoiceView() {
    int index = 0;
    setState(() {
      textShow = "松开结束";
      voiceState = false;
      DateTime now = DateTime.now();
      int date = now.millisecondsSinceEpoch;
      DateTime current = DateTime.fromMillisecondsSinceEpoch(date);

      String recordingTime = DateTimeForMater.formatDateV(current, format: "ss:SS");
      index = int.parse(recordingTime.toString().substring(3, 5));
    });

    _startRecorder();

    overlayEntry ??= showVoiceDialog(context, index: index);
  }

  hideVoiceView() {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });
    _stopRecorder();
    print("+++++++++++++++++++++++++++++++++++++++++");
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  moveVoiceView() {
    setState(() {
      isUp = startY - offset > 100 ? true : false;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        startY = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragDown: (details) {
        startY = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragCancel: () => hideVoiceView(),
      onVerticalDragEnd: (details) => hideVoiceView(),
      onVerticalDragUpdate: (details) {
        offset = details.globalPosition.dy;
        moveVoiceView();
      },
      child: Container(
        height: 50.0,
        alignment: Alignment.center,
        width: 200.0,
        color: Colors.white,
        child: Text(textShow),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}
