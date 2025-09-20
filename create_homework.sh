#!/bin/bash

# LaTeX作业快速创建脚本
# 使用方法: ./create_homework.sh 课程名 作业号 [目标目录]

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数：打印彩色信息
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

# 检查参数
if [ $# -lt 2 ]; then
    print_error "参数不足！"
    echo "使用方法: $0 课程名 作业号 [目标目录]"
    echo "示例: $0 计算机视觉 1"
    echo "示例: $0 数学分析 2 ~/Documents/math_homework/"
    exit 1
fi

COURSE_NAME="$1"
HW_NUM="$2"
TARGET_DIR="${3:-$(pwd)}"

# 确保目标目录存在
if [ ! -d "$TARGET_DIR" ]; then
    print_info "创建目录: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# 生成文件名
FILENAME="${COURSE_NAME}_作业${HW_NUM}.tex"
FILEPATH="$TARGET_DIR/$FILENAME"

# 检查文件是否已存在
if [ -f "$FILEPATH" ]; then
    print_warning "文件已存在: $FILEPATH"
    read -p "是否覆盖？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "操作已取消"
        exit 0
    fi
fi

# 检查模板文件是否存在
TEMPLATE_PATH="$HOME/.latex_templates/universal_homework.tex"
if [ ! -f "$TEMPLATE_PATH" ]; then
    print_error "模板文件不存在: $TEMPLATE_PATH"
    print_info "请确保已正确安装LaTeX模板"
    exit 1
fi

print_info "正在创建作业文件..."

# 复制模板并替换占位符
cp "$TEMPLATE_PATH" "$FILEPATH"

# 获取用户信息（如果之前设置过的话）
USER_NAME=$(git config user.name 2>/dev/null || echo "请填写姓名")
USER_EMAIL=$(git config user.email 2>/dev/null || echo "")

# 提示用户输入信息
echo
print_info "请输入以下信息（直接回车使用默认值）:"

read -p "姓名 [$USER_NAME]: " INPUT_NAME
STUDENT_NAME="${INPUT_NAME:-$USER_NAME}"

read -p "学号 [请填写学号]: " INPUT_ID
STUDENT_ID="${INPUT_ID:-请填写学号}"

read -p "院系 [请填写院系]: " INPUT_DEPT
DEPARTMENT="${INPUT_DEPT:-请填写院系}"

read -p "学期 [2025年秋季学期]: " INPUT_SEMESTER
SEMESTER="${INPUT_SEMESTER:-2025年秋季学期}"

# 使用sed替换占位符
print_info "正在配置作业参数..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/\\\\newcommand{\\\\coursename}{课程名称}/\\\\newcommand{\\\\coursename}{$COURSE_NAME}/g" "$FILEPATH"
    sed -i '' "s/\\\\newcommand{\\\\hwnum}{1}/\\\\newcommand{\\\\hwnum}{$HW_NUM}/g" "$FILEPATH"
    sed -i '' "s/\\\\newcommand{\\\\studentname}{姓名}/\\\\newcommand{\\\\studentname}{$STUDENT_NAME}/g" "$FILEPATH"
    sed -i '' "s/\\\\newcommand{\\\\studentid}{学号}/\\\\newcommand{\\\\studentid}{$STUDENT_ID}/g" "$FILEPATH"
    sed -i '' "s/\\\\newcommand{\\\\department}{院系}/\\\\newcommand{\\\\department}{$DEPARTMENT}/g" "$FILEPATH"
    sed -i '' "s/\\\\newcommand{\\\\semester}{2025年秋季学期}/\\\\newcommand{\\\\semester}{$SEMESTER}/g" "$FILEPATH"
else
    # Linux
    sed -i "s/\\\\newcommand{\\\\coursename}{课程名称}/\\\\newcommand{\\\\coursename}{$COURSE_NAME}/g" "$FILEPATH"
    sed -i "s/\\\\newcommand{\\\\hwnum}{1}/\\\\newcommand{\\\\hwnum}{$HW_NUM}/g" "$FILEPATH"
    sed -i "s/\\\\newcommand{\\\\studentname}{姓名}/\\\\newcommand{\\\\studentname}{$STUDENT_NAME}/g" "$FILEPATH"
    sed -i "s/\\\\newcommand{\\\\studentid}{学号}/\\\\newcommand{\\\\studentid}{$STUDENT_ID}/g" "$FILEPATH"
    sed -i "s/\\\\newcommand{\\\\department}{院系}/\\\\newcommand{\\\\department}{$DEPARTMENT}/g" "$FILEPATH"
    sed -i "s/\\\\newcommand{\\\\semester}{2025年秋季学期}/\\\\newcommand{\\\\semester}{$SEMESTER}/g" "$FILEPATH"
fi

print_success "作业文件创建成功: $FILEPATH"

# 询问是否立即编译
echo
read -p "是否立即编译LaTeX文件？(y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "正在编译LaTeX文件..."

    cd "$TARGET_DIR"

    # 检查xelatex是否可用
    if ! command -v xelatex &> /dev/null; then
        print_error "xelatex 未找到，请安装LaTeX发行版"
        exit 1
    fi

    # 编译
    print_info "第一次编译..."
    xelatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        print_info "第二次编译..."
        xelatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            print_success "编译成功！"

            # 清理临时文件
            BASENAME=$(basename "$FILENAME" .tex)
            rm -f "${BASENAME}.aux" "${BASENAME}.log" "${BASENAME}.toc" "${BASENAME}.out"

            # 尝试打开PDF
            PDF_FILE="${BASENAME}.pdf"
            if [ -f "$PDF_FILE" ]; then
                print_info "生成的PDF文件: $TARGET_DIR/$PDF_FILE"

                # 在不同系统上打开PDF
                if command -v xdg-open &> /dev/null; then
                    read -p "是否打开PDF文件？(y/N): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        xdg-open "$PDF_FILE" 2>/dev/null &
                    fi
                fi
            fi
        else
            print_error "编译失败，请检查LaTeX语法"
        fi
    else
        print_error "编译失败，请检查LaTeX语法"
    fi
fi

echo
print_info "使用说明:"
echo "1. 编辑 $FILENAME 完成你的作业"
echo "2. 使用 'xelatex $FILENAME' 编译"
echo "3. 查看模板说明: ~/.latex_templates/README.md"

echo
print_success "作业创建完成！祝你写作顺利！📚"