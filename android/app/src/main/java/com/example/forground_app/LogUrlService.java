package com.example.forground_app;

import android.accessibilityservice.AccessibilityService;

import android.content.Intent;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.accessibility.AccessibilityWindowInfo;


public class LogUrlService extends AccessibilityService {

    public static String ACCESSIBILITY_INTENT = "accessibility_event";
    public static String ACCESSIBILITY_PACKAGE_NAME = "accessibility_name";
    public static String ACCESSIBILITY_URL = "accessibility_url";

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        final int eventType = event.getEventType();
        Log.d("EVENT", "E: " + eventType);
        AccessibilityNodeInfo parentNodeInfo = event.getSource();
        AccessibilityWindowInfo info = event.getSource().getWindow();
        Log.i("WINDOW", info.toString());
        if (parentNodeInfo == null) {
            return;
        }
        String packageName = event.getPackageName().toString();
        Intent intent = new Intent(ACCESSIBILITY_INTENT);
        intent.putExtra(ACCESSIBILITY_PACKAGE_NAME, packageName);
        intent.putExtra(ACCESSIBILITY_URL, "NO_URL");
        sendBroadcast(intent);
    }


    @Override
    public void onInterrupt() {
    }

    @Override
    public void onServiceConnected() {
    }

}