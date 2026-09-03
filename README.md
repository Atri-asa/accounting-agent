# 🧾 弟弟的会计 Agent

> 给大学学会计、自己接单的弟弟做的一套 **AI 会计助手框架**。
> 能答疑会计知识、帮流水归类记账、解读账目报表——**AI 干活，弟弟真人确认**，可靠又顺手。

## 🧩 这套框架由三块组成

| 块 | 用啥 | 干嘛 |
|----|------|------|
| **Agent 底座** | [Goose](https://goose-docs.ai/)（Apache-2.0，免费开源） | 类似 Claude Code 的 AI agent，桌面 App 好上手 |
| **记账能力** | [hledger-mcp](https://github.com/IiAtlas/hledger-mcp)（MIT）+ hledger | 让 AI 能**读写本地账本** |
| **会计技能** | `.goose/` 下咱自己写的技能/食谱 | 答疑、归类、报表解读 |

**模型**：DeepSeek API（OpenAI 兼容）。也可以换本地 Ollama，完全免费离线跑。

## 📁 目录结构

```
accounting-agent/
├─ config.yaml.example     Goose 配置模板（DeepSeek + 记账MCP）
├─ .env.example            环境变量示例（注意：别填真 key 进仓库）
├─ .gitignore              保护 key 和账本
├─ setup.sh                一键配置脚本
├─ ledger/                 账本存放目录（弟弟个人数据，被 gitignore）
└─ .goose/
   ├─ skills/accounting/SKILL.md   会计技能：答疑/归类/记账准则/报表解读
   ├─ recipes/classify.yaml        流水归类食谱
   └─ recipes/report.yaml          报表月结解读食谱
```

## 🚀 弟弟怎么装（零基础）

1. 装 **Goose**（桌面版）：官网下载安装，见下方链接
2. 装 **Node.js 18+**，再用 `winget install --id simonmichael.hledger` 装 **hledger**（记账引擎）
3. ⚠️ **【必做】改系统区域为 UTF-8**：控制面板 → 区域 → 管理 → 更改系统区域设置
   → 勾选「Beta: 使用 Unicode UTF-8 提供全球语言支持」→ 重启
   （不改的话，hledger 读不了中文账本——中文 Windows 默认用 GBK 读文件，会报编码错误）
4. 克隆/解压本仓库，运行 `bash setup.sh`（自动检查依赖、装 hledger-mcp、生成账本）
5. 在 `.env` 里填自己的 **DeepSeek API key**
6. 打开 Goose，选上 DeepSeek 模型，就能问会计问题、记接单账

> **第 3 步必须做**，否则 hledger 读中文账本会报 `cannot decode ... CP936` 错误。
> `bash setup.sh` 会自动检查/安装依赖并生成账本；不熟的找会的人带一遍即可。

## ⚖️ 许可证合规（放心用）

- **Goose**：Apache-2.0 —— 允许改、存、再分发
- **hledger-mcp**：MIT —— 同样宽松
- **DeepSeek API**：调用的是在线服务，不涉代码版权
- **会计技能/食谱**：咱自己写的，无版权问题

> ⚠️ **别把 `.env`（含 key）或 `ledger/*.journal`（账本）传上公开仓库**——`.gitignore` 已拦住。若用 GitHub，建议用**私有仓库**。

## 🎯 核心铁律

- **算钱**（合计、汇总、税率）→ 交给 hledger 账本工具
- **理解判断**（答疑、归类、解读）→ 交给 AI
- **关键操作**（写账）→ 弟弟真人确认才生效
