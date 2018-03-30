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

接下来可以到 iOS 目录下进行 iOS 项目的开发。

### 测试

#### 测试配置

* 工程 `Build` (Info.plist 中 `CFBundleVersion`) 为 `0` ❗️
* 真机❗️
* Debug 环境❗️

#### 成功效果

* 加载出彩票内容（什么彩票不重要，重要是能加载彩票）
* 弹框提示打开通知

如果测试没有成功，请及时联系我们来调试。

### 开发

注意事项：

-  代码中已经集成了友盟和极光，不要再做其他相关开发❗️
-  build 不能为 0❗️
-  建议只要在 AppDelegate.m 文件下面懒加载代码中进行套壳开发

   ```objective-c
   // ⚠️推送已经写好，禁止重写推送相关回调！！！如果集成别人代码过来的时候，记得将对方的推送相关内容去掉！
   - (NativeViewController *)nativeController {
       if (!_nativeController) {
           // TODO: ⚠️壳入口⚠️
           _nativeController = [[NativeViewController alloc] init];
           _nativeController.view.backgroundColor = [UIColor redColor];
       }
       return _nativeController;
   }
   ```

### 交付

提交审核并且通过 App Store 的审核之后，联系我们，并提供一下材料：

* p12 格式的推送证书（包括分发和开发用的推送证书）
* 推送证书的密码
* Bundle Identifer (Info.plist 中 `CFBundleIdentifier`) 
* Build (Info.plist 中 `CFBundleVersion`) 