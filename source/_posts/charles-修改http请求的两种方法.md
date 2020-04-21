title: charles 修改http请求的两种方法
author: Afuryboy
tags:
  - charles
categories:
  - 测试
  - charles
date: 2020-04-21 20:12:00
---
# 应用场景

> 前端在调试后端的一个接口时，正常情况下，接口status返回的是200, 有的时候我们需要验证其他的status时，比如：500，这种场景，其实是无法在前端代码中去实现的。这个时候我们就需要用到 charles去代理我们的请求。通过charles去改变接口的status，下面我就讲一下两种我测试用过的方法。

# 方法一：利用Map Remote功能

 首先你需要在你接口右键点击Map Remote

 1.png
![upload successful](/blog/images/pasted-1.png)

 点击之后你看到的应该是如下图所示

 2.png
![upload successful](/blog/images/pasted-2.png)

 你需要设置接口map to到另外一个你mock出来的接口

 比如：我在[https://www.mocky.io/](https://www.mocky.io/) 去mock 了一个接口

 如图所示：

 3.png
![upload successful](/blog/images/pasted-3.png)

 你只需要设置Status Code 为你想要的状态码，我这里是设置500，点击按钮，就会在上方生成一个绿色链接的接口。用这个得到的接口复制粘贴到charles的Map Remote窗口即可。

 到这一步配置就已经完成，可以测试了。当你访问接口就会得到status为500的Response。


# 方法二：利用Breakpoints功能

 首先同样需要接口右键找到Breakpoints选项。

 4.png
![upload successful](/blog/images/pasted-4.png)
 之后你就可以正常发出请求，会自动跳转charles窗口

 如下图所示：
 5.png
![upload successful](/blog/images/pasted-5.png)

 这是发出的request请求，你可以edit request,也可以忽略这一步，点击Execute直接进入下一步。

 6.png
![upload successful](/blog/images/pasted-6.png)
 这是返回的response, 我们点击Edit Response

 7.png
![upload successful](/blog/images/pasted-7.png)
 修改status 200为500
 
 8.png
![upload successful](/blog/images/pasted-8.png)

 点击Execute直接进入下一步,这个时候我打开浏览器控制台发现接口已经返回500了。

 9.png
![upload successful](/blog/images/pasted-9.png)