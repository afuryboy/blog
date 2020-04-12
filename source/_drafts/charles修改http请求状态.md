---
title: charles 修改http请求的两种方法
tag: charles
---

# 应用场景

> 前端在调试后端的一个接口时，正常情况下，接口status返回的是200, 有的时候我们需要验证其他的status时，比如：500，这种场景，其实是无法在前端代码中去实现的。这个时候我们就需要用到 charles去代理我们的请求。通过charles去改变接口的status，下面我就讲一下两种我测试用过的方法。

# 方法一：利用Map Remote功能

 首先你需要在你接口右键点击Map Remote

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/master/projects/blog/f052bc992474847868c453db23a49017.png)

 点击之后你看到的应该是如下图所示

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/master/projects/blog/d3869f2c0bd06b26da7eb86319562101.png)

 你需要设置接口map to到另外一个你mock出来的接口

 比如：我在[https://www.mocky.io/](https://www.mocky.io/) 去mock 了一个接口

 如图所示：

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/master/projects/blog/3f43cc6819bc18008778f71179991223.png)

 你只需要设置Status Code 为你想要的状态码，我这里是设置500，点击按钮，就会在上方生成一个绿色链接的接口。用这个得到的接口复制粘贴到charles的Map Remote窗口即可。

 到这一步配置就已经完成，可以测试了。当你访问接口就会得到status为500的Response。


# 方法二：利用Breakpoints功能

 首先同样需要接口右键找到Breakpoints选项。

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/master/projects/blog/341acab2f243c56a7985444fd03201f2.png)

 之后你就可以正常发出请求，会自动跳转charles窗口

 如下图所示：
 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/3e7dd62f8bc269078b4cc06fdab621b299309dd0/projects/blog/406120685bd1f29916a0b2ad51ca2da2.png)

 这是发出的request请求，你可以edit request,也可以忽略这一步，点击Execute直接进入下一步。

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/3e7dd62f8bc269078b4cc06fdab621b299309dd0/projects/blog/8333ed9063f74aa75c36b9c947fa49dd.png)

 这是返回的response, 我们点击Edit Response

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/3e7dd62f8bc269078b4cc06fdab621b299309dd0/projects/blog/b00c46318e071d4085c00fa3ffd8fbc2.png)

 修改status 200为500
 
 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/3e7dd62f8bc269078b4cc06fdab621b299309dd0/projects/blog/a46c5e94ddd152373040d45ffb246024.png)

 点击Execute直接进入下一步,这个时候我打开浏览器控制台发现接口已经返回500了。

 ![](https://raw.githubusercontent.com/afuryboy/picture-serve/3e7dd62f8bc269078b4cc06fdab621b299309dd0/projects/blog/e1195a5c710c26ace0983e428c6627a8.png)

