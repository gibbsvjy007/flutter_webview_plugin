/// A message that was sent by JavaScript code running in a [WebView].

class JavascriptMessage {
  /// Constructs a JavaScript message object.
  ///
  /// The `message` parameter must not be null.
  const JavascriptMessage(this.message, this.keyWebView) : assert(message != null, keyWebView != null);

  /// The contents of the message that was sent by the JavaScript code.
  final String message;

  /// The contents of the keyWebView that was sent by the JavaScript code.
  final String keyWebView;
}
