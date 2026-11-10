# ChingyangKernel (輕颺)

> *「舟遙遙以輕颺，風飄飄而吹衣。」*

[![Kernel](https://img.shields.io/badge/Kernel-Linux%206.6%20GKI-blue.svg?style=flat-square)](https://android.googlesource.com/)
[![Android](https://img.shields.io/badge/Android-15%20(ColorOS%2015)-green.svg?style=flat-square)](https://www.android.com/)
[![Telegram](https://img.shields.io/badge/Channel-@ChingyangKernel-2CA5E0.svg?style=flat-square&logo=telegram)](https://t.me/ChingyangKernel)

---

### 💡 关于本项目 

由于 **秋刀鱼（@qdykernel）** 长期未跟进新固件与版本更新，等不及了，索性自己动手做！

本项目由 **輕颺** 独立维护与编译，专为一加 Ace 5 系列（PLC110）及通用 (GKI 6.6-Android 15 ) 设备打造。在深度适配官方最新 ColorOS 16  如 C.33、C.34 等）的基础上，追求更丝滑的调度响应、更纯粹的隐藏能力与稳健的日常体验。

---

### ✨ 特性一览 

* **GKI 6.6 稳定基线**：完美契合 GKI 6.6-Android 15 ，严格保障官方闭源硬件驱动（KMI）兼容。
* **一加风驰架构 (OGKI)**：深度保留一加专有 `sched_assist` 调度器与 `task_mmu` 调优，丝滑高刷、省电稳帧。
* **BakaSU 内核级 Root**：集成次世代内核 Root（v4.2.0-rc3 / Code: 35257），支持动态授权与 sucompat。
* **SuSFS v2.3.0**：内核级深度隐匿，挂载伪装、特征抹除与 AVC 访问日志欺骗。
* **BBG**：基于独立 LSM 架构的基带防护，拦截越权射频操作，守护通信底层。
* **ADIOS I/O 调度**：调优闪存高并发读写队列，改善冷启动与存储响应延迟。
* **AnyKernel3 智能刷入**：动态解包本地 `boot.img`，零破坏保留原厂签名与启动头，内置网络安全校验与频道拉起。

---

### 🤝 引用与致谢 

特别鸣谢 **秋刀鱼（@qdykernel）** 团队及其开源项目！其此前优秀的内核架构与调优配置为本项目奠定了坚实基础。

同时衷心感谢以下开源项目与开发者：

* [qdykernel](https://t.me/qdyKernel) by @qdykernel - 基础架构与内核补丁灵感
* [OnePlusOSS](https://github.com/OnePlusOSS) - 一加官方开源内核源码树
* [KernelSU](https://github.com/tiann/KernelSU) by @tiann - 革命性的 Android 内核 Root 方案
* [BakaSU](https://github.com/vc-teahouse) by @vc-teahouse - 次世代模块化内核 Root
* [SuSFS](https://gitlab.com/simonpunk/susfs4ksu) by @simonpunk - 强大的内核文件系统隐匿框架
* [Baseband-guard](https://github.com/vc-teahouse/Baseband-guard) by @vc-teahouse - 内核基带 LSM 安全防护层
* [AnyKernel3](https://github.com/osm0sis/AnyKernel3) by @osm0sis - 业界标准的动态内核刷写框架

---

### 📢 关注频道 

* 🚀 **輕颺官方频道**：[https://t.me/ChingyangKernel](https://t.me/ChingyangKernel)
* 🐟 **秋刀鱼官方频道**：[https://t.me/qdyKernel](https://t.me/qdyKernel)

---

### 📥 刷入说明 

1. **刷入方式**：支持通过 **KernelSU及其分支 或第三方工具刷入，不支持Recovery刷入** 。
2. **网络与环境要求**：刷机脚本内置安全策略，刷入时请保持网络畅通，并确保已安装 **Telegram 客户端** 。
3. **安全建议**：刷机无绝对，刷入前请先备份原厂 `boot.img`。

---

### ⚖️ 免责声明 

本项目仅供 Linux 内核技术研究与学习交流。请确保具备基本救砖常识，由刷机产生的一切风险请自行承担。
