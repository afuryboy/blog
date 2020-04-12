---
title: mockjs入门
tag: mockjs
date: 2020-04-12 15:12:27
tags:
---



# 使用场景
> 前端开发经常会遇见后端接口延期的情况，这个时候我们需要给自己造接口和数据。方法有很多种，今天推荐mockjs,作者是《jQuery 技术内幕》作者 高云墨智

# 下载

```ssh
yarn add mockjs
```

# 使用

- 首先你需要注册接口

// mock.js

```js
 import Mock from 'mockjs'
 import data from './data' //自定义数据

 // 注册接口
 Mock.mock('/api/sendlist',{
    code: 0,
    data: data.sendlist
 })
```
> 数据的话可以是你自定义也可以是mock帮你随机生成。

如上代码所示，自定义数据的话我引入data.js

```js
const data = {
    sendlist:[{
        name:'111'
    },{
        name:'222'
    },{
        name:'333'
    }]
}

export default data
```
- 在入口文件引入mock.js
```js
import Vue from 'vue'
import App from './view/App'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import './mock' //引入mock
require('./assets/css/style.css')
Vue.config.productionTip = false
Vue.use(ElementUI)

new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
})

```

- request库使用mock注册过的接口
```js
axios.get('/api/sendlist').then(res=>{
        console.log(res.data) 
})
```
> mockjs会拦截ajax请求

# 随机数据

  前面讲到mockjs可以使用自定义数据也可以随机数据，而且随机数据也是mockjs的唯二的特点，另外一个就是拦截ajax.

  具体使用可以自行上github上查看其[文档](https://github.com/nuysoft/Mock/wiki)

# 简单列举一下mockjs里面常用的几个方法
  
 - Mock.mock(rurl, rtype, template)

  记录数据模板。当拦截到匹配 rurl 和 rtype 的 Ajax 请求时，将根据数据模板 template 生成模拟数据，并作为响应数据返回

 或者

 - Mock.mock( rurl, rtype, function( options ) )

 记录用于生成响应数据的函数。当拦截到匹配 rurl 和 rtype 的 Ajax 请求时，函数 function(options) 将被执行，并把执行结果作为响应数据返回。

 - Mock.setup( settings )

 配置拦截 Ajax 请求时的行为。支持的配置项有：timeout。

 - Mock.Random 

 Mock.Random 是一个工具类，用于生成各种随机数据。

Mock.Random 的方法在数据模板中称为『占位符』，书写格式为 @占位符(参数 [, 参数]) 。


# 参考资料
[mockjs文档](https://github.com/nuysoft/Mock/wiki)