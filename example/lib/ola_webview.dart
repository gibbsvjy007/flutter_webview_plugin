import 'dart:async';

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

  @override
  Widget build(BuildContext context) {

    return WebviewScaffold(
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
    );
  }

}
