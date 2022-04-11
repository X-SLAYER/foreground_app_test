package com.example.forground_app;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class AccessibilityListener implements EventChannel.StreamHandler {

    private EventChannel.EventSink eventSink;
    private BroadcastReceiver broadcastReceiver;
    private Context context;

    public AccessibilityListener(Context context) {
        this.context = context;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        broadcastReceiver = createBroadcast(events);
        context.registerReceiver(broadcastReceiver, new IntentFilter(LogUrlService.ACCESSIBILITY_INTENT));
    }

    @Override
    public void onCancel(Object arguments) {
        context.unregisterReceiver(broadcastReceiver);
        eventSink = null;
        broadcastReceiver = null;
    }

    private BroadcastReceiver createBroadcast(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                /// Unpack intent contents
                String browserName = intent.getStringExtra("BROWSER_APP");
                String url = intent.getStringExtra("BROWSER_URL");

                /// Send data back via the Event Sink
                HashMap<String, Object> data = new HashMap<>();
                data.put(LogUrlService.ACCESSIBILITY_PACKAGE_NAME, browserName);
                data.put(LogUrlService.ACCESSIBILITY_URL, url);
                events.success(data);
            }
        };
    }

}
