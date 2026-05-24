# 184个Skills 使用指南

> Hermes Agent 的 184 个可复用技能合集，涵盖 30+ 分类，包含详细使用说明和触发条件。

## 📖 在线访问

**👉 [点击打开 Skills 使用指南](https://jasaonchen.github.io/skills-guide/)**

## 什么是 Skills？

Skills（技能）是 Hermes Agent 的可复用专业能力模块。每个 Skill 封装了特定领域的操作流程、API 调用和最佳实践。Hermes 会根据你的需求自动匹配最合适的技能。

## 如何使用

| 方法 | 说明 | 示例 |
|------|------|------|
| 自然语言 | 直接描述需求，系统自动匹配 | "帮我搜索 GitHub 热门仓库" |
| 指定加载 | 明确告诉 Hermes 加载某个技能 | "加载 github-repo-management 技能" |
| CLI 命令 | 在 CLI 模式下直接调用 | `skill_view('skill-name')` |
| 自动匹配 | 描述需求时，Hermes 自动扫描并加载最匹配的技能 | "我想做个架构图" |

## 技能分类一览

| 分类 | 数量 | 代表技能 |
|------|------|----------|
| 🏠 智能家居 | 8 | homeassistant-automation, smart-light-control |
| 💻 软件开发 | 12 | github-pr-workflow, subagent-driven-development |
| 🤖 AI 自主代理 | 6 | claude-code, hermes-agent, codex |
| 🔬 学术研究 | 8 | arxiv, polymarket, llm-wiki |
| 🎬 媒体内容 | 6 | youtube-content, gif-search |
| 🏠 日常生活 | 8 | find-nearby, online-shopping, smart-home-maintenance |
| 📊 数据分析 | 8 | spotify-analytics, time-series-pandas |
| 🎨 创意设计 | 8 | excalidraw, baoyu-infographic |
| 🛠️ 生产力 | 10 | notion, linear, powerpoint |
| 📱 社交媒体 | 12 | ai-content-planner, social-media-auto |
| 🖥️ 桌面操作 | 4 | desktop-control, browser-automation |
| 🎮 游戏 | 6 | dnd-dungeon-master, cs16-setup |
| 🔧 其他 | 更多... | 30+ 分类等你探索 |

## 文件说明

| 文件 | 说明 |
|------|------|
| `index.html` | 主页 - 分类浏览所有技能 |
| `usage-guide.html` | 每个技能的详细使用指南 |
| `catmap.json` | 分类映射数据 |
| `skills-guide-pdf.html` | PDF 打印版（离线可用） |
| `gen-pdf.ps1` | PDF 生成脚本 |
| `gen-website.ps1` | 网站生成脚本 |

## 更新日志

- **2026-05-24**: 初始版本发布，184 个技能，30+ 分类
