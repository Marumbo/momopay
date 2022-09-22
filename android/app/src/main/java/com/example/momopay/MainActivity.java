package com.example.momopay;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import com.hover.sdk.api.Hover;
import com.hover.sdk.api.HoverParameters;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

private static final String CHANNEL2 = "momopay.mw/hover";

private static final String CHANNEL = "samples.flutter.dev/battery";

private String activityMessage = "";
private Boolean activityError = false;

private  void SendMoneyNumber(String phoneNumber,String amount){

  Intent i = new HoverParameters.Builder(this)
          .request("39829796")
          .extra("Recipient", phoneNumber)
          .extra("Amount", amount)
          .buildIntent();

  startActivityForResult(i,0);
}
private  void SendMoneyMerchant(String phoneNumber,String amount){

  Intent i = new HoverParameters.Builder(this)
          .request("719d74ab")
          .extra("code", phoneNumber)
          .extra("amount", amount)
          .buildIntent();

  startActivityForResult(i,0);
}



private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
  Hover.initialize(this);

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
           // Note: this method is invoked on the main thread.
           if (call.method.equals("getBatteryLevel")) {
            int batteryLevel = getBatteryLevel();

            if (batteryLevel != -1) {
              result.success(batteryLevel);
            } else {
              result.error("UNAVAILABLE", "Battery level not available.", null);
            }
          } else {
            result.notImplemented();
          }
        }
        );

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL2)
        .setMethodCallHandler(
          (call, result) -> {

// Get arguments from flutter code
            final Map<String,Object> arguments = call.arguments();
            String PhoneNumber = (String) arguments.get("phoneNumber");
            String amount = (String) arguments.get("amount");

           if (call.method.equals("sendMoneyNumber")) {
              SendMoneyNumber(PhoneNumber,amount);
             
             /* if(activityError == false) {
                
                result.success(activityMessage);
              }
              if(activityError == true) {
               
                result.success(activityMessage);
              } */

              String response = "sent";
              result.success(response);
            }

          if (call.method.equals("sendMoneyMerchant")) {
            SendMoneyMerchant(PhoneNumber,amount);

            /**  if(activityError == false) {
                
                result.success(activityMessage);
              }
              if(activityError == true) {
               
                result.success(activityMessage);
              }
*/
          String response = "sent";
          result.success(response);
          }

              String response = "No actvity error check";
              result.success(response);
            
          });
  }

}

