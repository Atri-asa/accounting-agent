@echo off
chcp 65001 >nul
echo.
echo  ============================================
echo     会计助手  一键安装
echo  ============================================
echo.
echo [1/4] 安装 Node.js（记账桥需要）...
winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements >nul 2>&1 && echo  --- 完成 || echo  --- 失败，请手动装：nodejs.org/en/download
echo.
echo [2/4] 安装 hledger（记账引擎）...
winget install -e --id simonmichael.hledger --accept-source-agreements --accept-package-agreements >nul 2>&1 && echo  --- 完成 || echo  --- 失败，请手动装：hledger.org
echo.
echo [3/4] 安装 hledger-mcp（让 AI 能记账）...
set "PATH=%PATH%;%ProgramFiles%\nodejs"
npm install -g @iiatlas/hledger-mcp >nul 2>&1 && echo  --- 完成 || echo  --- 失败，请先装好 Node 再重跑本脚本
echo.
echo [4/4] 打开 Goose 下载页（AI 本体）...
start "" https://goose-docs.ai/desktop
echo.
echo 装完后接下来：
echo   1. 改系统区域为 UTF-8（否则读不了中文账本）：控制面板→区域→管理→
echo      更改系统区域设置→勾选「Unicode UTF-8」→重启
echo   2. 重开终端，运行 bash setup.sh（会自动生成账本）
echo   3. 在 .env 里填 DeepSeek key
echo   4. 装好 Goose 后打开就能用了
echo.
pause
