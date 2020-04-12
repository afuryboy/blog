---
title: 从配置了解babel(基础篇)
tag: babel
---

# 前言
> 从基础的配置去了解babel

# 查找行为

Babel 会在正在被转录的文件的当前目录中查找一个 `.babelrc` 文件。 如果不存在，它会遍历目录树，直到找到一个 `.babelrc` 文件，或一个 `package.json` 文件中有 `"babel": {}`

# 配置项

首先我们来看一段`.babelrc`配置,这里的配置选自`vue-cli`初始化`webpack`模版里的默认.babelrc配置

```json
{
  "presets": [
    ["env", {
      "modules": false,
      "targets": {
        "browsers": ["> 1%", "last 2 versions", "not ie <= 8"]
      }
    }],
    "stage-2"
  ],
  "plugins": ["transform-vue-jsx", "transform-runtime"],
  "env": {
    "test": {
      "presets": ["env", "stage-2"],
      "plugins": ["transform-vue-jsx", "transform-es2015-modules-commonjs", "dynamic-import-node"]
    }
  }
}
```

嘿，扫一眼也挺简单的么不是很多嘛😬 , 没错这是最常用的配置选项，`babel` 实际可选配置项有30来个😱.

1、`presets` 预设,一个 babel 插件的数组 （实际跟`plugins`是一个东西，只不过是以集合的形式）

2、`plugins` 插件,需要加载和使用的插件列表

3、`env` 特定环境配置,特定环境的设置项会被合并、覆盖到没有特定环境的设置项中。`env` 选项的值将从 `process.env.BABEL_ENV` 获取，如果没有的话，则获取 `process.env.NODE_ENV` 的值，它也无法获取时会设置为 `"development"`。这个比较好理解，如果 你的环境变量是`test`那么`env`下面的`test`的presets和plugins会和1、2中的presets、plugins合并。


⚠️ `Plugin/Preset` 排序
  - Plugin 会运行在 Preset 之前。
  - Plugin 会从第一个开始顺序执行。ordering is first to last.
  - Preset 的顺序则刚好相反(从最后一个逆序执行)。

# Plugin/Preset 简写

> 如果你使用 babel-plugin- 作为 plugin 的前缀，你可以使用简写的形式省略掉该前缀

# Plugin 和 Preset 配置选项。

> Plugin 和 Preset 均可以通过将名称和选项对象放置在同一个数组中来指定其选项。

  ```js
  {
    "plugins": [
      ["transform-async-to-module-method", {
        "module": "bluebird",
        "method": "coroutine"
      }]
    ]
  }
  ```
  ```js
  {
    "presets": [
      ["es2015", {
        "loose": true,
        "modules": false
      }]
    ]
  }
  ```
具体配置请参考[babel-preset-env配置](https://babeljs.cn/docs/plugins/preset-env/#%E9%80%89%E9%A1%B9)

在没有任何配置选项的情况下，babel-preset-env 与 babel-preset-latest（或者babel-preset-es2015，babel-preset-es2016和babel-preset-es2017一起）的行为完全相同

# transform-runtime
  - 它解决什么问题？

    在[transform-runtime](https://github.com/babel/babel/tree/a10c91790f890d55396c7517aa3dc3f0b8f8aebc/packages/babel-plugin-transform-runtime)文档上开头有这么一句
    
    `Externalise references to helpers and built-ins, automatically polyfilling your code without polluting globals. (This plugin is recommended in a library/tool)`

    翻译过来：外部引用助手和内置插件，自动填充代码而不会污染全局。 （这个插件是在库/工具中推荐的）
    
    实际上 `transform-runtime` 它是配合 `babel-runtime` 实现polyfill 的功能。因为不会像 `babel-polyfill`那样会污染全局作用域，所以适合在第三方的库和插件中使用。
 
    ⚠️ 注意：例如 `"foobar".includes("foo")` 等实例方法将不起作用，因为这需要修改现有的内置插件（此时使用 `babel-polyfill`）

    所以我认为，实际上babel希望第三方的库／工具包使用 `transform-runtime` + `babel-runtime` 去编译代码，保证不会影响到外部。而实际上我们项目中应该还是`babel-polyfill`作为解决方案。

# babel-runtime
  
  - 包括helper 函数模块
    
    Babel 使用了非常小的 helpers 来实现诸如 `_extend` 等常用功能。默认情况下，它将被添加到每个通过 require 引用它的文件中。这种重复（操作）有时是不必要的，特别是当你的应用程序被拆分为多个文件时。

    这时则需要使用 `transform-runtime`：所有的 helper 都会引用模块 `babel-runtime`，以避免编译输出的重复问题。这个运行时会被编译到你的构建版本当中。

  - 内置pollfill插件

    这个转译器的另外一个目的就是为你的代码创建一个沙盒环境。如果你使用了 `babel-polyfill`，它提供了诸如 `Promise`，`Set` 以及 `Map` 之类的内置插件，这些将污染全局作用域。虽然这对于应用程序或命令行工具来说可能是好事，但如果你的代码打算发布为供其他人使用的库，或你无法完全控制代码运行的环境，则会成为问题。

    转译器将这些内置插件起了别名 `core-js`，这样你就可以无缝的使用它们，并且无需使用 `polyfill`。

# babel-polyfill  
  > 它会仿效一个完整的 `ES2015+` 环境，并意图运行于一个应用中而不是一个库/工具。这个 `polyfill` 会在使用 `babel-node` 时自动加载。这意味着你可以使用新的内置对象比如 `Promise` 或者 `WeakMap`, 静态方法比如 `Array.from` 或者 `Object.assign`, 实例方法比如 `Array.prototype.includes` 和生成器函数（提供给你使用 `regenerator` 插件）。为了达到这一点， `polyfill` 添加到了全局范围，就像原生类型比如 `String` 一样。

  - 引入

  ```js
    import "babel-polyfill"; // 如果你在你的应用入口使用 ES6 的 import 语法，你需要在入口顶部通过 import 将 polyfill 引入，以确保它能够最先加载：
  ```
  or 在 `webpack.config.js` 中，将 `babel-polyfill` 加到你的 `entry` 数组中
  ```js
  module.exports = {
    entry: ["babel-polyfill", "./app/js"]
  };
  ```

 ⚠️ 因为这是一个 `polyfill` （它需要在你的源代码之前运行），我们需要让它成为一个 `dependency`, 而不是一个 `devDependency`.
# 参考资料

[babel中文](https://babeljs.cn/)
[阮一峰的Babel 入门教程](http://www.ruanyifeng.com/blog/2016/01/babel.html)