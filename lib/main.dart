import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_app/AppLocalizations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //var loc = new Text(AppLocalizations.of(context).title);
    return new MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('de', ''),
        // ... other locales the app supports
      ],
      title: "",
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: "YES/NO"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum PlayerState { stopped, playing, paused }

Duration duration;
Duration position;

PlayerState playerState = PlayerState.stopped;

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AudioPlayer audioPlayer = new AudioPlayer();

  void initPlayer() {
    if (audioPlayer.completionHandler != null) {
      return null;
    }

    audioPlayer.setDurationHandler((d) =>
        setState(() {
          duration = d;
        }));

    audioPlayer.setPositionHandler((p) =>
        setState(() {
          position = p;
        }));

    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future<ByteData> loadYesAsset() async {
    return await rootBundle.load('assets/sounds/Sound_YES.mp3');
  }

  Future<ByteData> loadNoAsset() async {
    return await rootBundle.load('assets/sounds/Sound_NO.mp3');
  }

  Future playYes() async {
    initPlayer();

    final file =
    new File('${(await getTemporaryDirectory()).path}/Sound_YES.mp3');
    await file.writeAsBytes((await loadYesAsset()).buffer.asUint8List());

    final result = await audioPlayer.play(file.path, isLocal: true);
    if (result == 1) setState(() => PlayerState.playing);
  }

  Future playNo() async {
    initPlayer();

    final file =
    new File('${(await getTemporaryDirectory()).path}/Sound_NO.mp3');
    await file.writeAsBytes((await loadNoAsset()).buffer.asUint8List());

    final result = await audioPlayer.play(file.path, isLocal: true);
    if (result == 1) setState(() => PlayerState.playing);
  }

  Future increment() async {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values. If we changed
    // _counter without calling setState(), then the build method would not be
    // called again, and so nothing would appear to happen.
    _counter++;
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  void initState() {
    super.initState();
    initPlayer();

    // TODO for answer timeout
    //var f = new Future(()=>increment());
    //f.timeout(const Duration(seconds: 3));

  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    width = width;

    List<Widget> menu = <Widget>[
      new IconButton(
        icon: new Icon(Icons.send),
        tooltip: 'To Example 2',
        //onPressed: () => _toExample2(context),
      ),
      new IconButton(
        icon: new Icon(Icons.help),
        tooltip: 'To Example 3',
        //onPressed: () => _toExample3(context),
      )
    ];

    Widget middleSection = new Expanded(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MaterialButton(
              child: new Text(AppLocalizations
                  .of(context)
                  .title),
              color: new Color(0xFFBF4D4A),
              onPressed: playYes,
              minWidth: width / 2,
            ),
            new MaterialButton(
              child: new Text("NO"),
              color: new Color(0xFF749935),
              onPressed: playNo,
              minWidth: width / 2,
            ),
          ],
        )
    );

    Widget bottomBanner = new Container (
      padding: new EdgeInsets.all(8.0),
      color: new Color(0X99CC0000),
      height: 48.0,
      child: new Center(
        child: new MaterialButton(
          child: new Text("NO"),
          color: Colors.grey[400],
          onPressed: playNo,
          minWidth: width,
        ),
      ),
    );

    Widget body = new Column(
      // This makes each child fill the full width of the screen
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        middleSection,
        bottomBanner,
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("YES/NO"),
        //actions: menu,
      ),
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }

}
