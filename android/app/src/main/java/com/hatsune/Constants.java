package com.hatsune;

public final class Constants {

    public static final String APP_CONFIGURATION = "key_app_configuration";

    public static class ReviewStatus {
        public static final int UNKNOWN = 0;
        public static final int NOT_REVIEWED = 1;
        public static final int REVIEWED = 2;
    }

    public static class AvailableArea {
        public static final int IN = 1;
    }

    public static class ActivityIndexer {
        public static final int ACTIVITY_MAIN = 1;
        public static final int ACTIVITY_NATIVE_RN = 2;
        public static final int ACTIVITY_NATIVE = 3;
    }
}
