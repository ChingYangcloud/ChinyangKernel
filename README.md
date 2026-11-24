# ChingyangKernel (輕颺)

> *「舟遙遙以輕颺，風飄飄而吹衣。」*

[![Kernel](https://img.shields.io/badge/Kernel-Linux%206.6%20%2F%206.12%20GKI-blue.svg?style=flat-square)](https://android.googlesource.com/)
[![Android](https://img.shields.io/badge/Android-15%20%2F%2016-green.svg?style=flat-square)](https://www.android.com/)
[![Telegram](https://img.shields.io/badge/Channel-@ChingyangKernel-2CA5E0.svg?style=flat-square&logo=telegram)](https://t.me/ChingyangKernel)
[![Website](https://img.shields.io/badge/Website-chingyangkernel.ai.studio-purple.svg?style=flat-square)](https://chingyangkernel.ai.studio)

---

### 💡 关于本项目

由于 **秋刀鱼（@qdykernel）** 长期未跟进新固件与版本更新，等不及了，索性自己动手做！

本项目由 **輕颺** 独立维护与编译，面向 **GKI 6.6 (Android 15)** 与 **GKI 6.12 (Android 16)** 多机型打造（4K 内存页）。在严格对齐官方原厂 `__ksymtab` KABI 符号表（0 缺失、0 CRC 偏差）的基础上，提供更纯粹的内核级隐匿、稳健的基带防护与丝滑的 I/O 调度体验。

---

### 📱 已适配机型列表

| 机型 | 代号 / 平台 | 适配系统 / 固件 | 内核基线 | 关键特性 | KABI 校验 | 发布页 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **一加 Ace 5 至尊版**<br>*(OnePlus Ace 5 Ultra)* | `PLC110` / MT6991 | ColorOS 15 / 16<br>*(Android 15)* | `6.6.118-android15-8`<br>*(OGKI / 4K)* | 风驰调度 HMBIRD · F2FS Dedup<br>BakaSU v4.2.0-rc3 · SuSFS v2.4.0<br>BBG · ADIOS I/O | `8989 / 8989`<br>(100%) | [ak3](https://github.com/ChingYangcloud/ChinyangKernel/releases/tag/ak3) |
| **Redmi K Pad** | `turner` / MT6991 | Xiaomi HyperOS<br>*(Android 15)* | `6.6.118-android15-8`<br>*(GKI 6.6 / 4K)* | 标准 AOSP GKI 6.6<br>BakaSU v4.2.0-rc3 · SuSFS v2.3.0<br>BBG · ADIOS I/O | `9090 / 9090`<br>(100%) | [redmikpad-ak3](https://github.com/ChingYangcloud/ChinyangKernel/releases/tag/redmikpad-ak3) |
| **OnePlus 13 (GLO)** | `CPH2653` / SM8750 | OxygenOS 17<br>*(`17.0.0.102_GLO` / Android 15)* | `6.6.118-android15-8`<br>*(GKI 6.6 / 4K)* | 标准 AOSP GKI 6.6<br>BakaSU v4.2.0-rc3 · SuSFS v2.4.0<br>BBG · ADIOS I/O | `9098 / 9098`<br>(100%) | [oneplus13-ak3](https://github.com/ChingYangcloud/ChinyangKernel/releases/tag/oneplus13-ak3) |
| **真我 GT8 Pro**<br>*(Realme GT8 Pro)* | `RMX5200` / SM8850 | ColorOS / Android 16<br>*(`RMX5200_17.0.1.201`)* | `6.12.69-android16-6`<br>*(GKI 6.12 / 4K / Rust)* | 标准 AOSP GKI 6.12 (原生 Rust)<br>BakaSU v4.2.0-rc3 · SuSFS v2.4.0<br>BBG · ADIOS 3.3.0 I/O | `9933 / 9933`<br>(100%) | [realmegt8pro-ak3](https://github.com/ChingYangcloud/ChinyangKernel/releases/tag/realmegt8pro-ak3) |

> 更多机型适配进度与免费适配投稿请访问官网：[https://chingyangkernel.ai.studio](https://chingyangkernel.ai.studio) 或联系投稿机器人 [@ChingyangKernel_bot](https://t.me/ChingyangKernel_bot)。

---

### ✨ 特性一览

* **GKI 6.6 / 6.12 稳定基线**：严格对齐原厂 AOSP / OEM 符号表（含 6.12 Rust `rust_binder` 等全部导出符号），保障官方闭源硬件驱动（KMI）完整兼容。
* **风驰调度 / 原生基线按机型匹配**：一加 Ace 5 至尊版保留 OGKI `HMBIRD` 风驰调度与 `F2FS Dedup`；其余标准 GKI 机型保持标准 AOSP 4K 页布局与原厂一致的 KABI。
* **BakaSU 内核级 Root**：集成次世代内核 Root（`v4.2.0-rc3`），支持多管理器、动态授权与 sucompat。
* **SuSFS 内核隐匿**：最高集成至 **`v2.4.0`**，支持挂载伪装、路径/属性隐藏、UID 优先过滤与 AVC 访问日志欺骗。
* **Baseband-Guard (BBG)**：基于独立 LSM 架构的基带防护，拦截越权射频操作，守护通信底层与分区安全。
* **ADIOS I/O 调度**：调优闪存高并发读写队列，改善冷启动与存储响应延迟。
* **AnyKernel3 智能刷入**：动态解包本地 `boot.img`，内置核心文件 SHA-256 完整性校验、内核主版本 + 4K 内存页防呆拦截及安全策略检查。

---

### 🤝 引用与致谢

特别鸣谢 **秋刀鱼（@qdykernel）** 团队及其开源项目！其此前优秀的内核架构与调优配置为本项目奠定了坚实基础。

同时衷心感谢以下开源项目与开发者：

* [qdykernel](https://t.me/qdyKernel) by @qdykernel - 基础架构与内核补丁灵感
* [OnePlusOSS](https://github.com/OnePlusOSS) - 一加官方开源内核源码树
* [AOSP Common Kernel](https://android.googlesource.com/kernel/common) - Android 通用内核源码树
* [KernelSU](https://github.com/tiann/KernelSU) by @tiann - 革命性的 Android 内核 Root 方案
* [BakaSU](https://github.com/Baka-SU/BakaSU) - 次世代模块化内核 Root
* [SuSFS](https://gitlab.com/simonpunk/susfs4ksu) by @simonpunk - 强大的内核文件系统隐匿框架
* [Baseband-guard](https://github.com/vc-teahouse/Baseband-guard) by @vc-teahouse - 内核基带 LSM 安全防护层
* [ADIOS](https://github.com/firelzrd/adios) by @firelzrd - 高并发自适应 I/O 调度器
* [AnyKernel3](https://github.com/osm0sis/AnyKernel3) by @osm0sis - 业界标准的动态内核刷写框架

---

### 📢 关注与投稿

* 🚀 **輕颺官方频道**：[https://t.me/ChingyangKernel](https://t.me/ChingyangKernel)
* 🌐 **适配进度官网**：[https://chingyangkernel.ai.studio](https://chingyangkernel.ai.studio)
* 🤖 **免费适配投稿**：[@ChingyangKernel_bot](https://t.me/ChingyangKernel_bot)
* 🐟 **秋刀鱼官方频道**：[https://t.me/qdyKernel](https://t.me/qdyKernel)

---

### 📥 刷入说明

1. **刷入方式**：支持ksu及其分支或第三方工具刷入。
2. **网络与环境要求**：刷机脚本内置安全策略，非特殊缓存环境下请保持非中国大陆 IP 网络畅通，并确保已安装 **Telegram 客户端**，请勿使用国产/系统自带浏览器打开 `t.me`。
3. **安全建议**：刷机无绝对，刷入前请先备份原厂 `boot.img`。

---

### ⚖️ 免责声明

本项目仅供 Linux 内核技术研究与学习交流。请确保具备基本救砖常识，由刷机产生的一切风险请自行承担。
