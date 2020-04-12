---
title: npm-link 命令详解
tag: npm 
---


# 使用场景
> 开发NPM模块的时候，有时我们会希望，边开发边试用，比如本地调试的时候，require('myModule')会自动加载本机开发中的模块。Node规定，使用一个模块时，需要将其安装到全局的或项目的node_modules目录之中。对于开发中的模块，解决方法就是在全局的node_modules目录之中，生成一个符号链接，指向模块的本地目录。npm link就能起到这个作用，会自动建立这个符号链接。

```shell
sudo npm link //本地包根目录执行
```
执行完命令之后npm会提示

>/usr/local/bin/test1 -> /usr/local/lib/node_modules/test-command/bin/test.js
/usr/local/lib/node_modules/test-command -> /Users/qiankun/qk/test/test-command

> 上面npm告诉你，你执行test1命令，实际就是执行全局包test-command下面/bin/test.js。而全局的test-command包的路径实际指向的就是你本地开发的test-command项目路径

```shell
cd /usr/local/lib/node_modules   //npm全局安装包的路径,⚠️颜色不同

ls
```
蓝色的是npm i -g的形式下载的，紫色的是在本地项目执行npm link

npm link 命令生成一个软链接指向你本地。（这个链接实际就是包含你本地项目位置信息的文件，类似window快捷方式）

你可以直接打开这些全局包

```shell
atom/code test-command   //你打开的就是你实际本地的地址
```

所以你在你本地修改的就是全局的修改。

所以这对你还在测试阶段的包就很有帮助了，不需要以

```shell
node bin/xxx.js  //如果你的脚本依赖一些命令参数，就无能为力了
```
这对cli工具类确实很有帮助，可以直接模拟实际执行命令的场景。

# 你可能会遇到的问题

在使用的过程中还可能遇到过这样的一个问题

你执行了npm link 之后没有反应。没错，我就遇到了这样。😅略尴尬！（我猜测 可能跟我用编辑器打开的终端有关。因为偶尔表现出来的行为跟你用item2打开不一样。）

没事，如果一条命令解决不了的事，那你就再执行一次。

等你测试结束，你就可以执行

```shell
    npm unlink    //解除全局软链接
```


 ⚠️ npm link 、npm unlink执行的地方总是在你本地包的根目录




# 参考资料
[npm 官方解释](https://docs.npmjs.com/cli/link)

[阮一峰](http://javascript.ruanyifeng.com/nodejs/npm.html#toc18)

