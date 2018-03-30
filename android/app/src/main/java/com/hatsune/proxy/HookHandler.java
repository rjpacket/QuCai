package com.hatsune.proxy;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.text.TextUtils;

import com.hatsune.AppConfiguration;
import com.hatsune.MainApplication;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class HookHandler implements InvocationHandler {

    private Object sourceObj;

    public HookHandler(Object sourceObj) {
        this.sourceObj = sourceObj;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        if (method.getName().equals("getApplicationInfo") &&
                args != null && args.length == 3 && (Integer) args[1] == PackageManager.GET_META_DATA
                && (Integer) args[2] == 0) {
            ApplicationInfo appInfo = (ApplicationInfo) method.invoke(sourceObj, args);
            if (appInfo.metaData != null) {
                AppConfiguration configuration = MainApplication.getAppConfiguration();
                if (!TextUtils.isEmpty(configuration.jpushAppKey)) {
                    appInfo.metaData.putString("JPUSH_APPKEY", configuration.jpushAppKey);
                }
                if (!TextUtils.isEmpty(configuration.channel)) {
                    appInfo.metaData.putString("JPUSH_CHANNEL", configuration.channel);
                }
            }
            return appInfo;
        }
        return method.invoke(sourceObj, args);
    }
}
