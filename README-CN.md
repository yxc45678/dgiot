# DGIOT

[![GitHub Release](https://img.shields.io/github/release/dgiot/dgiot?color=brightgreen)](https://github.com/dgiot/dgiot/releases)
[![Build Status](https://travis-ci.org/dgiot/dgiot.svg)](https://travis-ci.org/dgiot/dgiot)
[![Coverage Status](https://coveralls.io/repos/github/dgiot/dgiot/badge.svg)](https://coveralls.io/github/dgiot/dgiot)
[![Docker Pulls](https://img.shields.io/docker/pulls/dgiot/dgiot)](https://hub.docker.com/r/dgiot/dgiot)
[![Community](https://img.shields.io/badge/Community-DGIOT-yellow)](https://tech.iotn2n.com)

[English](./README.md) | 简体中文 | [日本語](./README-JP.md) | [русский](./README-RU.md)

*DGIOT*  是国内首款轻量级开源工业物联网持续集成平台

数蛙团队2016年之前，在互联网和移动互联网爬坑多年，2016年开始进入物联网爬坑，希望通过这个开源平台把多年爬坑经验共享出来，让多学科交叉的工业互联网项目变得更简单。
   + 让丰富工程人员可以通过视窗交互可以完成需求较简单的工业互联网项目
   + 让广大的初级前端工程师通过serverless的方式可以承接需求较复杂的工业互联网项目
   + 让Python、Java、Go、C初级后台工程师通过web编程开发通道来承接复杂的工业互联网项目

# 愿景
  数蛙团队希望通过数蛙工业互联网持续集成平台达成下面一些愿景：
  + 通过工程人员、前端工程师、初级后台工程师在不超过1个月的实际完成中小型的工业互联网项目
  + 通过代码开源、软件免费、文档共享、技术认证、产品认证、运维托管等多种方式保证高质量的交付
  + 技术领域专家不断持续集成业界优秀技术框架、业务领域专家不断持续优化业务模型和流程、构建多学科交叉的开放平台
  + 物联网平台最终能够实现简洁易用，回归到工具化的本质

# 构建

 构建 *dgiot* 需要 Erlang/OTP R21+, Windows下用[msys64](https://github.com/dgiot/dgiot_deploy)开发

 +  Linux/Unix/Mac/windows 构建

    ```bash
    git clone https://github.com/dgiot/dgiot.git
    make
    _build/emqx/rel/emqx/bin/emqx console
    ```

*DGIOT* 启动，可以使用浏览器访问 http://localhost:5080 来查看 Dashboard。

- 新功能的完整列表，请参阅 [DGIOT Release Notes](https://github.com/dgiot/dgiot/releases)。
- 获取更多信息，请访问 [DGIOT 官网](https://tech.iotn2n.com/)。
- [安装部署](https://github.com/dgiot/dgiot_deploy)

## 社区

### FAQ

访问 [DGIOT FAQ](https://tech.iotn2n.com/zh/backend/) 以获取常见问题的帮助。

### 问答

[GitHub Discussions](https://github.com/dgiot/dgiot_server/discussions)
[DGIOT 中文问答社区](https://tech.iotn2n.com/)

### 参与设计

如果对 DGIOT 有改进建议，可以向[EIP](https://github.com/dgiot/eip) 提交 PR 和 ISSUE

### 插件开发

如果想集成或开发你自己的插件，参考 [lib-extra/README.md](./lib-extra/README.md)

欢迎你将任何 bug、问题和功能请求提交到 [dgiot/dgiot](https://github.com/dgiot/dgiot/issues)。

### 关于我们
| 联系方式       | 地址                                                                                      |
| -------------- | ----------------------------------------------------------------------------------------- |
| github         | [https://github.com/dgiot](https://github.com/dgiot?from=git)                             |
| gitee          | [https://gitee.com/dgiot](https://gitee.com/dgiiot?from=git)                              |
| 官网           | [https://www.iotn2n.com](https://www.iotn2n.com?from=git)                                 |
| 博客           | [https://tech.iotn2n.com](https://tech.iotn2n.com?from=git)                               |
| 物联网接入平台 | [https://dgiot.iotn2n.com](https://dgiot.iotn2n.com?from=git)                             |
| 公众号         | ![qrcode.png](http://dgiot-1253666439.cos.ap-shanghai-fsi.myqcloud.com/wechat/qrcode.png) |

### 联系我们
你可通过以下途径与 DGIOT 社区及开发者联系:
- [Slack](https://slack-invite.dgiot.com)
- [Twitter](https://twitter.com/dgiotTech)
- [Facebook](https://www.facebook.com/dgiot)
- [Reddit](https://www.reddit.com/r/dgiot/)
- [Weibo](https://weibo.com/dgiot)
- [Blog](https://www.dgiot.cn/blog)

## 预览地址
[腾讯云预览地址](https://dgiotdashboard-8gb17b3673ff6cdd-1253666439.ap-shanghai.app.tcloudbase.com?ftom=git)

## 扫码预览
![dgiot_dashboard.png](http://dgiot-1253666439.cos.ap-shanghai-fsi.myqcloud.com/wechat/dgiot_dashboard.png)


## 开源许可
Apache License 2.0, 详见 [LICENSE](./LICENSE)。
