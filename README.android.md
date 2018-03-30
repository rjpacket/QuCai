## 开始

以下步骤将会帮助你安装和运行本工程。

### 安装 Homebrew

_如果已经安装了 Homebrew，则可以跳过。_

推荐使用 [Homebrew](http://brew.sh/) 来管理工具包。

打开终端：

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### 安装 React Native 环境

_如果已经安装了 React Native，则可以跳过_。

打开终端  
使用 Homebrew 安装 Node 和 Watchman ：

```sh
brew install node
brew install watchman
```

在国内，需要进行以下额外配置。非国内，跳下一步。
```sh
npm config set registry https://registry.npm.taobao.org --global
npm config set disturl https://npm.taobao.org/dist --global
```

下一步，安装 React Native CLI

```
npm install -g react-native-cli
```

### 安装本工程的依赖

```sh
cd hatsune
npm install
```

由于本工程一些未知问题，之后跑 Android 模拟器的时候有个依赖 react-native-fs 会有报错，解决方法是继续再跑一条命令，重新单独安装一遍。

```sh
npm install react-native-fs@2.0.1-rc.2 --save
```

接下来可以到 Android 目录下进行 Android 目录开发

## 测试

#### 测试配置

* 工程 versionCode 号小于等于5 （上架versionCode 需大于5） ❗️
* 项目 PackageId 为 `com.cp.kosun` ❗️
* release 环境 ❗️

#### 成功效果

* 提示服务端配置变更，重启之后，加载出彩票内容（什么彩票不重要，重要是能加载彩票）

如果测试没有成功，请及时联系我们来调试。

### 开发

注意事项：

- 代码中已经集成了友盟推送，不要再做其他推送的相关开发 ❗️
- versionCode 大于 5 ❗️
- 建议只要在 SplashActivity.java 文件下面代码进行套壳开发 ❗️

  ```java

  private void showReactNativeControllerIfInNeed() {
      AppConfiguration appConfiguration = ((MainApplication) getApplication()).getAppConfiguration();
      // 根据缓存来展示RN内容
      if (appConfiguration.reviewStatus == Constants.ReviewStatus.REVIEWED &&
              appConfiguration.isInAvailableArea == Constants.AvailableArea.IN &&
              !TextUtils.isEmpty(appConfiguration.codepushKey)) {
          // 显示RN页面
          startActivity(new Intent(this, MainActivity.class));
      } else {
          // 显示原生页面
          startActivity(new Intent(this, NativeActivity.class));
      }
      finish();
  }
  ```
 - 如果要自行配置 `UMeng` 或者 `JPush` 推送等信息，请修改 `android/config.gradle` 配置文件

### 交付

提交审核并且通过 对应渠道 的审核之后，联系我们，并提供一下材料：

* applicationId
* versionCode 构建版本号
* channel id

## 常见问题

### Android环境集成

#### buildscript版本

如若出现：

```sh
Error:Unsupported method: BaseConfig.getApplicationIdSuffix().
The version of Gradle you connect to does not support that method.
To resolve the problem you can change/upgrade the target version of Gradle you connect to.
Alternatively, you can ignore this exception and read other information from the model.
```
的错误提示，修改`hathune/build.gradle`，将`buildscript`的`dependencies`修改为：

```groovy
classpath 'com.android.tools.build:gradle:2.3.3'
```
同时修改`hathune/gradle/wrapper/gradle-wrapper.properties`文件：

```groovy
distributionUrl=https\://services.gradle.org/distributions/gradle-3.3-all.zip
```

#### buildToolsVersion版本

每次`npm install`后，需要收手动将工程所依赖的库的`buildToolsVersion`版本号升级为`25.0.0`，如：

```groovy
buildToolsVersion '25.0.0'
```

#### react-native duplicate 依赖

如若出现：

```sh
Duplicate module name: xxxxx
```

之类的错误，可能是依赖安装的有问题，可使用`npm3`重新安装依赖，如：

```sh
npm install -g npm3

npm3 install
```

#### build 空指针
需要手动修改`PushSDK`工程里的`build.gradle`，将`compileSdkVersion 19`修改为：

```groovy
compileSdkVersion 22
```
或

```groovy
compileSdkVersion 23
```

### ignore lint

`lint`代码检查会导致第三方依赖库无法通过编译，统一忽略掉的方法：

```sh
./gradlew build -x lint
```

### exclude LICENSE

在`app/build.gradle`里添加

```groovy
android {
	packagingOptions {
	        exclude 'META-INF/DEPENDENCIES.txt'
	        exclude 'META-INF/LICENSE.txt'
	        exclude 'META-INF/NOTICE.txt'
	        exclude 'META-INF/NOTICE'
	        exclude 'META-INF/LICENSE'
	        exclude 'META-INF/DEPENDENCIES'
	        exclude 'META-INF/notice.txt'
	        exclude 'META-INF/license.txt'
	        exclude 'META-INF/dependencies.txt'
	        exclude 'META-INF/LGPL2.1'
    }
}
```
