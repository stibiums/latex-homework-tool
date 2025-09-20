#!/bin/bash

# LaTeX模板安装脚本
# 此脚本会创建便捷的命令别名和添加到PATH

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 检查是否为交互式shell
if [[ $- == *i* ]]; then
    INTERACTIVE=true
else
    INTERACTIVE=false
fi

print_info "正在安装LaTeX模板工具..."

# 检测shell类型
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
    bash)
        RC_FILE="$HOME/.bashrc"
        ;;
    zsh)
        RC_FILE="$HOME/.zshrc"
        ;;
    fish)
        RC_FILE="$HOME/.config/fish/config.fish"
        ;;
    *)
        print_warning "未识别的shell: $SHELL_NAME，将使用 ~/.bashrc"
        RC_FILE="$HOME/.bashrc"
        ;;
esac

print_info "检测到shell: $SHELL_NAME"
print_info "配置文件: $RC_FILE"

# 创建别名
TEMPLATE_DIR="$HOME/.latex_templates"

# 为bash/zsh添加别名
if [[ "$SHELL_NAME" != "fish" ]]; then
    ALIASES="
# LaTeX模板工具别名
alias create-homework='$TEMPLATE_DIR/create_homework.sh'
alias compile-latex='$TEMPLATE_DIR/compile.sh'
alias latex-help='cat $TEMPLATE_DIR/README.md'

# 快速模板功能
latex-template() {
    if [ \$# -eq 0 ]; then
        echo \"使用方法: latex-template 课程名 作业号 [目标目录]\"
        echo \"示例: latex-template 计算机视觉 1\"
        return 1
    fi
    $TEMPLATE_DIR/create_homework.sh \"\$@\"
}

# 快速编译功能
latex-compile() {
    $TEMPLATE_DIR/compile.sh \"\$@\"
}
"
else
    # Fish shell的语法不同
    ALIASES="
# LaTeX模板工具别名
alias create-homework '$TEMPLATE_DIR/create_homework.sh'
alias compile-latex '$TEMPLATE_DIR/compile.sh'
alias latex-help 'cat $TEMPLATE_DIR/README.md'

# 快速模板功能
function latex-template
    if test (count \$argv) -eq 0
        echo \"使用方法: latex-template 课程名 作业号 [目标目录]\"
        echo \"示例: latex-template 计算机视觉 1\"
        return 1
    end
    $TEMPLATE_DIR/create_homework.sh \$argv
end

# 快速编译功能
function latex-compile
    $TEMPLATE_DIR/compile.sh \$argv
end
"
fi

# 检查是否已经添加过别名
if grep -q "LaTeX模板工具别名" "$RC_FILE" 2>/dev/null; then
    print_warning "别名已存在，正在更新..."

    # 备份原文件
    cp "$RC_FILE" "${RC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

    # 删除旧的别名部分
    if [[ "$SHELL_NAME" != "fish" ]]; then
        sed -i '/# LaTeX模板工具别名/,/^$/d' "$RC_FILE"
    else
        sed -i '/# LaTeX模板工具别名/,/^end$/d' "$RC_FILE"
    fi
else
    # 备份原文件
    if [ -f "$RC_FILE" ]; then
        cp "$RC_FILE" "${RC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
fi

# 添加新的别名
echo "$ALIASES" >> "$RC_FILE"

print_success "别名已添加到 $RC_FILE"

# 创建桌面快捷方式（仅Linux）
if command -v xdg-user-dir &> /dev/null; then
    DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null)
    if [ -d "$DESKTOP_DIR" ]; then
        cat > "$DESKTOP_DIR/LaTeX作业模板.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=LaTeX作业模板
Comment=快速创建LaTeX作业
Exec=gnome-terminal -- bash -c '$TEMPLATE_DIR/create_homework.sh; read -p "按回车键关闭..."'
Icon=accessories-text-editor
Terminal=true
Categories=Office;Education;
EOF
        chmod +x "$DESKTOP_DIR/LaTeX作业模板.desktop"
        print_success "桌面快捷方式已创建"
    fi
fi

print_info "安装完成！现在你可以使用以下命令："
echo
echo "  create-homework 课程名 作业号    # 创建新作业"
echo "  compile-latex 文件名.tex        # 编译LaTeX文件"
echo "  latex-template 课程名 作业号     # 快速创建模板"
echo "  latex-compile 文件名.tex        # 快速编译"
echo "  latex-help                     # 查看帮助"
echo

if [ "$INTERACTIVE" = true ]; then
    read -p "是否立即重新加载shell配置？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "重新加载配置文件..."
        source "$RC_FILE"
        print_success "配置已重新加载！"
    else
        print_info "请手动运行以下命令或重新启动终端："
        echo "  source $RC_FILE"
    fi
else
    print_info "请手动运行以下命令或重新启动终端："
    echo "  source $RC_FILE"
fi

print_success "LaTeX模板工具安装完成！📚"