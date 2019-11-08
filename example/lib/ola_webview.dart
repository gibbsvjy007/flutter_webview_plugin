import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class OlaWebView extends StatefulWidget {
  final String jsCode;
  OlaWebView({this.jsCode});

  @override
  _OlaWebViewState createState() => _OlaWebViewState();
}

class _OlaWebViewState extends State<OlaWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String hitUrl = 'https://book.olacabs.com/?pickup_name=Kolkata%20Airport%2C%20International%20Airport%20Dum%20Dum%20Kolkata%20West%20Bengal%20India&lat=22.6433439&lng=88.43940529999999&drop_lat=22.5830002&drop_lng=88.3372909&drop_name=Howrah%20Railway%20Station%2C%20Howrah%20West%20Bengal%20India&pickup=';
  // https://book.olacabs.com/data-api/category-fare/p2p?pickupLat=22.6428528303&pickupLng=88.4388256073&pickupMode=NOW&dropLat=22.5830002&dropLng=88.3372909&silent=false&pickupZoneId=970008690&defaultPickupPointId=970010927&shareCategories=share
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<String> _onMessage;
  bool invokedAjax = false;
  Uint8List imageInMemory;

  @override
  void initState() {
    super.initState();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print('onUrlChanged: $url');
      if (!invokedAjax) {
        invokedAjax = true;
//         listenAjax();
//         print("AJAX INTERCEPTOR INVOKED_________________");
      }
    });

    _onMessage = flutterWebviewPlugin.onPostMessage.listen((msg) {
      print("MESSAGE INVOKED_________________");
      print(msg);
    });
  }

  listenAjax() async {
    await Future.delayed(Duration(seconds: 1));
    flutterWebviewPlugin.invokeAjaxInterceptor();
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin?.close();
    _onUrlChanged?.cancel();
    _onMessage?.cancel();
  }

  Future<void> loadJS() async {
    var givenJS = rootBundle.loadString('assets/zabo_flutter_webview.js');
    return givenJS.then((String js) {
      print('loading js');
      final future = flutterWebviewPlugin.evalJavascript(js);
      future.then((String result) {
        print(result);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<Uint8List> _capturePng() async {
    try {
      print("_capturePng_____________");
      Uint8List pngData = await flutterWebviewPlugin.takeScreenshot();
      print("_________________after image");
      print(pngData);
      setState(() {
        imageInMemory = pngData;
      });
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('Yuppy', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),textAlign: TextAlign.center,)),
              contentPadding: const EdgeInsets.all(15.0),
              content:  Container(decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width - 30,
//              child: _imageFile != null ? Image.file(_imageFile) : Container(),
                child: imageInMemory != null
                    ? Container(
                    child: Image.memory(imageInMemory),
                    margin: const EdgeInsets.all(10))
                    : Container(),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'))

              ],
            );
          });
      return pngData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        RaisedButton(
          child: const Text('capture Image'),
          onPressed: _capturePng,
        ),
        Expanded(
          child: WebviewScaffold(
            url: hitUrl,
            appBar: AppBar(
              title: const Text('Uber'),
            ),
            withZoom: true,
            appCacheEnabled: false,
            withJavascript: true,
            withOverviewMode: true,
            hidden: true,
            jsCode: widget.jsCode.toString(),
            withLocalStorage: true,
            ajaxInterceptor: true,
            initialChild: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Text('Waiting.....'),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      flutterWebviewPlugin.goBack();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      flutterWebviewPlugin.goForward();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.autorenew),
                    onPressed: () {
                      flutterWebviewPlugin.reload();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      print('takeScreenshot');
                      _capturePng();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}
