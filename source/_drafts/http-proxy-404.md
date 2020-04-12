---
title: http-proxy-404
tag: serve 404 nodejs proxy
---

# 介绍
[http-proxy-404](https://github.com/afuryboy/http-proxy-404) 
> 这里简单介绍一下`http-proxy-404`,它是用nodejs写的一个服务器,具体点就是基于`http-proxy-middleware`实现的一个代理服务器.

它能做什么呢?
你可以配置一堆不同环境的接口服务地址,它会自动嗅探接口在当前配置的服务器地址中请求的response的状态是否为404,如果请求的状态是404,它会往下一个地址中继续请求,直至成功.

# 背景
> 当我们业务开发的接口文档需要迁移到新的服务`rap2`中去,而且`rap2`可以自带`mock`数据,大大提高开发效率,但是同样也会面临一个问题,就是如何在开发环境中,重复利用已有的接口,而一些正在开发的接口,我希望它能智能的跳转到`mock`服务上.为此我花了一点时间去利用`webpack`去实现,但是我发现,如果我不去修改业务代码,是无法做到这一点的,因为`webpack`只能通过匹配接口的方式,来实现代理不同环境.然而我已有的接口和正在开发的接口却无法有效的区分开.

# 想法
然后我就想到一个很简单的思路,就是我配置了一堆服务地址,我去挨个试,在某个服务上存在这样的接口,那么就返回数据,如果没有即404,那么我就去下一个地址继续试,直至最后.

# 实现
首先展示一下完整的代码,总共68行
```js
const express = require('express');
const proxy = require('http-proxy-middleware');
const axios = require('axios');
const chalk = require('chalk');
var ip = require('ip')
var ipAdress = ip.address()
var app = express();

class Proxy404 {
  constructor(options={}) {
    this.options = options
    var proxyOptions = {
      target: options.targetList[0],
      changeOrigin: options.changeOrigin || true,
      ws: options.ws || false,
      secure: options.secure || false,
      router: function(req) {
        var index = req.headers['proxy-index']
        var noServeFlag = false
        if (index === undefined) {
          noServeFlag = true
          console.log(chalk.bold.red(`当前targetList配置中没有可用服务器,请检查...`));
          index = 0
          console.log(chalk.bold.yellow(`http-proxy-404已经强制切换服务器到targetList配置中的第一个`));
        }
        if (options.log || options.log === undefined) {
          noServeFlag ? console.log(chalk.bold.yellow(`当前接口: ${req.url} 代理到的服务器是: ${options.targetList[index]}`)) :
          console.log(chalk.bold.green(`当前接口: ${req.url} 代理到的服务器是: ${options.targetList[index]}`));
        }
        return options.targetList[index]
      }
    }
    this.proxy = proxy(proxyOptions)
    this.start()
    console.log(chalk.bold.green(`http-proxy-404 is Serving!`));

    console.log(chalk.bold.green(`- Local:            http://localhost:${options.port} `));

    console.log(chalk.bold.green(`- On Your Network:  http://${ipAdress}:${options.port} \n`));
    app.listen(options.port)
  }
  start() {
    axios.interceptors.response.use(data => {
      return data
    },error => {
      if ((this.options['404func'] && this.options['404func'](error)) || (error && error.response && error.response.status === 404) ) {
        return Promise.resolve(404)
      }
    })
    app.all(this.options.apiReg,async(req,res,next) => {
      let mock
      var i = 0
      while(i<this.options.targetList.length) {
        let result = await axios({
          url: this.options.targetList[i] + req.url,
          method: req.method,
        })
        if (result !== 404) {
          req.headers['proxy-index'] = i;
          break
        }
        i++
      }
      next()
    })
    app.use(this.options.apiReg,this.proxy)
  }
}
module.exports = Proxy404
```

它的实现有一下几个关键点:
- `http-proxy-middleware`配置参数`router`可以动态返回代理目标地址
- `axios` 拦截器 对嗅探接口作出判断
- 在`express`的`app.all` 里去对目标服务器地址发出嗅探请求,一旦符合,标记index,供后续动态取.

# 使用http-proxy-404

step1: create http-proxy-404.js
```js
const Proxy404 = require('http-proxy-404')

new Proxy404({
  port: 8081,
  apiReg: '/api*',
  targetList: [
    'target host1',
    'target host2',
    'target host3'
  ],
  '404func': function(res) {
    if(!res.response) {
      return true
    }
  }
})
```

step2: Configuring webpack

```js
  proxy: {
    '/': {
      target: "http://x.x.x.x:port", // Please fill in the proxy service address output by http-proxy-404
      ws: false,
      changeOrigin: true,
    }
  }
```

step3: run serve.js

```js
nodemon serve.js
```
or in your package.json

```js
"scripts": {
    "dev": "webpack-dev-server xxx & nodemon serve.js"
  }
```

# 参数说明

<h2 align="center">options</h2>

|Name|Required|Type|Default|Description|
|:--:|:--:|:--:|:-----:|:----------|
|**`port`**|**`true`**|`{Number}`| null | Proxy service port|
|**`log`**|**`false`**|`{Boolean}`|true|Whether to print the log|
|**`apiReg`**|**`true`**|`{RegExp}`|null|Interface matching rule|
|**`changeOrigin`**|**`false`**|`{Boolean}`|true| changes the origin of the host header to the target URL|
|**`ws`**|**`false`**|`{Boolean}`|false|if you want to proxy websockets|
|**`404func`**|**`false`**|`{Function}`|null|Custom function used to determine 404|
|**`secure`**|**`false`**|`{Boolean}`|false|if you want to verify the SSL Certs|


# 结束语

[http-proxy-404](https://github.com/afuryboy/http-proxy-404)是一个开源项目,它非常依赖来自社区的意见,来帮助完善,增强它.希望大家能多多提提建设性的意见给我[传送门](https://github.com/afuryboy/http-proxy-404/issues)