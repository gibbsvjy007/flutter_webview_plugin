package com.flutter_webview_plugin;
import android.content.Context;
import android.widget.Toast;
import android.util.Log;
import android.webkit.JavascriptInterface;

public class AjaxInterceptor {
    private static final String TAG = "AjaxHandler";
    private final Context context;

    /**
     * @param context
     */
    public AjaxInterceptor(Context context) {
        this.context = context;
    }

    @JavascriptInterface
    public void ajaxBegin() {
        Log.w(TAG, "AJAX CALL Begin");
        Toast.makeText(context, "AJAX Begin", Toast.LENGTH_SHORT).show();
    }

    @JavascriptInterface
    public void ajaxDone() {
        Log.w(TAG, "AJAX CALL Done");

    }

    @JavascriptInterface
    public void showToast(final String html) {

        Toast.makeText(context, "Reached JS: " + html, Toast.LENGTH_LONG).show();

    }
}
