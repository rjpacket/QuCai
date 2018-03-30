package com.hatsune;

import android.content.Intent;
import android.text.TextUtils;

import com.RNFetchBlob.RNFetchBlobPackage;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;
import com.hatsune.module.AppPackage;
import com.hatsune.proxy.HookManager;
import com.jadsonlourenco.RNShakeEvent.RNShakeEventPackage;
import com.learnium.RNDeviceInfo.RNDeviceInfo;
import com.liuchungui.react_native_umeng_push.UmengPushApplication;
import com.liuchungui.react_native_umeng_push.UmengPushPackage;
import com.meituan.android.walle.WalleChannelReader;
import com.microsoft.codepush.react.CodePush;
import com.oblador.keychain.KeychainPackage;
import com.rnfs.RNFSPackage;
import com.umeng.analytics.MobclickAgent;
import com.umeng.message.MessageSharedPrefs;
import com.zmxv.RNSound.RNSoundPackage;

import java.util.Arrays;
import java.util.List;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.reactnativejpush.JPushPackage;
import io.paperdb.Paper;

public class MainApplication extends UmengPushApplication implements ReactApplication {

    private static MainApplication sMainApplication;

    private AppConfiguration appConfiguration;
    private CodePush codePush;

    private final ReactNativeHost reactNativeHost = new ReactNativeHost(this) {

        @Override
        protected String getJSBundleFile() {
            return CodePush.getJSBundleFile();
        }

        @Override
        protected boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new UmengPushPackage(),
                    new RNSoundPackage(),
                    new RNShakeEventPackage(),
                    new KeychainPackage(),
                    new RNFSPackage(),
                    new UmengReactPackage(),
                    new RNFetchBlobPackage(),
                    new RNDeviceInfo(),
                    new JPushPackage(false, false),
                    new AppPackage(),
                    codePush
            );
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return reactNativeHost;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
        RNPatcher.resetClientProvider();
        sMainApplication = this;
        HookManager.hookPackageManager(this);
        Paper.init(this);
        config();
        startConfigurationService();
    }

    public static AppConfiguration getAppConfiguration() {
        return sMainApplication.appConfiguration;
    }

    public void config() {
        appConfiguration = Paper.book().read(Constants.APP_CONFIGURATION, null);
        if (appConfiguration == null) {
            appConfiguration = getLocalAppConfig();
        }

        configCodepush();
        configUmeng();
        configJPush();
    }

    private void configUmeng() {
        MobclickAgent.UMAnalyticsConfig umConfig = new MobclickAgent.UMAnalyticsConfig(this, appConfiguration.umengAppKey, appConfiguration.channel);
        MobclickAgent.startWithConfigure(umConfig);
        // reset umeng keys
        MessageSharedPrefs.getInstance(this).setMessageAppKey(appConfiguration.umengAppKey);
        MessageSharedPrefs.getInstance(this).setMessageAppSecret(appConfiguration.umengAppSecret);
        MessageSharedPrefs.getInstance(this).setMessageChannel(appConfiguration.channel);
        mPushAgent.setMessageChannel(appConfiguration.channel);
        mPushAgent.setResourcePackageName("com.hatsune");
    }

    private void configCodepush() {
        String codepushServerUrl = appConfiguration.codepushServerUrl;
        String codepushKey = appConfiguration.codepushKey;
        int activityIndexer = getActivityIndexer(appConfiguration);
        if (activityIndexer == Constants.ActivityIndexer.ACTIVITY_NATIVE_RN &&
                BuildConfig.SHELL_REACT_NATIVE_CODEPUSH) {
            codepushServerUrl = BuildConfig.SHELL_CODE_PUSH_SERVER_URL;
            codepushKey = BuildConfig.SHELL_CODE_PUSH_KEY;
        } else {
            CodePush.overrideAppVersion("1.0.0");
        }

        if (TextUtils.isEmpty(codepushServerUrl)) {
            codePush = new CodePush(codepushKey, getApplicationContext(), BuildConfig.DEBUG);
        } else {
            codePush = new CodePush(codepushKey, getApplicationContext(), BuildConfig.DEBUG, codepushServerUrl);
        }
    }

    private void startConfigurationService() {
        String processName = Utils.getCurrentProcessName(this);
        if (TextUtils.equals(processName, getPackageName())) {
            startService(new Intent(this, ConfigurationService.class));
        }
    }

    private void configJPush() {
        // modify meta data through hook
        JPushInterface.init(this);
    }

    private AppConfiguration getLocalAppConfig() {
        AppConfiguration configuration = new AppConfiguration();
        configuration.channel = WalleChannelReader.getChannel(this);
        configuration.umengAppKey = BuildConfig.UMENG_APPKEY;
        configuration.umengAppSecret = BuildConfig.UMENG_MESSAGE_SECRET;
        configuration.codepushKey = BuildConfig.CODE_PUSH_KEY;
        configuration.codepushServerUrl = BuildConfig.CODE_PUSH_SERVER_URL;
        configuration.jpushAppKey = BuildConfig.JPUSH_APPKEY;
        return configuration;
    }

    protected static int getActivityIndexer(AppConfiguration configuration) {
        if (configuration.reviewStatus == Constants.ReviewStatus.REVIEWED &&
                configuration.isInAvailableArea == Constants.AvailableArea.IN &&
                !TextUtils.isEmpty(configuration.codepushKey)) {
            // 显示过审之后 RN 页面
            return Constants.ActivityIndexer.ACTIVITY_MAIN;
        } else if (BuildConfig.SHELL_IS_REACT_NATIVE) {
            // 显示原生过审 RN 页面
            return Constants.ActivityIndexer.ACTIVITY_NATIVE_RN;
        } else {
            // 显示原生过审页面
            return Constants.ActivityIndexer.ACTIVITY_NATIVE;
        }
    }
}
