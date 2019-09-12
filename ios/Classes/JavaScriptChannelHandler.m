// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "JavaScriptChannelHandler.h"

@implementation FLTJavaScriptChannel {
  FlutterMethodChannel* _methodChannel;
  NSString* _javaScriptChannelName;
  NSString* _keyWebView;
}

- (instancetype)initWithMethodChannel:(FlutterMethodChannel*)methodChannel
                javaScriptChannelName:(NSString*)javaScriptChannelName
                keyWebView:(NSString*)keyWebView {
  self = [super init];
  NSAssert(methodChannel != nil, @"methodChannel must not be null.");
  NSAssert(javaScriptChannelName != nil, @"javaScriptChannelName must not be null.");
  NSAssert(keyWebView != nil, @"keyWebView must not be null.");
  if (self) {
    _methodChannel = methodChannel;
    _javaScriptChannelName = javaScriptChannelName;
    _keyWebView = keyWebView;
  }
  return self;
}

- (void)userContentController:(WKUserContentController*)userContentController
      didReceiveScriptMessage:(WKScriptMessage*)message {
  NSAssert(_methodChannel != nil, @"Can't send a message to an unitialized JavaScript channel.");
  NSAssert(_javaScriptChannelName != nil,
           @"Can't send a message to an unitialized JavaScript channel.");
  NSAssert(_keyWebView != nil,
             @"Can't send a message to an undefined webview.");
  NSDictionary* arguments = @{
    @"channel" : _javaScriptChannelName,
    @"message" : [NSString stringWithFormat:@"%@", message.body],
    @"keyWebView" : _keyWebView
  };
  [_methodChannel invokeMethod:@"javascriptChannelMessage" arguments:arguments];
}

@end
