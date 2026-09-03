# 🧾 AI 会计助手框架

> 版本：**v0.1.0-alpha**（测试版 · 未定稿 · 仅供试跑）
> 一套面向学会计、自己接单的从业者的 **AI 会计助手框架**。
> 能答疑会计知识、帮流水归类记账、解读账目报表——**AI 干活，用户真人确认**，可靠又顺手。

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
├─ ledger/                 账本存放目录（用户个人数据，被 gitignore）
└─ .goose/
   ├─ skills/accounting/SKILL.md   会计技能：答疑/归类/记账准则/报表解读
   ├─ recipes/classify.yaml        流水归类食谱
   └─ recipes/report.yaml          报表月结解读食谱
```

## 📥 依赖下载清单（点一下就下）

**不懂命令行也没关系**，下面每个都点一下链接下载安装包，**双击 → 一路下一步**就能装好：

| 依赖 | 干啥用 | 点这里下载 |
|------|--------|-----------|
| **Goose**（AI 本体） | 类似 Claude Code 的桌面助手 | [goose-docs.ai/desktop](https://goose-docs.ai/desktop) |
| **Node.js 18+** | 让记账桥能运行 | [nodejs.org/en/download](https://nodejs.org/en/download) |
| **hledger**（记账引擎） | 记科目、算账 | [hledger.org](https://hledger.org/) |
| **hledger-mcp** | 让 AI 读/写账本 | 打开命令行粘这行：`npm i -g @iiatlas/hledger-mcp` |

> ⚠️ **Goose 别用 winget 装**（会装成同名数据库工具）——直接用上面链接下桌面版。

这三样装好后，在 **Windows 的 Git Bash** 里跑第 4 步 `bash setup.sh`，它会自动帮你查缺、装 hledger-mcp、生成账本。

## 🚀 快速部署（零基础）

1. 到上面「依赖下载清单」下载并装好 **Goose**（双击 → 一路下一步）
2. 装 **Node.js 18+**，再用 `winget install --id simonmichael.hledger` 装 **hledger**（记账引擎）
3. ⚠️ **【必做】改系统区域为 UTF-8**：控制面板 → 区域 → 管理 → 更改系统区域设置
   → 勾选「Beta: 使用 Unicode UTF-8 提供全球语言支持」→ 重启
   （不改的话，hledger 读不了中文账本——中文 Windows 默认用 GBK 读文件，会报编码错误）
4. 克隆/解压本仓库，在 **Windows 的 Git Bash** 里运行 `bash setup.sh`
   （自动检查依赖、装 hledger-mcp、生成账本；⚠️ 需 Windows 下 Git Bash，Linux/mac 会失败）
5. 把 **DeepSeek key** 写进系统环境变量（Goose 桌面版不读项目 `.env`）：
   在终端执行 `setx DEEPSEEK_API_KEY "sk-你的key"`，然后【重开终端 / 重启 Goose】才生效
6. 打开 Goose，选上 DeepSeek 模型，就能问会计问题、记接单账

> **第 3 步必须做**，否则 hledger 读中文账本会报 `cannot decode ... CP936` 错误。
> `bash setup.sh`（需 Windows 下 Git Bash）会自动检查/安装依赖并生成账本；不熟的找会的人带一遍即可。

## ⚖️ 许可证合规（放心用）

- **Goose**：Apache-2.0 —— 允许改、存、再分发
- **hledger-mcp**：MIT —— 同样宽松
- **DeepSeek API**：调用的是在线服务，不涉代码版权
- **会计技能/食谱**：咱自己写的，无版权问题

> ⚠️ **别把 `.env`（含 key）或 `ledger/*.journal`（账本）传上公开仓库**——`.gitignore` 已拦住。若用 GitHub，建议用**私有仓库**。

## 🎯 核心铁律

- **算钱**（合计、汇总、税率）→ 交给 hledger 账本工具
- **理解判断**（答疑、归类、解读）→ 交给 AI
- **关键操作**（写账）→ 用户真人确认才生效
