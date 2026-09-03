#!/usr/bin/env bash
# ============================================================
# AI 会计助手 —— 一键配置向导 (Git Bash / Linux)
# 自动检查/装依赖、生成配置 + 账本、提醒改系统区域
# 用法：bash setup.sh
# ============================================================
cd "$(dirname "$0")"

say()  { echo -e "\n\e[1m$1\e[0m"; }
ok()   { echo "  ✅ $1"; }
warn() { echo "  ⚠️  $1"; }
info() { echo "  ℹ️  $1"; }

say "🧾 会计 Agent 配置开始..."

say "── 1) 检查/装依赖 ──"

if command -v goose >/dev/null 2>&1; then ok "goose 已装"; else
  warn "goose 未装（AI agent 本体）→ 官网装桌面版: https://goose-docs.ai/"
fi

if command -v node >/dev/null 2>&1; then ok "Node $(node -v) 已装"; else
  warn "Node 未装，尝试 winget 自动装..."; winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements 2>/dev/null && ok "Node 已装（新终端生效）" || warn "请装 Node.js 18+: https://nodejs.org/"
fi

if command -v hledger >/dev/null 2>&1; then ok "hledger $(hledger --version 2>/dev/null|cut -d' ' -f1) 已装"; else
  warn "hledger 未装，尝试 winget 自动装..."; winget install -e --id simonmichael.hledger --accept-source-agreements --accept-package-agreements 2>/dev/null && ok "hledger 已装（新终端生效）" || warn "请装: winget install --id simonmichael.hledger"
fi

if command -v hledger-mcp >/dev/null 2>&1; then ok "hledger-mcp 已装"; else
  if command -v npm >/dev/null 2>&1; then
    warn "hledger-mcp 未装，正在 npm 全局装..."; npm install -g @iiatlas/hledger-mcp >/dev/null 2>&1 && ok "hledger-mcp 已装" || warn "npm 安装失败（查网络/Node）"
  else warn "缺 npm（要先有 Node）"; fi
fi

say "── 2) 探测工具路径（供配置用）──"
NP="$(npm prefix -g 2>/dev/null)"
HLEDGER_ENTRY="$(cygpath -m "$NP"/node_modules/@iiatlas/hledger-mcp/build/index.js 2>/dev/null)"
LEDGER_WIN="$(cygpath -m "$(pwd)/ledger/master.journal" 2>/dev/null || echo "$$(pwd)/ledger/master.journal")"
[ -f "$HLEDGER_ENTRY" ] && ok "记账入口已找到" || warn "hledger-mcp 入口未找到（可能未装成功）"
info "将写入 config 的入口: $HLEDGER_ENTRY"

say "── 3) 生成 .env / 账本 ──"
[ -f .env ] || { cp .env.example .env; info "已生成 .env，填入 DeepSeek key"; }
mkdir -p ledger
[ -f ledger/master.journal ] || cat > ledger/master.journal <<'EOF'
; 用户会计账本 master.journal（示例，需系统区域 UTF-8 才能读中文）
2026/01/01 初始化
    assets:cash                    10000
        equity:opening
EOF
ok "账本就位: ledger/master.journal"

say "── 4) 生成 config.local.yaml（含记账扩展，路径已按本机自动填好）──"
cat > config.local.yaml <<CONFIG
# 本机自动生成版（对照 config.yaml.example）
# 复制/合并到: %APPDATA%\\Block\\goose\\config\\config.yaml
model_provider: deepseek
providers:
  deepseek:
    name: deepseek
    engine: openai
    display_name: DeepSeek
    base_url: https://api.deepseek.com/v1
    api_key_env: DEEPSEEK_API_KEY
    supports_streaming: true
    models:
      deepseek-chat: {name: deepseek-chat, max_output_tokens: 4096}
extensions:
  hledger-mcp:
    enabled: true
    type: stdio
    name: "hledger 记账"
    description: "读/写本地 hledger 账本"
    cmd: node
    args:
      - "$HLEDGER_ENTRY"
      - "$LEDGER_WIN"
      - "--read-only"
    timeout: 300
CONFIG
ok "已生成 config.local.yaml"

say "── 5) 检测系统区域（hledger 能否读中文）──"
ACP="$(reg query "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage" //v ACP 2>/dev/null | grep -ioE '[0-9]{3}' | head -1)"
if [ "$ACP" = "65001" ]; then
  ok "系统区域已是 UTF-8，hledger 可读中文账本"
else
  warn "系统区域当前为 GBK(ACP=${ACP:-936})，hledger 读不了中文账本！必改："
  warn "控制面板 → 区域 → 管理 → 更改系统区域设置 → 勾选「Beta: 使用 Unicode UTF-8 提供全球语言支持」→ 重启"
fi

say "✅ 配置完成！接下来："
echo "  1. 把 config.local.yaml 内容复制/合并到  %APPDATA%\\Block\\goose\\config\\config.yaml"
echo "  2. .env 里填 DEEPSEEK_API_KEY"
echo "  3. 若提示改系统区域，改完后重启电脑"
echo "  4. 装 Goose 桌面版，打开后问一个会计问题试试"
