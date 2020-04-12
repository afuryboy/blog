---
title: vuet-cli
tag: nodejs cli vue typescript
---

# 介绍
what is vuet-cli ?
vuet-cli 是一个开箱即用的脚手架命令工具

它有如下几点特点:
- 快速在本地构建一套开发环境
- webpack+vue+typescript(js)开发组合模式
- 支持css、less、sass、styl(us)
- 支持一个项目里集成多个独立的子项目
- 支持热更新
- 支持h5适配(默认支持)

未来它将支持:
- 独立子项目里支持多页`MPA`
- 支持h5适配方案多选
- chunk优化


# 背景
> 因为在团队里对大家多次安利过`typescript`,但是始终没有把`typescript`落地,后来互动h5项目转到我这边开发的时候,我发现这是一个契机,本身互动h5就是一个简单的互动游戏页面,逻辑较为简单,对于加入ts也不会影响开发进度,所以就自己手动搭建一套开发(包含测试生成)环境.结合实际情况互动h5需要开发好几套,在深度挖掘webpack的功能后,发现可以通过`--env`来动态的传递参数,这样就对一套`webpack`配置应对多个h5打包起到了关键作用.后续在`一套配置打包多项目`的思想指导下,不断完善和经验的积累下.有了将这个开发模式做成`cli`的想法.慢慢挤出点时间做成了`vuet-cli`.

# 关于用不用它
其实在现有的vue+ts的cli工具应该有很多,大家用的最多的就是vue官方出的`vue-cli`,其实它的功能已经包括了开发中所面临的绝大多数问题,但是它依然不是完美的.某些业务场景下,依然有它覆盖不到的地方.
如果小伙伴对于`vuet-cli`一点不了解或者没有用它起一个demo看看是怎样的话?那我建议你使用`vue-cli`,如果`vuet-cli`某一个特点让你很喜欢,我建议你试试看.备注一下`vuet-cli`在源码这块很多是借鉴`vue-cli`做出来的,可能会让你有一种山寨的感觉,哈哈没事,只要能解决业务痛点,都不是个事.

# 安装

```bash
npm install vuet-cli -g
```
或者
```bash
yarn global add vuet-cli
```
安装完成之后,你可以使用`vut --version` 来查看是否安装正常

```bash
vut --version
```
需要注意的是: 安装registry最好设置成淘宝的镜像

# 使用

使用`vut create`命令创建项目
```bash
vut create <project-name>
```
![description](model.png)

这一步是选择你的项目是一个单项目还是一个多项目

接着我选择的是`Multi Project`,也就是我希望在这个工程下,能够集成多个子项目

![description](project.png)

我输入的是`app1,@app2` 这里会自动检测子项目的命名是否合法,这里子项目使用逗号`,`分割

![description](ts.png)

这里选择是否支持`typescript`,否的话就只支持`js`

确认完之后,开始了初始化你的项目,安装依赖

![description](install.png)

安装过程`node-sass`可能费点时间,最好提前设置淘宝的镜像

安装成功之后

![description](installsuccess.png)

你可以跟随指示

```bash
cd vuet-app  //工程目录
yarn dev:projectName // 因为你初始化的是多个子项目的工程,这里可以输入你要运行的子项目的名,或者你查看package.json
```

然后项目会自动打开页面
如果你能看到如下图,那么表示你的子项目已运行成功!

![description](welcome.png)

如果你还想运行另外一个项目,你可以继续使用`yarn dev:projectName`

# 结束语

[vuet-cli](https://github.com/afuryboy/vuet-cli)是一个开源项目,它非常依赖来自社区的意见,来帮助完善,增强它.希望大家能多多提提建设性的意见给我[传送门](https://github.com/afuryboy/vuet-cli/issues)