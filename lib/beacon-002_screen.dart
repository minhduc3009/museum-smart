import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:museum_smart/video_list.dart';
import 'package:readmore/readmore.dart';

class Beacon002 extends StatefulWidget {
  // late final BluetoothDevice device;
  @override
  _Beacon002 createState() => _Beacon002();
}

class _Beacon002 extends State<Beacon002> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    '7DPY93mW5WM', // lannalua vietnam
    'xyo49RcUCLg', // lannalua english
    'U0ue3479Ll0', // lannalua chinese
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset(
              'assets/images/img_rectangle19_101X113.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          title: const Text(
            'Beacon - 002',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.video_library),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => VideoList(),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            _space,
            Text(
              'Lán Nà Nưa',
              style: TextStyle(
                color: Color.fromARGB(255, 246, 48, 22),
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            _space,
            Image.asset(
              'assets/images/lan-na-nua.jpg',
              height: 180,
              fit: BoxFit.cover,
            ),
            // _space,
            _text('Tên sản phẩm ',
                "Đình Hồng Thái - Địa điểm dừng chân đầu tiên của Bác Hồ khi đến Tân Trào. "),
            _space,
            ReadMoreText(
              'Lúc mới đến Tân Trào, Bác Hồ được bố trí ở tạm với gia đình ông Nguyễn Tiến Sự, Chủ nhiệm Việt Minh của làng Kim Long. Sau đó, để đảm bảo an toàn, bí mật Bác chuyển lên ở và làm việc tại căn lán nhỏ trong khu rừng Nà Nưa, thuộc dãy núi Hồng.\n'
              '    Lán Nà Nưa nằm kín đáo dưới các tán cây rậm rạp, bảo đảm bí mật và đáp ứng được yêu cầu của Bác đề ra: Gần nước, gần dân, xa quốc lộ, thuận đường tiến, tiện đường thoái. Lán cách làng Tân Lập hơn 500 mét về hướng đông, cách lán chừng 80 mét là con đường mòn qua đèo De, sang Phú Đình- Định Hóa (Thái Nguyên); phía trước lán, dưới chân rừng Nà Nưa là dòng suối Khuôn Pén.\n'
              '	   Lán Nà Nưa được dựng theo kiểu nhà sàn của người miền núi, làm bằng gỗ rừng, mái lợp lá cọ. Lán được ngăn làm hai nửa, một bên là nơi Bác làm việc và tiếp khách; một bên là nơi Bác nghỉ ngơi. Phía dưới, đầu sàn của lán là phiến đá rộng và phẳng, nơi Bác thường ngồi làm việc, đánh máy chữ mỗi khi trời tối.\n'
              '	   Lán Nà Nưa là nơi Bác Hồ đã ở, làm việc từ cuối tháng 5 đến ngày 22-8-1945. Tại đây Bác đã có những chỉ thị quan trọng, thành lập Khu giải phóng (gồm 6 tỉnh: Cao Bằng, Bắc Kạn, Lạng Sơn, Thái Nguyên, Tuyên Quang, Hà Giang). Tân Trào (Tuyên Quang) được chọn là thủ đô khu giải phóng.\n'
              '	   Cũng tại căn lán này cuối tháng 7, đầu tháng 8 năm 1945, trong lúc tình hình đang diễn ra hết sức khẩn trương, Bác bị ốm nặng, có lúc yếu mệt, Bác đã căn dặn đồng chí Võ Nguyên Giáp: “Lúc này thời cơ thuận lợi đã tới, dù hy sinh tới đâu, dù phải đốt cháy cả dãy Trường Sơn cũng phải kiên quyết giành cho được độc lập”.\n'
              '	   Từ đây Bác đã triệu tập Hội nghị toàn quốc của Đảng (từ ngày 13/8/1945 đến ngày 15/8/1945 thông qua kế hoạch lãnh đạo toàn dân tổng khởi nghĩa giành chính quyền trong cả nước. Cùng ngày, Ủy ban Khởi nghĩa toàn quốc được thành lập và ra bản Quân lệnh số I, hạ lệnh tổng khởi nghĩa.',
              trimLines: 4,
              preDataText: "Thông Tin Chung: ",
              preDataTextStyle: TextStyle(fontWeight: FontWeight.w500),
              style: TextStyle(color: Colors.black),
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...<đọc tiếp>',
              trimExpandedText: ' ...<thu gọn>',
            ),
            _space,
            _text('Video Giới Thiệu', ""),
            _space,
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _isPlayerReady
                            ? () => _controller.load(_ids[
                                (_ids.indexOf(_controller.metadata.videoId) -
                                        1) %
                                    _ids.length])
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: _isPlayerReady
                            ? () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: _isPlayerReady
                            ? () => _controller.load(_ids[
                                (_ids.indexOf(_controller.metadata.videoId) +
                                        1) %
                                    _ids.length])
                            : null,
                      ),
                    ],
                  ),
                  // _space,
                  Row(
                    children: <Widget>[
                      const Text(
                        "Volume",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          value: _volume,
                          min: 0.0,
                          max: 100.0,
                          divisions: 10,
                          label: '${(_volume).round()}',
                          onChanged: _isPlayerReady
                              ? (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _controller.setVolume(_volume.round());
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  _space,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Color.fromARGB(255, 249, 3, 3),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
