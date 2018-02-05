## Mac平台预览ipa / mobileProvision文件

### ipa预览：
iOS开发中经常会打包生成ipa，提交QA或者提审AppStore。有的时候会有需求想知道ipa包的一些信息，包名，icon，最低支持版本等等。尤其是一个app使用不同证书打出不同的ipa的时候，想要查查某个ipa对应什么证书以及描述文件。那么这个插件可以很好的提供帮助，如下图：

![ipa预览](https://raw.github.com/HanProjectCoder/PreviewHelper/master/Screenshots/preview_ipa.png)

点选ipa文件，按一下空格就能弹出这个预览窗口：上面展示了app的一些信息，还能获取描述文件创建以及过期时间，方便查看是否快要过期，能及时替换。

特别说明一下**Provisioning**栏目下的**Profile Type：**
这个代表证书类型，一共有四种情况：
* `Development` - 开发调试类型描述文件
* `Distribution (Ad Hoc)` - 测试Ad Hoc类型描述文件
* `.Enterprise` -企业账号描述文件
* `Distribution (App Store)` -发布苹果商店描述文件


### mobileProvision描述文件预览：
我们从开发者后台生成的描述文件，下载到电脑上后，双击安装后，其实拷贝到了~/Library/MobileDevice/Provisioning Profiles目录下：

![描述文件安装目录](https://raw.github.com/HanProjectCoder/PreviewHelper/master/Screenshots/profiles.png)

Xcode也是从这个目录读取描述文件，用于让开发者进行选择。可以看到这个文件名是hash过的。这个插件也可以对这个描述文件进行预览：

![描述文件预览](https://raw.github.com/HanProjectCoder/PreviewHelper/master/Screenshots/preview_mobileprovision.png)



### 安装方式：
一.直接运行源码：
下载代码，用xcode打开工程，run成功即可

二.使用release版本的shell部署方式：
1.从github仓库release里面下载installPreviewPlugin.zip:
![安装](https://raw.github.com/HanProjectCoder/PreviewHelper/master/Screenshots/install.png)
2.解压后cd进入installPreviewPlugin目录后，依次执行下面的命令：
```
chmod +x install.sh 
./install.sh
```
看到命令行输出类似下面的语句
```
qlmanage: resetting quicklookd
./PreviewHelper.qlgenerator installed in xxxx/Library/QuickLook/
```
安装成功










