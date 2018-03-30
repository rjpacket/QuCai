package com.hatsune;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;

public class ActivitySplash extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        showReactNativeControllerIfInNeed();
        finish();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    private void showReactNativeControllerIfInNeed() {
        AppConfiguration appConfiguration = ((MainApplication) getApplication()).getAppConfiguration();

        // 根据缓存来展示RN内容
        int activityIndexer = MainApplication.getActivityIndexer(appConfiguration);
        if (activityIndexer == Constants.ActivityIndexer.ACTIVITY_MAIN) {
            // 显示过审之后 RN 页面
            startActivity(new Intent(this, ActivityMain.class));
        } else if (activityIndexer == Constants.ActivityIndexer.ACTIVITY_NATIVE_RN) {
            // 显示原生过审 RN 页面
            startActivity(new Intent(this, ActivityNativeRN.class));
        } else {
            // 显示原生页面
            startActivity(new Intent(this, ActivityNative.class));
        }
    }
}