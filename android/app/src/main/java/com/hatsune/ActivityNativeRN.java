package com.hatsune;

import com.facebook.react.ReactActivity;

public class ActivityNativeRN extends ReactActivity {

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return BuildConfig.SHELL_RN_COMPONENT_NAME;
    }

    public void onResume() {
        super.onResume();
    }

    public void onPause() {
        super.onPause();
    }
}
