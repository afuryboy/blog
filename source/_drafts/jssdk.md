---
title: 通用型jssdk设计
tag: js-sdk typescript webpack
---

# 背景
> 因业务驱动需要开发特定功能的js sdk以供第三方使用，调研期间发现关于这方面的文章不是很多，然后呢根据调研期间的文章查阅以及自己在对js sdk设计理念以及注意事项方面的思考沉淀，总结出这一篇文章。如有不正确的地方欢迎大家指出。

# 什么是sdk

`sdk`(Software Development Kit) 翻译 => 软件开发工具包

  ## js sdk
  通常就是一个js脚本，用外链的形式加入到你页面中去实现一个特定的功能（这个功能是具有相对完整性）

  比如：我们经常会使用百度统计的js sdk去统计用户流量分析、阿里验证码js sdk去实现登录时随机生成验证码等。

# 如何开发js sdk
> 俗话说万事开头难

  ## 调研、借鉴
  当开发人员对一项技术不熟悉甚至陌生的时候，要做的第一件事就是google去查。

  这里我首先做的事，不是着急写代码，而是搞明白我到底要做的是个什么东西？需要做什么？需要注意哪方面？

  ### 百度统计sdk
  // 用户代码
  ![code](baidu.png)

  ### 腾讯统计sdk
  // 用户代码
  ![code](tencent.png)

  通过以上2张图片我们可以发现一些极为相似的代码都是动态的创建一个`script`标签然后插入一个父级节点。

  这样设计的理由主要原因：

  异步，这样动态创建的script脚本不会影响宿主页面的加载，它是最后执行的js。
  
  # 设计思路

  ## 1、引入方式
  
  前面提到了异步加载的方式，用户使用一小段代码，引入正真的sdk，做到小牵大，动拖静。

  ## 2、用户代码

  用户植入的代码，需要后端根据不同用户生成。

  ![code](demo.png)

  在这里可以控制版本号、添加v或者t这样的参数来解决缓存问题
  ```
  let t = new Date().getTime()
  s.src = 'http://wwww.xxx.com/v1/app.js?t=' + t 
  ```
  ## 3、核心业务

  这个cdn所指的js其实就是实际的sdk,开发完成业务功能之后部署到cdn即可。

  ## 4、注意事项

  (1)、跨域问题
  这里我总结了一下：

  第三方可能是http或者https,  
  http（第三方） -> https/http（sdk发的请求）(跨域了，实现cors应该没啥问题。)

  https（第三方）-> http（sdk发的请求）(浏览器会block这个请求）

  https（第三方）-> https（sdk发的请求）(cros跨域解决）

  (2)、安全问题

  sdk不能影响宿主:

  不能影响宿主的页面和功能（主观上可以忽略）、我不能影响宿主的css（保不准，意外的副作用，没发现到）不能影响宿主页面的性能。

  宿主不能影响sdk:

  你的sdk可能会渲染一些东西到界面上，在这种情况下，你需要注意宿主的css的影响。使用Shadow dom\custom element是可以解决(但是兼容性不太好) 。最好的解决方案，是`BEM` + 标签属性重置的方式。
  ```
  // 使用all 对标签属性重定义，避免宿主css通过继承影响到sdk的样式

  #STAD_wrapper, #STAD_wrapper div, #STAD_wrapper img {
    all: initial;
  }
  ```
  ## 更多

  包括埋点设计、数据定义、测试等等需要你考虑的问题。

# 参考资料
[http://sdk-design.js.org/](http://sdk-design.js.org/)

[JavaScript sdk(jssdk)设计指南](https://js8.in/2016/06/29/javascript%20sdk(jssdk)%E8%AE%BE%E8%AE%A1%E6%8C%87%E5%8D%97/)

[JavaScript SDK设计指南](https://www.zcfy.cc/article/530?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)