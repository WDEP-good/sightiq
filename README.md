<div align="right">

中文 | [英文](README-en.md)

[![star](https://gitee.com/wdep/sightiq/badge/star.svg?theme=dark)](https://gitee.com/wdep/sightiq/stargazers)
[![fork](https://gitee.com/wdep/sightiq/badge/fork.svg?theme=dark)](https://gitee.com/wdep/sightiq/members)

## SightIQ 介绍

<div align="center">
<img width="900px" src="./logo.png"></img>
</div>
</div>
 
<div align="center">

<h1 style="border-bottom: none">
<br>
    快速实时数据处理及可视一体化
<br />
</h1>
</div>

<hr/>

# 硬件部分

- 摄像头部分(k3s) shifu/树莓派

![项目流程](硬件部分架构.svg)

# 数据处理部分
- kafaka/flink/大模型分析(k8s) python

# 数据存储部分
- startrocks(k8s) SQL

# 服务端
- server/Redis(k8s) Rust

# 服务端安全
- nginx/kong(k8s) shell

# 客户端
- 前端部分(k8s) Vite+vue


整体架构
![项目流程](project-Flow.svg)
