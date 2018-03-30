package com.hatsune;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.widget.Toast;

import com.ternence.framework.JSONUtils;

import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.paperdb.Paper;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import static com.hatsune.Constants.APP_CONFIGURATION;

public class ConfigurationService extends Service {

    private volatile boolean hasRunning = false;
    private AppConfiguration appConfiguration;
    private Handler handler = new Handler(Looper.getMainLooper());

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        appConfiguration = ((MainApplication) getApplication()).getAppConfiguration();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (!hasRunning) {
            hasRunning = true;
            fetchAppConfiguration();
        }

        return super.onStartCommand(intent, flags, startId);
    }

    private void fetchAppConfiguration() {
        String url = "https://app-api.kosun.cc:8888/Home/app/getConfigurationByUniqueId";

        Map<String, String> params = new HashMap<>();
        params.put("platform", "2");
        params.put("appUniqueId", getPackageName());
        params.put("buildCode", String.valueOf(Utils.getVersionCode(this)));

        StringBuilder paramStrings = new StringBuilder();
        for (String key : params.keySet()) {
            paramStrings.append(key).append("=").append(params.get(key)).append("&");
        }

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder().url(url + "?" + paramStrings.toString())
                .build();
        Call call = okHttpClient.newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                // do nothing
                e.printStackTrace();
                stopSelf();
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if (response != null && response.isSuccessful()) {
                    String jsonResponse = response.body().string();
                    JSONObject jsonObject = JSONUtils.parseJSONObjectFromString(jsonResponse);

                    int code = JSONUtils.getInt("code", jsonObject);
                    if (code == 200) {
                        AppConfiguration newAppConfiguration = new AppConfiguration();
                        JSONObject result = JSONUtils.getJSONObject("data", jsonObject);
                        newAppConfiguration.reviewStatus = JSONUtils.getInt("reviewStatus", result);
                        newAppConfiguration.isInAvailableArea = JSONUtils.getInt("isInAvailableArea", result);
                        newAppConfiguration.umengAppKey = Utils.getNotNullString(JSONUtils.getString("umengAppKey", result).trim(), appConfiguration.umengAppKey);
                        newAppConfiguration.umengAppSecret = Utils.getNotNullString(JSONUtils.getString("umengMessageSecret", result).trim(), appConfiguration.umengAppSecret);
                        newAppConfiguration.codepushServerUrl = Utils.getNotNullString(JSONUtils.getString("codePushServerUrl", result).trim(), appConfiguration.codepushServerUrl);
                        newAppConfiguration.codepushKey = Utils.getNotNullString(JSONUtils.getString("codePushKey", result).trim(), appConfiguration.codepushKey);
                        newAppConfiguration.channel = Utils.getNotNullString(JSONUtils.getString("channelId", result).trim(), appConfiguration.channel);
                        newAppConfiguration.jpushAppKey = Utils.getNotNullString(JSONUtils.getString("jpushAppKey", result).trim(), appConfiguration.jpushAppKey);
                        Paper.book().write(APP_CONFIGURATION, newAppConfiguration);
                        boolean restarted = restartAppIfNeed(newAppConfiguration);
                        if (!restarted) {
                            reloadAppConfigIfNeed(newAppConfiguration);
                        }
                        stopSelf();
                    }
                }
            }
        });
    }

    private boolean reloadAppConfigIfNeed(AppConfiguration newAppConfiguration) {
        if (!TextUtils.equals(appConfiguration.codepushKey, newAppConfiguration.codepushKey) ||
                !TextUtils.equals(appConfiguration.codepushServerUrl, newAppConfiguration.codepushServerUrl) ||
                !TextUtils.equals(appConfiguration.umengAppKey, newAppConfiguration.umengAppKey) ||
                !TextUtils.equals(appConfiguration.umengAppSecret, newAppConfiguration.umengAppSecret) ||
                !TextUtils.equals(appConfiguration.jpushAppKey, newAppConfiguration.jpushAppKey) ||
                !TextUtils.equals(appConfiguration.channel, newAppConfiguration.channel)) {
            // reload configuration
            ((MainApplication) getApplication()).config();
            return true;
        }
        return false;
    }

    private boolean restartAppIfNeed(AppConfiguration newAppConfiguration) {
        if (appConfiguration != null && newAppConfiguration != null) {
            int oldReviewStatus = (appConfiguration.reviewStatus == Constants.ReviewStatus.UNKNOWN ||
                    appConfiguration.reviewStatus == Constants.ReviewStatus.NOT_REVIEWED) ?
                    Constants.ReviewStatus.NOT_REVIEWED : Constants.ReviewStatus.REVIEWED;
            int newReviewStatus = (newAppConfiguration.reviewStatus == Constants.ReviewStatus.UNKNOWN ||
                    newAppConfiguration.reviewStatus == Constants.ReviewStatus.NOT_REVIEWED) ?
                    Constants.ReviewStatus.NOT_REVIEWED : Constants.ReviewStatus.REVIEWED;
            boolean hasReviewChanged = oldReviewStatus != newReviewStatus;
            boolean hasAreaChanged = appConfiguration.isInAvailableArea != newAppConfiguration.isInAvailableArea;
            if (hasReviewChanged || hasAreaChanged) {
                toastLong("配置更新，应用将在三秒后重启，感谢您对平台的支持！");
                restartApp();
                return true;
            }
        }
        return false;
    }

    private void restartApp() {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Utils.restartApp(ConfigurationService.this);
            }
        }, 3000);
    }

    private void toastLong(final String message) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(ConfigurationService.this.getApplicationContext(), message, Toast.LENGTH_LONG).show();
            }
        });
    }
}
