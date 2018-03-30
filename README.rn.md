### 准备

以下步骤将会帮助你安装和运行本工程。

#### 安装 Homebrew

_如果已经安装了 Homebrew，则可以跳过。_

推荐使用 [Homebrew](http://brew.sh/) 来管理工具包。

打开终端：

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### 安装 React Native 环境

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

#### 安装本工程的依赖

```sh
cd hatsune
npm install
```

### React Native 套壳
接入时，请添加你们的依赖包到我们的基础包中。  
由于本工程使用 `codepush` 进行升级更新，如果你本身是 RN 进行开发，需要提前告知我们，并告诉我们你的应用上架信息。需要注意：

**无使用`codepush`进行动态升级**  
自行修改本地的 js 代码（`app目录`），注意不可删除 `codepush` 升级逻辑，如果过审之后，我们会在后台开启更新，将应用更新为我们需要的。

**需配置CodePush升级**
自行修改本地客户端的 `codepush key`，注意需按照下方提供的文件位置进行修改。应用过审之后，我们会在后台开启更新，将`codepush key` 更新为我们需要的。  
1. `android` 修改 `android/config.gradle` 文件下的 `localRN` 配置。
2. `iOS` 修改 `ios/hatsune/AppDelegate.m` 文件下的 `customizeActionBeforeConfig` 方法，注意需取消注释。
3. 配置完成之后，需要在 `index.android.js` 和 `index.ios.js` 中添加所要注册的 `component`。

**通过RN开发的基础壳，一旦上架，无法进行IP屏蔽，请知悉！！！**

### android

#### 测试配置

- 工程 versionCode 号小于等于5 （上架versionCode 需大于5） ❗️
- 项目 PackageId 为 `com.cp.kosun` ❗️
- release 环境 ❗️

#### 成功效果

- 提示服务端配置变更，重启之后，加载出彩票内容（什么彩票不重要，重要是能加载彩票）

如果测试没有成功，请及时联系我们来调试。

#### 开发

注意事项：

- 代码中已经集成了友盟推送，不要再做其他推送的相关开发 ❗️
- versionCode 大于 5 ❗️

### iOS

#### 测试配置

* 工程 `Build` (Info.plist 中 `CFBundleVersion`) 为 `0` ❗️
* 真机❗️
* Debug 环境❗️

#### 成功效果

* 加载出彩票内容（什么彩票不重要，重要是能加载彩票）
* 弹框提示打开通知

如果测试没有成功，请及时联系我们来调试。

#### 开发

注意事项：

-  代码中已经集成了友盟和极光，不要再做其他相关开发❗️

-  build 不能为 0❗️

-  由于极光 SDK 的问题，在模拟器 Debug 会报错，如果需要使用 Release，请使用真机

-  在 `ios/hatsune/AppDelegate.m` 中配置好 RN套壳 所需相关参数  
   ```objective-c
   // 如果壳是通过RN开发，请在此方法下做好配置
   - (void)customizeActionBeforeConfig {
       Configration *config = [Configration sharedInstance];
       config.usingReactNativeShell = NO; // 是否使用RN开发的壳
       if (config.usingReactNativeShell) {
               config.customizedReactNativeModuleName = @"module name"; // reactnative module name
           
           BOOL isShellUsingCodePush = NO; // RN是否使用CodePush来加载
           if (isShellUsingCodePush) {
               config.customizedAppVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
               
   //            config.customizedCodePushKey = @"deployment key"; // CodePush的deployment key
   //            config.customizedCodePushServerUrl = @"server url"; // CodePush的server地址，注释掉即采用官方提供的地址
   //            config.customizedAppVersion = @"1.0.0"; // 让CodePush强制匹配对应的版本
           }
       }
   }
   ```

### 交付

提交审核并且通过 App Store 的审核之后，联系我们，并提供一下材料：

* p12 格式的推送证书（包括分发和开发用的推送证书）
* 推送证书的密码
* Bundle Identifer (Info.plist 中 `CFBundleIdentifier`)
* Build (Info.plist 中 `CFBundleVersion`)
