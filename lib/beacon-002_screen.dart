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
              'L??n N?? N??a',
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
            _text('T??n s???n ph???m ',
                "????nh H???ng Th??i - ?????a ??i???m d???ng ch??n ?????u ti??n c???a B??c H??? khi ?????n T??n Tr??o. "),
            _space,
            ReadMoreText(
              'L??c m???i ?????n T??n Tr??o, B??c H??? ???????c b??? tr?? ??? t???m v???i gia ????nh ??ng Nguy???n Ti???n S???, Ch??? nhi???m Vi???t Minh c???a l??ng Kim Long. Sau ????, ????? ?????m b???o an to??n, b?? m???t B??c chuy???n l??n ??? v?? l??m vi???c t???i c??n l??n nh??? trong khu r???ng N?? N??a, thu???c d??y n??i H???ng.\n'
              '    L??n N?? N??a n???m k??n ????o d?????i c??c t??n c??y r???m r???p, b???o ?????m b?? m???t v?? ????p ???ng ???????c y??u c???u c???a B??c ????? ra: G???n n?????c, g???n d??n, xa qu???c l???, thu???n ???????ng ti???n, ti???n ???????ng tho??i. L??n c??ch l??ng T??n L???p h??n 500 m??t v??? h?????ng ????ng, c??ch l??n ch???ng 80 m??t l?? con ???????ng m??n qua ????o De, sang Ph?? ????nh- ?????nh H??a (Th??i Nguy??n); ph??a tr?????c l??n, d?????i ch??n r???ng N?? N??a l?? d??ng su???i Khu??n P??n.\n'
              '	   L??n N?? N??a ???????c d???ng theo ki???u nh?? s??n c???a ng?????i mi???n n??i, l??m b???ng g??? r???ng, m??i l???p l?? c???. L??n ???????c ng??n l??m hai n???a, m???t b??n l?? n??i B??c l??m vi???c v?? ti???p kh??ch; m???t b??n l?? n??i B??c ngh??? ng??i. Ph??a d?????i, ?????u s??n c???a l??n l?? phi???n ???? r???ng v?? ph???ng, n??i B??c th?????ng ng???i l??m vi???c, ????nh m??y ch??? m???i khi tr???i t???i.\n'
              '	   L??n N?? N??a l?? n??i B??c H??? ???? ???, l??m vi???c t??? cu???i th??ng 5 ?????n ng??y 22-8-1945. T???i ????y B??c ???? c?? nh???ng ch??? th??? quan tr???ng, th??nh l???p Khu gi???i ph??ng (g???m 6 t???nh: Cao B???ng, B???c K???n, L???ng S??n, Th??i Nguy??n, Tuy??n Quang, H?? Giang). T??n Tr??o (Tuy??n Quang) ???????c ch???n l?? th??? ???? khu gi???i ph??ng.\n'
              '	   C??ng t???i c??n l??n n??y cu???i th??ng 7, ?????u th??ng 8 n??m 1945, trong l??c t??nh h??nh ??ang di???n ra h???t s???c kh???n tr????ng, B??c b??? ???m n???ng, c?? l??c y???u m???t, B??c ???? c??n d???n ?????ng ch?? V?? Nguy??n Gi??p: ???L??c n??y th???i c?? thu???n l???i ???? t???i, d?? hy sinh t???i ????u, d?? ph???i ?????t ch??y c??? d??y Tr?????ng S??n c??ng ph???i ki??n quy???t gi??nh cho ???????c ?????c l???p???.\n'
              '	   T??? ????y B??c ???? tri???u t???p H???i ngh??? to??n qu???c c???a ?????ng (t??? ng??y 13/8/1945 ?????n ng??y 15/8/1945 th??ng qua k??? ho???ch l??nh ?????o to??n d??n t???ng kh???i ngh??a gi??nh ch??nh quy???n trong c??? n?????c. C??ng ng??y, ???y ban Kh???i ngh??a to??n qu???c ???????c th??nh l???p v?? ra b???n Qu??n l???nh s??? I, h??? l???nh t???ng kh???i ngh??a.',
              trimLines: 4,
              preDataText: "Th??ng Tin Chung: ",
              preDataTextStyle: TextStyle(fontWeight: FontWeight.w500),
              style: TextStyle(color: Colors.black),
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...<?????c ti???p>',
              trimExpandedText: ' ...<thu g???n>',
            ),
            _space,
            _text('Video Gi???i Thi???u', ""),
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
