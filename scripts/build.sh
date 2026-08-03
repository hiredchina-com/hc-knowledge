#!/usr/bin/env bash
# 构建 hc-knowledge 站点并修复默认 locale 路径
set -uo pipefail

HARNESS_ROOT="${HARNESS_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$HARNESS_ROOT/dist/knowledge-preview}"

bash "$HARNESS_ROOT/bin/build-knowledge-site.sh" \
  --source "$SOURCE_DIR" \
  --config "$HARNESS_ROOT/.harness/knowledge/site.yaml" \
  --output "$OUTPUT_DIR"

# 修复默认 locale 页面路径：将 zh/ 内容复制到根目录，使 /faq/xxx.html 可访问
if [[ -d "$OUTPUT_DIR/zh" ]]; then
  cp -R "$OUTPUT_DIR/zh"/. "$OUTPUT_DIR/"
fi

# 清理不应出现在站点输出中的文件/目录
rm -rf "$OUTPUT_DIR/.git" \
       "$OUTPUT_DIR/.harness-task-id" \
       "$OUTPUT_DIR/.github" \
       "$OUTPUT_DIR/scripts" \
       "$OUTPUT_DIR/zh/.git" \
       "$OUTPUT_DIR/zh/.harness-task-id" \
       "$OUTPUT_DIR/zh/.github" \
       "$OUTPUT_DIR/zh/scripts" \
       "$OUTPUT_DIR/en/.git" \
       "$OUTPUT_DIR/en/.harness-task-id" \
       "$OUTPUT_DIR/en/.github" \
       "$OUTPUT_DIR/en/scripts"

echo "✅ 构建完成（含默认 locale 路径修复）"
