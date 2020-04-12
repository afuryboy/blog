---
title: git-commit规范之项目实践
tag: git
---


<h1 align="center">git commit 规范</h1>

# 主要依赖和工具

[commitlint](https://github.com/conventional-changelog/commitlint)
Lint commit messages; 简单说就是校验你的commit信息是否规范


[Commitizen](https://github.com/commitizen/cz-cli)
一个命令工具, 主要使用git-cz 来提供commit模版

[husky](https://github.com/typicode/husky)
一个git hooks包,可以在不同的git周期做不同的事



<h2 align="center">Commitizen</h2>


step1:

下载命令工具

```bash
npm install commitizen -g
```

step2:

初始化工程

```bash
commitizen init cz-conventional-changelog --yarn --dev --exact
```
![description](1.png)

在`package.json`中产生的变化

上面的操作如果都成功的话，那么项目中就可以使用 `git-cz` 命令，
![](7.png)

或者 `yarn commit` 命令来取代 `git commit` 命令了。
![](2.png)

但是不足的是：

- 1、项目中依旧可以继续使用 git commit 命令来提交不规范的信息，很可能项目中的同事会忘记，导致继续使用 git commit 来提交代码。

- 2、图片中可以发现，有些 commit 信息首字母大写，有些 commit 信息首字母小写，所以并不能强制要求大小写的规范。


<h2 align="center">commitlint 使用</h2>

step1:

安装相关依赖

```bash
yarn add @commitlint/config-conventional @commitlint/cli --dev
```
![](3.png)

step2:

创建配置文件commitlint.config.js

```js
module.exports = {
  extends: ['@commitlint/config-conventional']
};
```

>类似于 eslint，commitlint 还支持类似于 .commitlintrc.js、.commitlintrc.json、.commitlintrc.yml 名称的配置文件，又或者在 package.json 中添加 commitlint 字段。

[更多 rules 配置，请查看：](https://commitlint.js.org/#/reference-rules)

step3:

在 package.json 中配置 husky 钩子：

```bash
npm install husky --save-dev
```

```js
{
  "husky": {
    "hooks": {
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
}
```
上面的操作如果都成功的话，那么你使用 git commit 命令时

![](5.png)

到这就已经完成了,可以拦截你的git commit命令,而且如果你需要commit模版,你可以使用

```bash
git-cz
```

或者

```json
  "scripts": {
    "commit": "git-cz"
  },
```
```bash
yarn commit
```



# 其他工具

[gitmoji](https://github.com/carloscuesta/gitmoji-cli)
`gitmoji` 跟 `Commitizen` 有点类似.
是一个交互式命令工具,可以在commit 提交时带上 `emoji`

![](6.png)

```bash
npm i -g gitmoji-cli
```

# 注意事项:

如果git hook不生效,可能跟你的npm版本有关, 我最初实践的时候遇到过这个问题,做了npm升级之后就解决了.

# 参考资料

[Git Commit 规范参考](https://github.com/XXHolic/blog/issues/16)

[Commit message 和 Change log 编写指南](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)

[优雅的提交你的 Git Commit Message](https://juejin.im/post/5afc5242f265da0b7f44bee4)

[Git 的学与记：工程化配置 commit 规范](https://juejin.im/post/5be414c46fb9a049fa0f4052)
