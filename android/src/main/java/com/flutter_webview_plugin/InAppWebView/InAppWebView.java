package com.flutter_webview_plugin.InAppWebView;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.util.Log;
import android.view.View;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

final public class InAppWebView extends InputAwareWebView {

    static final String LOG_TAG = "InAppWebView";

    public InAppWebView(Context context) {
        super(context);
    }

    public void takeScreenshot(final MethodChannel.Result result, final View containerView) {
        Log.e(LOG_TAG, "0________");
        containerView.post(new Runnable() {
            @Override
            public void run() {
                Log.e(LOG_TAG, "1");
                float scale = containerView.getResources().getDisplayMetrics().density;

                int height = (int) (containerView.getHeight() * scale + 0.5);
                Log.e(LOG_TAG, "2");

                Bitmap b = Bitmap.createBitmap(containerView.getWidth(),
                        height, Bitmap.Config.ARGB_8888);
                Canvas c = new Canvas(b);
                Log.e(LOG_TAG, "3");

                containerView.draw(c);
                int scrollOffset = (containerView.getScrollY() + containerView.getMeasuredHeight() > b.getHeight())
                        ? b.getHeight() : containerView.getScrollY();
                Bitmap resized = Bitmap.createBitmap(
                        b, 0, scrollOffset, b.getWidth(), containerView.getMeasuredHeight());
                Log.e(LOG_TAG, "4");

                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                Log.e(LOG_TAG, "5");

                resized.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
                try {
                    byteArrayOutputStream.close();
                    Log.e(LOG_TAG, "6");
                } catch (IOException e) {
                    e.printStackTrace();
                    Log.e(LOG_TAG, e.getMessage());
                }
                resized.recycle();
                Log.e(LOG_TAG, "7");
                result.success(byteArrayOutputStream.toByteArray());
                Log.e(LOG_TAG, "8");
            }
        });
    }
}
