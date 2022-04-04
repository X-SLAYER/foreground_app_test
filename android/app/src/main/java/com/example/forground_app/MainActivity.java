package com.example.forground_app;

import android.app.ActivityManager;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL_TAG = "x.slayer/running_apps";
    public final int RESULT_ENABLE_ADMINISTARTIVE = -11;
    static final int RESULT_ENABLE = -11;
    DevicePolicyManager deviceManger;
    ComponentName compName;

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        compName = new ComponentName(this, DeviceAdmin.class);
        deviceManger = (DevicePolicyManager) this.getSystemService(Context.DEVICE_POLICY_SERVICE);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_TAG)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("print")) {
                                result.success("Hello from java bro");
                            } else if (call.method.equals("enable")) {
                                enableAccess();
                            } else if (call.method.equals("disable")) {
                                deviceManger.removeActiveAdmin(compName);
                            } else if (call.method.equals("lockScreen")) {
                                boolean active = deviceManger.isAdminActive(compName);
                                if (active) {
                                    deviceManger.lockNow();
                                    result.success(true);
                                } else {
                                    result.error("-1", "You need to enable the Admin Device Features", null);
                                }
                            } else {
                                result.success(getProcessApps());
                            }
                        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case RESULT_ENABLE_ADMINISTARTIVE:
                if (resultCode == RESULT_ENABLE) {
                    Log.d("PERMISSION", "You have enabled the Admin Device features");
                } else {
                    Log.d("PERMISSION", "Problem to enable the Admin Device features");
                }
                break;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void enableAccess() {
        Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, compName);
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "You should enable the app!");
        startActivityForResult(intent, RESULT_ENABLE);
    }

    private List<String> getProcessApps() {
        ActivityManager actvityManager = (ActivityManager) this.getSystemService(ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> procInfos = actvityManager.getRunningAppProcesses();
        List<String> processNames = new ArrayList<String>();
        Log.d("Running Processes", "()()" + procInfos);
        for (int i = 0; i < procInfos.size(); i++) {
            processNames.add(procInfos.get(i).processName);
        }
        return processNames;
    }
}
